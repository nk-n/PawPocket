import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pawpocket/app/add-pet/each-form-field.dart';
import 'package:pawpocket/app/add-pet/multipleline-form-field.dart';
import 'package:pawpocket/app/calendar/date-time-field.dart';
import 'package:pawpocket/model/pet.dart';
import 'package:pawpocket/services/pet_firestore.dart';
import 'package:uuid/uuid.dart';

class MemoryPopup extends StatefulWidget {
  const MemoryPopup({
    super.key,
    required this.pet,
    required this.type,
    this.newMemory,
  });

  final Pet? pet;
  final String type;
  final Map<String, dynamic>? newMemory;

  @override
  State<MemoryPopup> createState() => _MemoryPopupState();
}

class _MemoryPopupState extends State<MemoryPopup> {
  final PetFirestoreService firestoreService = PetFirestoreService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isPictureError = false;
  String _selectedImage = "";

  void clearAllInput() {
    _nameController.clear();
    _dateController.clear();
    _descController.clear();
    _selectedImage = "";
    isPictureError = false;
  }

  @override
  void initState() {
    super.initState();

    if (widget.newMemory != null) {
      _nameController.text = widget.newMemory!["title"];
      _descController.text = widget.newMemory!["description"];
      _dateController.text = widget.newMemory!["date"];
      _selectedImage = widget.newMemory!["image"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Column(
        children: [
          Image.asset(
            "assets/images/book_square_icon.png",
            width: 70,
            height: 70,
          ),
          SizedBox(height: 5),
          Text(
            widget.type == "create" ? "Add new memory" : "Update memory",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 300,
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EachFormField(
                    label: "Title",
                    controller: _nameController,
                    textSize: 14,
                  ),
                  SizedBox(height: 20),
                  Text("Description", style: TextStyle(fontSize: 14)),
                  SizedBox(height: 10),
                  MultipleLineTextFormField(
                    title: "Description",
                    descController: _descController,
                    textSize: 14,
                  ),
                  SizedBox(height: 20),
                  DateTimeField(
                    needTime: false,
                    fontSize: 14,
                    dateController: _dateController,
                    timeController: _timeController,
                  ),
                  SizedBox(height: 20),
                  Text("Memory image"),
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color:
                            isPictureError
                                ? Colors.redAccent
                                : Colors.grey[400]!,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _selectedImage == ""
                              ? Image.asset(
                                "assets/images/gallery_icon.png",
                                height: 100,
                              )
                              : SizedBox(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 150,
                                            margin: const EdgeInsets.only(
                                              bottom: 30,
                                            ),
                                            clipBehavior: Clip.antiAlias,
                                            child:
                                                _selectedImage != null
                                                    ? Image.file(
                                                      File(_selectedImage!),
                                                      fit: BoxFit.cover,
                                                    )
                                                    : Image.asset(""),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          SizedBox(height: _selectedImage == "" ? 20 : 0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: ImageIcon(
                                  AssetImage("assets/images/picture_icon.png"),
                                  color: Colors.white,
                                  size: 40,
                                ),
                                onPressed: () async {
                                  final returnedImage = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);
                                  if (returnedImage == null) return;
                                  setState(() {
                                    _selectedImage = returnedImage.path;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  overlayColor: Colors.white,
                                  backgroundColor: Color.fromARGB(
                                    255,
                                    66,
                                    133,
                                    244,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              IconButton(
                                icon: ImageIcon(
                                  AssetImage("assets/images/camera_icon.png"),
                                  color: Colors.white,
                                  size: 40,
                                ),
                                onPressed: () async {
                                  final returnedImage = await ImagePicker()
                                      .pickImage(source: ImageSource.camera);
                                  if (returnedImage == null) return;

                                  File imageFile = File(returnedImage.path);

                                  final directory =
                                      await getApplicationDocumentsDirectory();
                                  final timestamp =
                                      DateTime.now().millisecondsSinceEpoch;
                                  final savedImagePath =
                                      "${directory.path}/image_$timestamp.jpg";

                                  await imageFile.copy(savedImagePath);

                                  setState(() {
                                    _selectedImage = savedImagePath;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  overlayColor: Colors.white,
                                  backgroundColor: Color.fromARGB(
                                    255,
                                    66,
                                    133,
                                    244,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          clearAllInput();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          overlayColor: Colors.black12,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate() &&
                              _selectedImage != "") {
                            if (widget.newMemory == null) {
                              Map<String, dynamic> newMemory = {
                                "id": Uuid().v4(),
                                "title": _nameController.text,
                                "date": _dateController.text,
                                "image": _selectedImage,
                                "description": _descController.text,
                              };
                              widget.pet!.addMemories(newMemory);
                              firestoreService.updatePet(
                                widget.pet!.uuid,
                                widget.pet!,
                              );
                            } else {
                              widget.newMemory!["title"] = _nameController.text;
                              widget.newMemory!["date"] = _dateController.text;
                              widget.newMemory!["image"] = _selectedImage;
                              widget.newMemory!["description"] =
                                  _descController.text;
                              firestoreService.updatePet(
                                widget.pet!.uuid,
                                widget.pet!,
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
                                      widget.newMemory == null
                                          ? "Add memory successfully"
                                          : "Update memory successfully",
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
                            clearAllInput();
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
                        child: Text("Submit"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
