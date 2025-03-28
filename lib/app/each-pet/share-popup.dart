import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pawpocket/model/event.dart';
import 'package:pawpocket/model/pet.dart';
import 'package:pawpocket/services/community_firestore.dart';
import 'package:pawpocket/services/event_firestore.dart';
import 'package:pawpocket/services/pet_firestore.dart';

class SharePopup extends StatefulWidget {
  const SharePopup({super.key, required this.pet, required this.type});

  final Pet pet;
  final String type;

  @override
  State<SharePopup> createState() => _SharePopupState();
}

class _SharePopupState extends State<SharePopup> {
  final CommunityFirestoreServices firestoreService =
      CommunityFirestoreServices();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      clipBehavior: Clip.antiAlias,
      contentPadding: EdgeInsets.all(0),
      backgroundColor: Colors.white,
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border(top: BorderSide(width: 10, color: Colors.amber)),
        ),
        padding: EdgeInsets.all(20),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              child: Icon(Icons.delete, color: Colors.white, size: 50),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Share your ${widget.type} to community?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              "Your pet will be shared in the community. Other people can view your pet's details.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),

            Container(
              margin: EdgeInsets.only(top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancle",
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ButtonStyle(
                      overlayColor: WidgetStateProperty.all(Colors.black12),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      backgroundColor: WidgetStateProperty.all(Colors.white),
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (widget.type == "pet") {
                        // await Future.delayed(Duration(milliseconds: 300));
                        Navigator.pop(context);
                        firestoreService.createData(
                          FirebaseAuth.instance.currentUser!.uid,
                          widget.pet.uuid,
                        );
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
                              Expanded(
                                child: Text(
                                  "Your pet has been successfully added to the community.",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: Colors.green[400],
                        ),
                      );
                    },
                    child: Text(
                      "Confirm",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ButtonStyle(
                      overlayColor: WidgetStateProperty.all(Colors.black12),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      backgroundColor: WidgetStateProperty.all(Colors.amber),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
