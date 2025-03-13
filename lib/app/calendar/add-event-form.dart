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
import 'package:pawpocket/services/pet_firestore.dart';

class AddEventForm extends StatefulWidget {
  const AddEventForm({super.key});

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
  String? dropdownValue;
  String gender = "";
  final _formKey = GlobalKey<FormState>();

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

                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isChoosePet ? Colors.grey[400]! : Colors.redAccent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: DropdownButton(
                    itemHeight: 60,
                    underline: Container(),
                    padding: EdgeInsets.all(10),
                    borderRadius: BorderRadius.circular(15),
                    value: dropdownValue,
                    isExpanded: true,
                    onChanged: (String? value) {
                      if (value != null && value != "") {
                        isChoosePet = true;
                      }
                      setState(() {
                        dropdownValue = value;
                      });
                    },
                    items: List.generate(petList.length, (int index) {
                      DocumentSnapshot document = petList[index];
                      String docId = document.id;
                      var eachPet = Pet.fromMap(
                        petList[index].data() as Map<String, dynamic>,
                        docId,
                      );
                      return DropdownMenuItem(
                        value: eachPet.uuid,
                        child: Row(
                          children: [
                            Container(
                              clipBehavior: Clip.antiAlias,
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Image.file(
                                File(eachPet.petImage),
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(eachPet.petName),
                          ],
                        ),
                      );
                    }),
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
            SizedBox(height: 20),
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
            SizedBox(height: 20),
            Text("Descriptions", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            MultipleLineTextFormField(
              descController: _descController,
              title: "Description",
              textSize: 18,
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    overlayColor: WidgetStateProperty.all(Colors.amberAccent),
                    checkboxShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    contentPadding: EdgeInsets.all(0),
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      "Marks this as a medical appointment",
                      style: TextStyle(fontSize: 16),
                    ),
                    checkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: BorderSide(width: 1, color: Colors.grey[400]!),
                    fillColor: WidgetStateColor.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return Color.fromARGB(255, 66, 133, 244);
                      }
                      return Colors.white;
                    }),
                    value: isCheckMedical,
                    onChanged: (value) {
                      setState(() {
                        isCheckMedical = value!;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                // Expanded(
                // ),
              ],
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (dropdownValue == "" || dropdownValue == null) {
                        setState(() {
                          isChoosePet = false;
                        });
                        return;
                      }
                      Event newEvent = Event(
                        userId: "userid",
                        petId: dropdownValue!,
                        title: _titleController.text,
                        date: _dateController.text,
                        time: _timeController.text,
                        location: _locationController.text,
                        descriptions: _descController.text,
                        isMedical: isCheckMedical,
                        startEvent: DateTime.parse(_dateController.text),
                        color: selectedColor.toARGB32(),
                      );
                      eventFirestoreService.addEvent(newEvent);
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
                    }
                    if (dropdownValue == null) {
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
