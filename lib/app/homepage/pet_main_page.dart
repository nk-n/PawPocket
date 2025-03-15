import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pawpocket/app/add-pet/each-form-field.dart';
import 'package:pawpocket/app/homepage/home_popup.dart';
import 'package:pawpocket/nav_bar.dart';
import 'package:pawpocket/services/home_firestore.dart';
import 'package:pawpocket/services/user_firestore.dart';
import 'home.dart';
import 'pet_widgets.dart';
import '../../model/pet.dart';
import 'package:pawpocket/model/home_model.dart';

class PetMainPage extends StatefulWidget {
  PetMainPage({super.key, required this.user});
  final user;

  @override
  State<PetMainPage> createState() => _PetMainPageState();
}

class _PetMainPageState extends State<PetMainPage> {
  HomeFirestoreService homeFirestoreService = HomeFirestoreService();
  List recents = [];
  @override
  void initState() {
    // final Pet tmpPet = Pet(
    //   petName: "Butter",
    //   petImage: "cat.png",
    //   petBDay: "2021-01-21",
    //   petGender: "Female",
    //   petBreed: "British Shorthair",
    //   petFav: "ball, bath, chicken, nugget",
    //   petHate: "medicine",
    //   petDesc:
    //       "cheerful and outgoing. I got her from my mom when she was only 1-year-old.",
    //   petLocation: "Bangkok, Thailand",
    //   memories: List.generate(1, new Map<String, String>({}))
    // );

    recents = [
      // PetRecent(
      //   pet: tmpPet,
      //   date: "Thursday 14 February 2568",
      //   reminderDesc: "Vaccination",
      // ),
      // PetRecent(
      //   pet: tmpPet,
      //   date: "Monday 11 May 2568",
      //   reminderDesc: "Vaccination",
      // ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: UserFirestoreServices().readUserData(widget.user),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('ERROR: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          return Container(
            margin: EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 15),
            child: Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Hello, ${userData['display_name']}!",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.notifications),
                        onPressed: () {},
                        color: Colors.amberAccent[700],
                        iconSize: 30,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.grey,
                        hintText: "Search",
                        icon: Icon(Icons.search),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  const SizedBox(height: 20),
                  StreamBuilder(
                    stream: homeFirestoreService.getHomeStream(),
                    builder: (context, snapshotHome) {
                      if (!snapshotHome.hasData || snapshotHome.data == null) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshotHome.hasError) {
                        return Center(
                          child: Text(
                            "ERROR: ${snapshot.error}",
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      }
                      var homeList = snapshotHome.data!.docs;
                      return Container(
                        margin: EdgeInsets.only(left: 15, right: 15),
                        height: 150,
                        child: ScrollConfiguration(
                          behavior: const ScrollBehavior(),
                          child: ListView.builder(
                            itemCount: homeList.length + 1,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              if (index < homeList.length) {
                                HomeModel home = HomeModel.fromMap(
                                  homeList[index].data()
                                      as Map<String, dynamic>,
                                  homeList[index].id,
                                );
                                return Container(
                                  height: 150,
                                  width: 100,
                                  margin: EdgeInsets.only(right: 7, left: 7),
                                  child: Home(home: home),
                                );
                              } else {
                                return ElevatedButton(
                                  onPressed:
                                      () => showDialog(
                                        context: context,
                                        builder: (context) {
                                          return StatefulBuilder(
                                            builder: (context, setState) {
                                              return HomePopup();
                                            },
                                          );
                                        },
                                      ),
                                  style: ElevatedButton.styleFrom(
                                    overlayColor: Colors.white,
                                    backgroundColor: Color.fromARGB(
                                      255,
                                      66,
                                      133,
                                      244,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
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
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
