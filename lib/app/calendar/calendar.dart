import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pawpocket/model/event.dart';
import 'package:pawpocket/model/pet.dart';
import 'package:pawpocket/services/event_firestore.dart';
import 'package:pawpocket/services/pet_firestore.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  EventFirestoreService eventFirestoreService = EventFirestoreService();
  PetFirestoreService petFirestoreService = PetFirestoreService();
  final weekDay = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  final month = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Calendar"),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: IconButton(
              icon: ImageIcon(
                AssetImage("assets/images/calendar_complete.png"),
                size: 30,
              ),
              focusColor: Colors.white,
              onPressed: () {
                Navigator.pushNamed(context, "/historycalendar");
              },
              style: ButtonStyle(
                iconColor: WidgetStateColor.resolveWith((states) {
                  if (states.contains(WidgetState.pressed)) {
                    return Colors.blue; // สีตอนกด
                  }
                  return Colors.grey;
                }),
                overlayColor: WidgetStateProperty.all(Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          StreamBuilder(
            stream: eventFirestoreService.getEventStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.data != null && snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    "Not found event",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Text('ERROR: ${snapshot.error}');
              }
              bool foundEvent = false;
              var eventList = snapshot.data?.docs ?? [];
              Map<String, List<Map<String, dynamic>>> dateMonth = {};
              for (int index = 0; index < eventList.length; index++) {
                DateTime now = DateTime.now();
                DocumentSnapshot document = eventList[index];
                String docId = document.id;
                var eachEvent = Event.fromMap(
                  eventList[index].data() as Map<String, dynamic>,
                  docId,
                );
                if (now.isAfter(
                      DateTime.parse(
                        "${eventList[index]["date"]} ${eventList[index]["time"]}:00",
                      ),
                    ) ||
                    eachEvent.isComplete) {
                  continue;
                }
                if (eachEvent.ownerId !=
                    FirebaseAuth.instance.currentUser!.uid) {
                  continue;
                }
                foundEvent = true;
                String numMonth =
                    "${eachEvent.startEvent.month.toString()}|${eachEvent.startEvent.year.toString()}";
                if (dateMonth.containsKey(numMonth)) {
                  dateMonth[numMonth]?.add({
                    "data": eachEvent,
                    "docId": eventList[index].id,
                  });
                } else {
                  dateMonth[numMonth] = [
                    {"data": eachEvent, "docId": eventList[index].id},
                  ];
                }
              }

              if (!foundEvent) {
                return Center(
                  child: Text(
                    "Not found event",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                );
              }
              return Container(
                margin: const EdgeInsets.all(20),
                child: ListView.builder(
                  itemCount: dateMonth.length,
                  itemBuilder: (BuildContext context, int index) {
                    String numMonth = dateMonth.keys.toList()[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/images/calendar-wallpaper/cw-${int.parse(numMonth.split("|")[0]) % 12}.jpg",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                              child: Text(
                                "${month[int.parse(numMonth.split("|")[0]) - 1]} ${numMonth.split("|")[1]} BE",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:
                                  dateMonth[dateMonth.keys.toList()[index]]!
                                      .length,
                              itemBuilder: (BuildContext context, int j) {
                                Event targetEvent =
                                    dateMonth[dateMonth.keys
                                        .toList()[index]]![j]["data"];
                                return StreamBuilder(
                                  stream: petFirestoreService.getPetStream(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text("ERROR:${snapshot.error}"),
                                      );
                                    }
                                    var objectList = snapshot.data?.docs ?? [];
                                    Pet? targetPet;
                                    for (
                                      int index = 0;
                                      index < objectList.length;
                                      index++
                                    ) {
                                      DocumentSnapshot document =
                                          objectList[index];
                                      String docId = document.id;
                                      if (docId == targetEvent.petId) {
                                        targetPet = Pet.fromMap(
                                          objectList[index].data()
                                              as Map<String, dynamic>,
                                          docId,
                                        );
                                        break;
                                      }
                                    }
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          "/eventdetail",
                                          arguments:
                                              dateMonth[dateMonth.keys
                                                  .toList()[index]]![j]["docId"],
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        child: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 50,
                                                  child: Text(
                                                    textAlign: TextAlign.center,
                                                    weekDay[DateTime.parse(
                                                          targetEvent.date,
                                                        ).weekday -
                                                        1],
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "${DateTime.parse(targetEvent.date).day}",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 20),
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Color(
                                                    targetEvent.color,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                padding: const EdgeInsets.all(
                                                  15,
                                                ),
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            targetEvent.title,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                          SizedBox(height: 10),
                                                          Text(
                                                            "${targetEvent.time}",
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    IconButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            WidgetStatePropertyAll(
                                                              Colors.white,
                                                            ),
                                                      ),
                                                      color: Colors.green[400],
                                                      onPressed: () {
                                                        targetEvent
                                                                .setIsComplete =
                                                            true;
                                                        eventFirestoreService
                                                            .updateEvent(
                                                              dateMonth[dateMonth
                                                                  .keys
                                                                  .toList()[index]]![j]["docId"],
                                                              targetEvent,
                                                            );
                                                      },
                                                      icon: Icon(
                                                        Icons.check,
                                                        size: 30,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
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
          Positioned(
            bottom: 30,
            right: 30,
            child: Container(
              child: IconButton(
                padding: const EdgeInsets.all(20),
                onPressed: () {
                  Navigator.pushNamed(context, "/addeventform");
                },
                icon: ImageIcon(
                  AssetImage("assets/images/plus_only_icon.png"),
                  size: 30,
                  color: Colors.green[400],
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3), // Shadow color
                    spreadRadius: 1, // Spread of shadow
                    blurRadius: 10, // Blur radius
                    offset: Offset(0, 5), // Shadow position
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
