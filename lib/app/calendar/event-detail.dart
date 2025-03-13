import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawpocket/model/event.dart';
import 'package:pawpocket/model/pet.dart';
import 'package:pawpocket/services/event_firestore.dart';
import 'package:pawpocket/services/pet_firestore.dart';

class EventDetail extends StatefulWidget {
  const EventDetail({super.key});

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  EventFirestoreService eventFirestoreService = EventFirestoreService();
  PetFirestoreService petFireStoreService = PetFirestoreService();
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
    final String docId = ModalRoute.of(context)?.settings.arguments as String;
    return StreamBuilder(
      stream: eventFirestoreService.getEventStreamById(docId),
      builder: (context, snapshotEvent) {
        if (snapshotEvent.data == null || !snapshotEvent.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshotEvent.hasError) {
          return Center(
            child: Text(
              "ERROR: ${snapshotEvent.error}",
              style: TextStyle(fontSize: 20),
            ),
          );
        }
        Event event = Event.fromMap(
          snapshotEvent.data?.data() as Map<String, dynamic>,
          docId,
        );
        return StreamBuilder(
          stream: petFireStoreService.getPetStream(),
          builder: (context, snapshotPet) {
            if (!snapshotPet.hasData || snapshotPet.data == null) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshotEvent.hasError) {
              return Center(
                child: Text(
                  "ERROR: ${snapshotEvent.error}",
                  style: TextStyle(fontSize: 20),
                ),
              );
            }
            int size = snapshotPet.data!.docs.length;
            late Pet targetPet;
            bool foundPet = false;
            for (int i = 0; i < size; i++) {
              String petDocId = snapshotPet.data!.docs[i].id;
              if (event.petId == petDocId) {
                targetPet = Pet.fromMap(
                  snapshotPet.data!.docs[i].data() as Map<String, dynamic>,
                  petDocId,
                );
                foundPet = true;
                break;
              }
            }
            if (!foundPet) {
              return Center(
                child: Text("Not found event", style: TextStyle(fontSize: 20)),
              );
            }
            return Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: ImageIcon(AssetImage("assets/images/pen-icon.png")),
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
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        focusColor: Colors.white,
                        onPressed: () {},
                        icon: Icon(Icons.delete),
                        style: ButtonStyle(
                          iconColor: WidgetStateColor.resolveWith((states) {
                            if (states.contains(WidgetState.pressed)) {
                              return Colors.redAccent;
                            }
                            return Colors.grey;
                          }),
                          overlayColor: WidgetStateProperty.all(Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.file(File(targetPet.petImage)),
                      ),
                      SizedBox(height: 20),
                      Text(
                        event.title,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${targetPet.petName}, ${targetPet.petBreed}",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          ImageIcon(
                            AssetImage("assets/images/calendar-icon.png"),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Thursday ${DateTime.parse(event.date).day} ${month[DateTime.parse(event.date).month - 1]} ${DateTime.parse(event.date).year}",
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          ImageIcon(AssetImage("assets/images/clock-icon.png")),
                          SizedBox(width: 10),
                          Text(event.time),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          ImageIcon(
                            AssetImage("assets/images/location_icon.png"),
                          ),
                          SizedBox(width: 10),
                          Text(event.location),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Description",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(event.descriptions),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
