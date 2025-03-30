import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pawpocket/app/add-pet/each-form-field.dart';
import 'package:pawpocket/model/home_model.dart';
import 'package:pawpocket/services/home_firestore.dart';
import 'package:pawpocket/services/image_manager.dart';
import 'package:pawpocket/services/user_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class HomePopup extends StatefulWidget {
  const HomePopup({super.key, required this.user, required this.userId});

  final Map<String, dynamic> user;
  final String userId;

  @override
  State<HomePopup> createState() => _HomePopupState();
}

class _HomePopupState extends State<HomePopup> {
  HomeFirestoreService homeFirestoreService = HomeFirestoreService();
  UserFirestoreServices userFirestoreServices = UserFirestoreServices();
  bool isPictureError = false;
  String _selectedImage = "";
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Column(
        children: [
          ImageIcon(
            AssetImage("assets/images/home_blue_icon.png"),
            color: Color.fromARGB(255, 66, 133, 244),
            size: 60,
          ),
          SizedBox(height: 5),
          Text(
            "Add new home",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: SizedBox(
        width: 300,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              EachFormField(
                label: "Name",
                controller: _nameController,
                textSize: 14,
              ),
              Text("Home image"),
              SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color:
                        isPictureError ? Colors.redAccent : Colors.grey[400]!,
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
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 30),
                                  clipBehavior: Clip.antiAlias,
                                  width: 150,
                                  height: 225,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child:
                                      _selectedImage != null
                                          ? Image.file(
                                            File(_selectedImage!),
                                            fit: BoxFit.cover,
                                          )
                                          : Image.asset(""),
                                ),
                              ],
                            ),
                          ),
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
                            style: ButtonStyle(
                              overlayColor: WidgetStateProperty.all(
                                Colors.white10,
                              ),
                              backgroundColor: WidgetStateProperty.all(
                                Color.fromARGB(255, 66, 133, 244),
                              ),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
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
                      setState(() {
                        _selectedImage = "";
                      });
                      _nameController.clear();
                      setState(() {
                        isPictureError = false;
                      });
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
                    onPressed: () async {
                      if (_formKey.currentState!.validate() &&
                          _selectedImage != "") {
                        _selectedImage = await ImageManager().uploadImage(
                          _selectedImage,
                          "none",
                        );
                        HomeModel newHome = HomeModel(
                          uuid: Uuid().v4(),
                          name: _nameController.text,
                          image: _selectedImage,
                        );
                        String docId = await homeFirestoreService.addHome(
                          newHome,
                        );
                        List newPetHome = widget.user["pet_home"] as List;
                        newPetHome.add(docId);
                        userFirestoreServices.updateUserData(
                          username: widget.user["username"],
                          displayName: widget.user["display_name"],
                          email: widget.user["email"],
                          uuid: widget.userId,
                          about: widget.user["about"],
                          profilePicture: widget.user["profile_picture"],
                          location: widget.user["location"],
                          petHome: newPetHome,
                          socials: widget.user["socials"],
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
                                  "Add home successfully",
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
                        setState(() {
                          isPictureError = false;
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
                    child: Text("Submit"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
