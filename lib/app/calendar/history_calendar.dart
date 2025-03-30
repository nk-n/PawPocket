import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pawpocket/model/event.dart';
import 'package:pawpocket/model/pet.dart';
import 'package:pawpocket/services/event_firestore.dart';
import 'package:pawpocket/services/image_manager.dart';
import 'package:pawpocket/services/pet_firestore.dart';

class HistoryCalendar extends StatefulWidget {
  const HistoryCalendar({super.key});

  @override
  State<HistoryCalendar> createState() => _HistoryCalendarState();
}

class _HistoryCalendarState extends State<HistoryCalendar> {
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
      appBar: AppBar(centerTitle: true, title: Text("History")),
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
                    "Not found history event",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Text('ERROR: ${snapshot.error}');
              }
              bool foundEvent = false;
              var eventList = snapshot.data?.docs ?? [];
              Map<String, List<Event>> dateMonth = {};
              for (int index = 0; index < eventList.length; index++) {
                DateTime now = DateTime.now();
                DocumentSnapshot document = eventList[index];
                String docId = document.id;
                var eachEvent = Event.fromMap(
                  eventList[index].data() as Map<String, dynamic>,
                  docId,
                );
                if (now.isBefore(eachEvent.startEvent) &&
                    !eachEvent.isComplete) {
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
                  dateMonth[numMonth]!.add(eachEvent);
                } else {
                  dateMonth[numMonth] = [eachEvent];
                }
              }
              if (dateMonth.isEmpty) {
                return Center(
                  child: Text(
                    "Not found history event",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                );
              }

              if (!foundEvent) {
                return Center(
                  child: Text(
                    "Not found history event",
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
                                        .toList()[index]]![j];
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
                                      }
                                    }
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          "/eventdetail",
                                          arguments:
                                              dateMonth[dateMonth.keys
                                                      .toList()[index]]![j]
                                                  .uuid,
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
                                                  color:
                                                      targetEvent.isComplete
                                                          ? Colors.green[400]
                                                          : Colors.grey[400],
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
                                                            targetEvent.time,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ],
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
        ],
      ),
    );
  }
}
