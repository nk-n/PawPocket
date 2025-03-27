import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawpocket/model/event.dart';
import 'package:pawpocket/model/pet.dart';
import 'package:pawpocket/services/event_firestore.dart';

class MedicalHistory extends StatefulWidget {
  const MedicalHistory({super.key});

  @override
  State<MedicalHistory> createState() => _MedicalHistoryState();
}

class _MedicalHistoryState extends State<MedicalHistory> {
  EventFirestoreService eventFirestoreService = EventFirestoreService();

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    Pet pet = data["pet"] as Pet;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(pet.petName),
                SizedBox(width: 10),
                ImageIcon(
                  AssetImage("assets/images/female_icon.png"),
                  color: Colors.pink[300],
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(pet.petBreed, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: eventFirestoreService.getEventStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("ERROR: ${snapshot.error}"));
          }
          List<DocumentSnapshot> eventList = snapshot.data!.docs;
          List<Event> eventFilter = [];
          for (int i = 0; i < eventList.length; i++) {
            String docId = eventList[i].id;
            Event event = Event.fromMap(
              eventList[i].data() as Map<String, dynamic>,
              docId,
            );
            if (event.petId.contains(pet.uuid) &&
                event.type == "medical" &&
                event.isComplete) {
              eventFilter.add(event);
            }
          }
          return Container(
            margin: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 66, 133, 244),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      ImageIcon(
                        AssetImage("assets/images/aid_icon.png"),
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Medical History",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[200]!, width: 2),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: ListView.builder(
                      itemCount: eventFilter.length,
                      itemBuilder: (BuildContext context, int index) {
                        Event eachEvent = eventFilter[index];
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 2,
                              color: Colors.grey[200]!,
                            ),
                          ),
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      eachEvent.title,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      ImageIcon(
                                        AssetImage(
                                          "assets/images/clock-icon.png",
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        eachEvent.time,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10),
                                  Row(
                                    children: [
                                      ImageIcon(
                                        AssetImage(
                                          "assets/images/calendar-icon.png",
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "${DateTime.parse(eachEvent.date).day}/${DateTime.parse(eachEvent.date).month}/${DateTime.parse(eachEvent.date).year}",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 25),
                              Text(
                                eachEvent.descriptions,
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 15),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.pink[200],
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 10,
                                ),
                                child: Text(
                                  "medical",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
