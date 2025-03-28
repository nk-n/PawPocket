import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pawpocket/app/each-pet/delete-popup.dart';
import 'package:pawpocket/model/event.dart';
import 'package:pawpocket/model/pet.dart';
import 'package:pawpocket/services/event_firestore.dart';
import 'package:pawpocket/services/image_manager.dart';
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
            List<Pet> choosePet = [];
            for (int j = 0; j < event.petId.length; j++) {
              for (int i = 0; i < size; i++) {
                String petDocId = snapshotPet.data!.docs[i].id;
                if (petDocId == event.petId[j]) {
                  targetPet = Pet.fromMap(
                    snapshotPet.data!.docs[i].data() as Map<String, dynamic>,
                    petDocId,
                  );
                  foundPet = true;
                  choosePet.add(targetPet);
                }
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
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        "/addeventform",
                        arguments: {
                          "status": "update",
                          "pet": targetPet,
                          "event": event,
                        },
                      );
                    },
                    icon: ImageIcon(AssetImage("assets/images/pen-icon.png")),
                    style: ButtonStyle(
                      iconColor: WidgetStateColor.resolveWith((states) {
                        if (states.contains(WidgetState.pressed)) {
                          return Colors.blue;
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
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return DeletePopup(type: "event", event: event);
                            },
                          );
                        },
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
                      SizedBox(
                        height: 300,
                        child: ListView.builder(
                          physics:
                              choosePet.length == 1
                                  ? NeverScrollableScrollPhysics()
                                  : null,
                          itemCount: choosePet.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (
                            BuildContext context,
                            int indexChoosePet,
                          ) {
                            return Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  height: double.infinity,
                                  width:
                                      MediaQuery.of(context).size.width *
                                      (choosePet.length == 1 ? 0.9 : 0.8),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.network(
                                    ImageManager().getImageUrl(
                                      choosePet[indexChoosePet].petImage,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  left: 10,
                                  bottom: 10,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 200,
                                        padding: EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                        ),
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          "${choosePet[indexChoosePet].petName}, ${choosePet[indexChoosePet].petBreed}",
                                          style: TextStyle(fontSize: 20),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        event.title,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:
                              event.isComplete
                                  ? Colors.green[400]
                                  : Colors.grey[400],
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          event.isComplete ? "Complete" : "Uncomplete",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
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
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          ImageIcon(AssetImage("assets/images/clock-icon.png")),
                          SizedBox(width: 10),
                          Text(event.time, style: TextStyle(fontSize: 18)),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          ImageIcon(
                            AssetImage("assets/images/location_icon.png"),
                          ),
                          SizedBox(width: 10),
                          Text(event.location, style: TextStyle(fontSize: 18)),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Description",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(event.descriptions, style: TextStyle(fontSize: 18)),
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
