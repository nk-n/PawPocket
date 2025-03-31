import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pawpocket/app/add-pet/each-form-field.dart';
import 'package:pawpocket/app/homepage/home_popup.dart';
import 'package:pawpocket/nav_bar.dart';
import 'package:pawpocket/services/event_firestore.dart';
import 'package:pawpocket/services/home_firestore.dart';
import 'package:pawpocket/services/noti_service.dart';
import 'package:pawpocket/services/user_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'home.dart';
import 'pet_widgets.dart';
import '../../model/pet.dart';
import 'package:pawpocket/model/home_model.dart';
import 'package:pawpocket/model/user.dart' as Users;

class PetMainPage extends StatefulWidget {
  PetMainPage({super.key, required this.user});
  final user;

  @override
  State<PetMainPage> createState() => _PetMainPageState();
}

class _PetMainPageState extends State<PetMainPage> {
  EventFirestoreService eventFirestoreService = EventFirestoreService();
  HomeFirestoreService homeFirestoreService = HomeFirestoreService();
  UserFirestoreServices userFirestoreServices = UserFirestoreServices();
  String searchText = "";
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
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     final notiService = NotiService();
                  //     notiService.showNotification(
                  //       year: 2025,
                  //       month: 3,
                  //       day: 28,
                  //       hour: 8,
                  //       minute: 10,
                  //       title: "Title",
                  //       body: "Body",
                  //     );
                  //   },

                  //   child: Text("Test"),
                  // ),
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
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      style: TextStyle(fontSize: 18),
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelStyle: TextStyle(fontSize: 40),
                        border: InputBorder.none,
                        fillColor: Colors.grey,
                        hintText: "Search",
                        icon: Icon(Icons.search),
                      ),
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

                      List<DocumentSnapshot> homeListFilter = [];
                      var homeList = snapshotHome.data!.docs;
                      for (int i = 0; i < homeList.length; i++) {
                        String docId = homeList[i].id;
                        HomeModel eachHome = HomeModel.fromMap(
                          homeList[i].data() as Map<String, dynamic>,
                          docId,
                        );

                        if (userData["pet_home"].contains(eachHome.uuid) &&
                            eachHome.name.contains(searchText)) {
                          homeListFilter.add(homeList[i]);
                        }
                      }
                      return Container(
                        height: 150,
                        child: ScrollConfiguration(
                          behavior: const ScrollBehavior(),
                          child: ListView.builder(
                            itemCount: homeListFilter.length + 1,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              if (index < homeListFilter.length) {
                                HomeModel home = HomeModel.fromMap(
                                  homeListFilter[index].data()
                                      as Map<String, dynamic>,
                                  homeListFilter[index].id,
                                );
                                return Container(
                                  height: 150,
                                  width: 100,
                                  margin: EdgeInsets.only(right: 7),
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
                                              return HomePopup(
                                                user: userData,
                                                userId: snapshot.data!.id,
                                              );
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
                    child: Text("Recent Event", style: TextStyle(fontSize: 20)),
                  ),
                  // const SizedBox(height: 10),
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: const ScrollBehavior(),
                      child: Container(
                        padding: EdgeInsets.only(top: 5),
                        height: 300,
                        width: 420,
                        margin: EdgeInsets.only(bottom: 15),
                        child: StreamBuilder<QuerySnapshot>(
                          stream: eventFirestoreService.getEventStream(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting ||
                                !snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }
                            var eventList = snapshot.data?.docs;
                            List eventListFilter = [];
                            for (int i = 0; i < eventList!.length; i++) {
                              final now = DateTime.now();
                              final dif =
                                  DateTime.parse(
                                    "${eventList[i]["date"]} ${eventList[i]["time"]}:00",
                                  ).difference(now).inHours;
                              if (dif.abs() < 72 &&
                                  DateTime.parse(
                                    "${eventList[i]["date"]} ${eventList[i]["time"]}:00",
                                  ).isAfter(now) &&
                                  eventList[i]["ownerId"] ==
                                      FirebaseAuth.instance.currentUser!.uid) {
                                eventListFilter.add(eventList[i]);
                              }
                            }
                            if (eventListFilter.length == 0) {
                              return Center(
                                child: Text(
                                  "There are no recent events.",
                                  style: TextStyle(fontSize: 18),
                                ),
                              );
                            }
                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: eventListFilter.length,
                              itemBuilder: (context, index) {
                                DateTime targetTime = DateTime.parse(
                                  "${eventListFilter[index]["date"]} ${eventListFilter[index]["time"]}:00",
                                );
                                return PetRecent(
                                  id: eventListFilter[index].id,
                                  title: eventListFilter[index]["title"],
                                  targetTime: targetTime,
                                  reminderDesc: eventListFilter[index]["type"],
                                );
                              },
                            );
                          },
                        ),
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
