import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawpocket/app/add-pet/each-form-field.dart';
import 'package:pawpocket/app/add-pet/multipleline-form-field.dart';
import 'package:pawpocket/model/pet.dart';

class AddPetForm extends StatefulWidget {
  const AddPetForm({super.key});

  @override
  State<AddPetForm> createState() => _AddPetFormState();
}

class _AddPetFormState extends State<AddPetForm> {
  final _nameController = TextEditingController();
  final _speciesController = TextEditingController();
  final _dateController = TextEditingController();
  final _likeController = TextEditingController();
  final _dislikeController = TextEditingController();
  final _descController = TextEditingController();
  String? _selectedImage = "";
  String gender = "male";
  final _formkey = GlobalKey<FormState>();
  bool isPictureError = false;

  void updateGender(String value) {
    setState(() {
      gender = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _selectDate() async {
      DateTime? _picked = await showDatePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        initialDate: DateTime.now(),
      );

      if (_picked != null) {
        setState(() {
          _dateController.text = _picked.toString().split(" ")[0];
        });
      }
    }

    Future _pickImageFromGallery() async {
      final returnedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (returnedImage == null) return;
      setState(() {
        _selectedImage = returnedImage.path;
      });
    }

    return Padding(
      padding: const EdgeInsets.all(25),
      child: Form(
        key: _formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder:
                      (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                  child: IconButton(
                    key: ValueKey(gender),
                    onPressed: () {
                      updateGender("male");
                    },
                    color: Colors.blue[400],
                    style: IconButton.styleFrom(
                      backgroundColor:
                          gender == "male"
                              ? Colors.blue[400]
                              : Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                        side: BorderSide(
                          color: Colors.blue[400] ?? Colors.blue,
                          width: 3,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    icon: ImageIcon(
                      AssetImage("assets/images/male_icon.png"),
                      color: gender == "male" ? Colors.white : null,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder:
                      (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                  child: IconButton(
                    key: ValueKey(gender),
                    onPressed: () {
                      updateGender("female");
                    },
                    color: Colors.pink[300],
                    style: IconButton.styleFrom(
                      backgroundColor:
                          gender == "female"
                              ? Colors.pink[300]
                              : Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                        side: BorderSide(
                          color: Colors.pink[300] ?? Colors.pink,
                          width: 3,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    icon: ImageIcon(
                      AssetImage("assets/images/female_icon.png"),
                      color: gender == "female" ? Colors.white : null,
                    ),
                  ),
                ),
              ],
            ),
            EachFormField(
              label: "Name",
              controller: _nameController,
              textSize: 18,
            ),
            EachFormField(
              label: "Species",
              controller: _speciesController,
              textSize: 18,
            ),
            Text("Birthday", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            TextFormField(
              validator: (value) {
                if (value == "" || value == null) {
                  return "Please select some date";
                }
                return null;
              },
              readOnly: true,
              onTap: () {
                _selectDate();
              },
              controller: _dateController,
              decoration: InputDecoration(
                errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.redAccent, width: 2),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.redAccent, width: 2),
                ),
                filled: true,
                fillColor: Colors.transparent,
                prefixIcon: Icon(Icons.calendar_today),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400]!, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue[400] ?? Colors.blue,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            EachFormField(
              label: "Likes",
              controller: _likeController,
              textSize: 18,
            ),
            EachFormField(
              label: "Dislikes",
              controller: _dislikeController,
              textSize: 18,
            ),
            Text("Pet Image", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: isPictureError ? Colors.redAccent : Colors.grey[400]!,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _selectedImage == ""
                        ? Container(
                          margin: const EdgeInsets.symmetric(vertical: 30),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.asset(
                              "assets/images/gallery_icon.png",
                            ),
                          ),
                        )
                        : SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 30),
                                      clipBehavior: Clip.antiAlias,
                                      height: 150,
                                      child:
                                          _selectedImage != null
                                              ? Image.file(
                                                File(_selectedImage!),
                                                alignment: Alignment.center,
                                                fit: BoxFit.cover,
                                              )
                                              : Image.asset(""),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ElevatedButton(
                      onPressed: () async {
                        final returnedImage = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );
                        if (returnedImage == null) return;
                        setState(() {
                          _selectedImage = returnedImage.path;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        overlayColor: Colors.white,
                        backgroundColor: Color.fromARGB(255, 66, 133, 244),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Choose image",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("Descriptions", style: TextStyle(fontSize: 18)),
            MultipleLineTextFormField(descController: _descController),
            SizedBox(height: 10),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate() &&
                        _selectedImage != "") {
                      Pet newPet = new Pet(
                        petName: _nameController.text,
                        petImage: _selectedImage!,
                        petBDay: _dateController.text,
                        petGender: gender,
                        petBreed: "",
                        petFav: _likeController.text,
                        petHate: _dislikeController.text,
                        petDesc: _descController.text,
                      );
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
                                "Add pet successfully",
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
                      setState(() {
                        _selectedImage = "";
                      });
                      Navigator.pop(context);
                    } else if (_selectedImage != "") {
                      setState(() {
                        isPictureError = false;
                      });
                    } else {
                      setState(() {
                        isPictureError = true;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromARGB(255, 66, 133, 244),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("Submit", style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
