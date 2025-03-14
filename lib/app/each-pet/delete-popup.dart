import 'package:flutter/material.dart';
import 'package:pawpocket/model/pet.dart';
import 'package:pawpocket/services/pet_firestore.dart';

class DeletePopup extends StatefulWidget {
  const DeletePopup({
    super.key,
    required this.pet,
    required this.type,
    this.memory,
  });

  final Pet? pet;
  final String type;
  final Map<String, dynamic>? memory;

  @override
  State<DeletePopup> createState() => _DeletePopupState();
}

class _DeletePopupState extends State<DeletePopup> {
  final PetFirestoreService firestoreService = PetFirestoreService();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      clipBehavior: Clip.antiAlias,
      contentPadding: EdgeInsets.all(0),
      backgroundColor: Colors.white,
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border(top: BorderSide(width: 10, color: Colors.redAccent)),
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
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Delete your ${widget.type} ?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "You will permanently lose your ${widget.type}",
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
                    onPressed: () async {
                      if (widget.pet == null) {
                        Navigator.pop(context);
                      }
                      if (widget.type == "pet") {
                        Navigator.popUntil(
                          context,
                          ModalRoute.withName('/allpet'),
                        );
                        await Future.delayed(Duration(milliseconds: 300));
                        firestoreService.deletePet(widget.pet);
                      } else if (widget.type == "memory") {
                        widget.pet!.removeMemoreiesByID(widget.memory!["id"]);
                        firestoreService.updatePet(
                          widget.pet!.uuid,
                          widget.pet!,
                        );
                        Navigator.pop(context);
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
                              Text(
                                widget.type == "pet"
                                    ? "Delete pet successfully"
                                    : widget.type == "memory"
                                    ? "Delete memory successfully"
                                    : "",
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
                    },
                    child: Text(
                      "Delete",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      overlayColor: WidgetStateProperty.all(Colors.black12),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      backgroundColor: WidgetStateProperty.all(
                        Colors.redAccent,
                      ),
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
