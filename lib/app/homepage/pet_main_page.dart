import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawpocket/nav_bar.dart';
import 'home.dart';
import 'pet_widgets.dart';
import '../../model/pet.dart';

class PetMainPage extends StatefulWidget {
  PetMainPage({super.key, required this.user});
  final user;

  @override
  State<PetMainPage> createState() => _PetMainPageState();
}

class _PetMainPageState extends State<PetMainPage> {
  String? _selectedImage = "";
  final _nameController = TextEditingController();

  List recents = [];
  @override
  void initState() {
    final Pet tmpPet = Pet(
      petName: "Butter",
      petImage: "cat.png",
      petBDay: "2021-01-21",
      petGender: "Female",
      petBreed: "British Shorthair",
      petFav: "ball, bath, chicken, nugget",
      petHate: "medicine",
      petDesc:
          "cheerful and outgoing. I got her from my mom when she was only 1-year-old.",
    );

    recents = [
      PetRecent(
        pet: tmpPet,
        date: "Thursday 14 February 2568",
        reminderDesc: "Vaccination",
      ),
      PetRecent(
        pet: tmpPet,
        date: "Monday 11 May 2568",
        reminderDesc: "Vaccination",
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List homes = [
      Home(homeName: "My Home", homeImage: "homePic.png"),
      Home(homeName: "Parents' home", homeImage: "homePic.png"),
      ElevatedButton(
        onPressed:
            () => showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
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
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      content: SizedBox(
                        width: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Name"),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey[400] ?? Colors.grey,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 66, 133, 244),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text("Home image"),
                            SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color: Colors.grey[400] ?? Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _selectedImage == ""
                                        ? Container(
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 30,
                                          ),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                  bottom: 30,
                                                ),
                                                clipBehavior: Clip.antiAlias,
                                                width: 150,
                                                height: 225,
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
                                            ],
                                          ),
                                        ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final returnedImage =
                                            await ImagePicker().pickImage(
                                              source: ImageSource.gallery,
                                            );
                                        if (returnedImage == null) return;
                                        setState(() {
                                          _selectedImage = returnedImage.path;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color.fromARGB(
                                          255,
                                          66,
                                          133,
                                          244,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
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
                          ],
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedImage = "";
                            });
                            _nameController.clear();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            overlayColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.redAccent),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Cancle",
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedImage = "";
                            });
                            _nameController.clear();
                            Navigator.pop(context);
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
                    );
                  },
                );
              },
            ),
        style: ElevatedButton.styleFrom(
          overlayColor: Colors.white,
          backgroundColor: Color.fromARGB(255, 66, 133, 244),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Icon(Icons.add, size: 50, color: Colors.white),
      ),
    ];
    return Container(
      margin: EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 15),
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hello, ${widget.user}!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.notifications),
              ],
            ),
            const SizedBox(height: 20),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Color.fromARGB(50, 147, 147, 147),
                // gradient: LinearGradient(colors: [Color.fromARGB(255, 247, 30, 30)]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                height: 40,
                width: 450,
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    Icon(Icons.search),
                    const SizedBox(width: 10),
                    Text("Search"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              height: 150,
              child: ScrollConfiguration(
                behavior: const ScrollBehavior(),
                child: ListView.builder(
                  itemCount: homes.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 150,
                      width: 100,
                      margin: EdgeInsets.only(right: 7, left: 7),
                      child: homes[index],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Recent", style: TextStyle(fontSize: 18)),
            ),
            // const SizedBox(height: 10),
            Expanded(
              child: ScrollConfiguration(
                behavior: const ScrollBehavior(),
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 5),
                  itemCount: recents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 300,
                      width: 420,
                      margin: EdgeInsets.only(bottom: 15),
                      child: recents[index],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
