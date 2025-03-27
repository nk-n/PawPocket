import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawpocket/app/add-pet/each-form-field.dart';
import 'package:pawpocket/app/add-pet/multipleline-form-field.dart';
import 'package:pawpocket/app/calendar/date-time-field.dart';
import 'package:pawpocket/model/event.dart';
import 'package:pawpocket/model/pet.dart';
import 'package:pawpocket/services/event_firestore.dart';
import 'package:pawpocket/services/image_manager.dart';
import 'package:pawpocket/services/pet_firestore.dart';
import 'package:uuid/uuid.dart';

class AddEventForm extends StatefulWidget {
  const AddEventForm({super.key, required this.status, required this.event});

  final String status;
  final Event? event;

  @override
  State<AddEventForm> createState() => _AddEventFormState();
}

class _AddEventFormState extends State<AddEventForm> {
  PetFirestoreService petFirestoreService = PetFirestoreService();
  EventFirestoreService eventFirestoreService = EventFirestoreService();
  bool showTimeSelect = false;
  bool isCheckMedical = false;
  Color selectedColor = Colors.blueAccent;
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _descController = TextEditingController();
  bool isChoosePet = true;
  String dropdownValue = "medical";
  String gender = "";
  final _formKey = GlobalKey<FormState>();
  List<Pet> choosePet = [];

  void getAllChoosePet(List<String>? idList) async {
    if (idList == null) return;
    for (int i = 0; i < idList.length; i++) {
      var data = await petFirestoreService.getPet();
      for (int j = 0; j < data.docs.length; j++) {
        if (data.docs.isNotEmpty) {
          Pet item = Pet.fromMap(
            data.docs[j].data() as Map<String, dynamic>,
            data.docs[j].id,
          );
          if (item.uuid == idList[i]) {
            choosePet.add(item);
            break;
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.event == null) return;
    if (widget.status == "update") {
      getAllChoosePet(widget.event!.petId);
      _titleController.text = widget.event!.title;
      _dateController.text = widget.event!.date;
      _timeController.text = widget.event!.time;
      selectedColor = Color(widget.event!.color);
      _locationController.text = widget.event!.location;
      _descController.text = widget.event!.descriptions;
      // isCheckMedical = widget.event!.isMedical;
    }
  }

  bool isPetChoose(Pet targetPet) {
    for (int i = 0; i < choosePet.length; i++) {
      if (choosePet[i].uuid == targetPet.uuid) {
        return true;
      }
    }
    return false;
  }

  void findPetChoose(Pet targetPet) {
    setState(() {
      choosePet = List.from(choosePet); // สร้าง List ใหม่
      for (int i = 0; i < choosePet.length; i++) {
        if (choosePet[i].uuid == targetPet.uuid) {
          choosePet.removeAt(i);
          return;
        }
      }
      choosePet.add(targetPet);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pet", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            StreamBuilder(
              stream: petFirestoreService.getPetStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('ERROR: ${snapshot.error}');
                }
                var petList = snapshot.data?.docs ?? [];

                return GestureDetector(
                  onTap:
                      () => showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            contentPadding: EdgeInsets.all(25),
                            content: StatefulBuilder(
                              builder: (context, setState) {
                                return SizedBox(
                                  width: 400,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Choose Pet",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      SizedBox(
                                        height: 300,
                                        child: ListView.builder(
                                          itemCount: petList.length,
                                          itemBuilder: (
                                            BuildContext context,
                                            int index,
                                          ) {
                                            Pet targetPet = Pet.fromMap(
                                              petList[index].data()
                                                  as Map<String, dynamic>,
                                              petList[index].id,
                                            );
                                            return Container(
                                              margin: EdgeInsets.only(
                                                bottom: 10,
                                              ),
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  overlayColor:
                                                      WidgetStateProperty.all(
                                                        Colors.black12,
                                                      ),
                                                  shape: WidgetStateProperty.all(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            15,
                                                          ),
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      WidgetStateProperty.resolveWith<
                                                        Color?
                                                      >((states) {
                                                        if (isPetChoose(
                                                          targetPet,
                                                        )) {
                                                          return Colors
                                                              .green[300]; // เมื่อกดปุ่ม เปลี่ยนเป็นน้ำเงิน
                                                        } else {
                                                          return Colors
                                                              .white; // ค่าเริ่มต้น
                                                        }
                                                      }),
                                                  padding:
                                                      WidgetStateProperty.all(
                                                        EdgeInsets.all(10),
                                                      ),
                                                ),
                                                onPressed: () {
                                                  findPetChoose(targetPet);
                                                },
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              100,
                                                            ),
                                                      ),
                                                      child: Container(
                                                        width: 60,
                                                        height: 60,
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                100,
                                                              ),
                                                        ),
                                                        child: Image.network(
                                                          ImageManager()
                                                              .getImageUrl(
                                                                targetPet
                                                                    .petImage,
                                                              ),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      "${targetPet.petName}, ${targetPet.petBreed}",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          shape: WidgetStatePropertyAll(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          overlayColor: WidgetStatePropertyAll(
                                            Colors.white10,
                                          ),
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                                Color.fromARGB(
                                                  255,
                                                  66,
                                                  133,
                                                  244,
                                                ),
                                              ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Submit",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                  child: Container(
                    height: choosePet.isEmpty ? 60 : null,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            isChoosePet ? Colors.grey[400]! : Colors.redAccent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.all(10),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: choosePet.length,
                      itemBuilder: (BuildContext context, int indexChoosePet) {
                        Pet eachChoosePet = choosePet[indexChoosePet];
                        return Row(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Image.network(
                                  ImageManager().getImageUrl(
                                    eachChoosePet.petImage,
                                  ),
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "${eachChoosePet.petName}, ${eachChoosePet.petBreed}",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            EachFormField(
              label: "Title",
              controller: _titleController,
              textSize: 18,
            ),
            DateTimeField(
              needTime: true,
              fontSize: 18,
              dateController: _dateController,
              timeController: _timeController,
            ),
            SizedBox(height: 20),
            Text("Color", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: BlockPicker(
                availableColors: [
                  Colors.blueAccent,
                  Colors.redAccent,
                  Colors.orangeAccent,
                  Colors.green,
                  Colors.pinkAccent,
                  Colors.blueGrey,
                  Colors.purple,
                  Colors.deepOrange,
                ],
                pickerColor: selectedColor,
                onColorChanged:
                    (color) => setState(() => selectedColor = color),
                layoutBuilder: (context, colors, child) {
                  return GridView.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [for (Color color in colors) child(color)],
                  );
                },
              ),
            ),
            EachFormField(
              label: "Location",
              controller: _locationController,
              textSize: 18,
            ),
            Text("Descriptions", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            MultipleLineTextFormField(
              descController: _descController,
              title: "Description",
              textSize: 18,
            ),
            SizedBox(height: 20),
            Text("Type of event", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: DropdownButton(
                      padding: EdgeInsets.all(10),
                      value: dropdownValue,
                      underline: Container(),
                      borderRadius: BorderRadius.circular(15),
                      isExpanded: true,
                      items: [
                        DropdownMenuItem(
                          value: 'medical',
                          child: Text("Medical"),
                        ),
                        DropdownMenuItem(
                          value: 'hygiene',
                          child: Text("Hygiene"),
                        ),
                        DropdownMenuItem(
                          value: 'nutrition',
                          child: Text("Nutrition"),
                        ),
                        DropdownMenuItem(
                          value: 'exercise',
                          child: Text("Exercise & Activity"),
                        ),
                        DropdownMenuItem(
                          value: 'training',
                          child: Text("Training & Behavior"),
                        ),
                        DropdownMenuItem(
                          value: 'travel',
                          child: Text("Travel"),
                        ),
                        DropdownMenuItem(
                          value: 'housing',
                          child: Text("Housing & Environment"),
                        ),
                        DropdownMenuItem(
                          value: 'others',
                          child: Text("Others"),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        choosePet.isNotEmpty) {
                      List<String> choosePetId =
                          choosePet.map((item) => item.uuid).toList();
                      Event newEvent = Event(
                        userId: "userid",
                        petId: choosePetId,
                        title: _titleController.text,
                        date: _dateController.text,
                        time: _timeController.text,
                        location: _locationController.text,
                        descriptions: _descController.text,
                        type: dropdownValue,
                        startEvent: DateTime.parse(_dateController.text),
                        color: selectedColor.toARGB32(),
                        uuid: widget.event?.uuid ?? Uuid().v4(),
                        isComplete: false,
                      );
                      if (widget.status == "add") {
                        eventFirestoreService.addEvent(newEvent);
                      } else if (widget.status == "update") {
                        eventFirestoreService.updateEvent(
                          newEvent.uuid,
                          newEvent,
                        );
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 40,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Create event successfully",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: Colors.green[400],
                        ),
                      );
                      Navigator.pop(context);
                    } else if (choosePet.isEmpty) {
                      setState(() {
                        isChoosePet = false;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 66, 133, 244),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
