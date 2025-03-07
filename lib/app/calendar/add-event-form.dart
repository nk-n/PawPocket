import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawpocket/app/add-pet/each-form-field.dart';
import 'package:pawpocket/app/add-pet/multipleline-form-field.dart';
import 'package:pawpocket/app/calendar/date-time-field.dart';
import 'package:pawpocket/model/event.dart';

class AddEventForm extends StatefulWidget {
  const AddEventForm({super.key});

  @override
  State<AddEventForm> createState() => _AddEventFormState();
}

class _AddEventFormState extends State<AddEventForm> {
  bool showTimeSelect = false;
  bool isCheckMedical = false;
  final _nameController = TextEditingController();
  final _titleController = TextEditingController();
  final _likeController = TextEditingController();
  final _dateFromController = TextEditingController();
  final _timeFromController = TextEditingController();
  final _dateToController = TextEditingController();
  final _timeToController = TextEditingController();
  final _descController = TextEditingController();
  String? dropdownValue = "Butter, British Shorthair cat";
  String gender = "";
  final _formKey = GlobalKey<FormState>();
  final List<String> pet = [
    "Butter, British Shorthair cat",
    "Carrot, British Thai Dog",
  ];

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
            Container(
              child: DropdownButton(
                itemHeight: 60,
                underline: Container(),
                padding: EdgeInsets.all(10),
                borderRadius: BorderRadius.circular(15),
                value: dropdownValue,
                isExpanded: true,
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value;
                  });
                },
                items:
                    pet.map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Container(
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                child: Image.asset(
                                  "assets/images/gallery_icon.png",
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(value),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[400]!, width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
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
              dateController: _dateFromController,
              timeController: _timeFromController,
            ),
            DateTimeField(
              needTime: true,
              fontSize: 18,
              dateController: _dateToController,
              timeController: _timeToController,
            ),
            SizedBox(height: 20),
            EachFormField(
              label: "Location",
              controller: _likeController,
              textSize: 18,
            ),
            SizedBox(height: 20),
            Text("Descriptions", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            MultipleLineTextFormField(descController: _descController),
            SizedBox(height: 15),
            Row(
              children: [
                Transform.scale(
                  scale: 1.5,
                  child: Checkbox(
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
                Expanded(
                  child: Text(
                    "Marks this as a medical appointment",
                    style: TextStyle(fontSize: 16),
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
                    if (_formKey.currentState!.validate()) {
                      // Event newPet = new Event(
                      //   pet: pet,
                      //   title: _titleController.text,
                      //   dateStart: _dateFromController.text,
                      //   timeStart: _timeFromController.text,
                      //   dateStop: _dateToController.text,
                      //   timeStop: _timeToController.text,
                      //   location: "",
                      //   descriptions: _descController.text,
                      //   isMedical: isCheckMedical,
                      // );
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
