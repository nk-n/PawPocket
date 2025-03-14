import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawpocket/app/add-pet/each-form-field.dart';
import 'package:pawpocket/app/add-pet/image-form-field.dart';
import 'package:pawpocket/app/add-pet/multipleline-form-field.dart';
import 'package:pawpocket/model/pet.dart';
import 'package:pawpocket/services/pet_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AddPetForm extends StatefulWidget {
  const AddPetForm({super.key, required this.pet, required this.status});

  final Pet? pet;
  final String status;

  @override
  State<AddPetForm> createState() => _AddPetFormState();
}

class _AddPetFormState extends State<AddPetForm> {
  String uuid = "";
  final _locationController = TextEditingController();
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
  final PetFirestoreService firestoreService = PetFirestoreService();

  void updateSelectedImage(String value) {
    setState(() {
      _selectedImage = value;
    });
  }

  void updateGender(String value) {
    setState(() {
      gender = value;
    });
  }

  Future uploadImage() async {
    if (_selectedImage == null || _selectedImage == "") return;

    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final path = "uploads/$fileName";

    final response = await Supabase.instance.client.storage
        .from("images")
        .upload(path, File(_selectedImage!));
    if (response.isNotEmpty) {
      final publicUrl = Supabase.instance.client.storage
          .from('images')
          .getPublicUrl(path);
      setState(() {
        _selectedImage = publicUrl;
      });
    }
  }

  late Pet? pet = widget.pet;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pet != null) {
        uuid = pet!.uuid;
        updateGender(pet?.petGender ?? "male");
        setState(() {
          _selectedImage = pet!.petImage;
        });
        _nameController.text = pet!.petName;
        _speciesController.text = pet!.petBreed;
        _dateController.text = pet!.petBDay;
        _likeController.text = pet!.petFav;
        _dislikeController.text = pet!.petHate;
        _descController.text = pet!.petDesc;
        _locationController.text = pet!.petLocation;
      }
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
            EachFormField(
              label: "Location",
              controller: _locationController,
              textSize: 18,
            ),
            ImageFormField(
              selectedImage: _selectedImage,
              title: "Pet Image",
              isPictureError: isPictureError,
              setSelectedImage: updateSelectedImage,
              width: 10,
              height: 150,
            ),
            SizedBox(height: 20),
            Text("Descriptions", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            MultipleLineTextFormField(
              descController: _descController,
              textSize: 18,
              title: "Description",
            ),
            SizedBox(height: 10),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (_formkey.currentState!.validate() &&
                        _selectedImage != "") {
                      await uploadImage();
                      Pet newPet = new Pet(
                        petName: _nameController.text,
                        petImage: _selectedImage!,
                        petBDay: _dateController.text,
                        petGender: gender,
                        petBreed: _speciesController.text,
                        petFav: _likeController.text,
                        petHate: _dislikeController.text,
                        petDesc: _descController.text,
                        petLocation: _locationController.text,
                        memories: pet == null ? List.empty() : pet!.memories,
                        uuid: pet?.uuid ?? Uuid().v4(),
                      );
                      if (pet == null) {
                        firestoreService.addPet(newPet);
                      } else if (pet != null) {
                        firestoreService.updatePet(pet!.uuid, newPet);
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
                                "${widget.status == "create" ? "Add" : "Update"} pet successfully",
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
