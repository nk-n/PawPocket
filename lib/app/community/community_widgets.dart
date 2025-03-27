import 'package:flutter/material.dart';
import 'package:pawpocket/services/pet_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/pet.dart';
import 'package:pawpocket/services/image_manager.dart';

class CommunityPetTile extends StatelessWidget {
  const CommunityPetTile({
    super.key,
    required this.petID,
    required this.ownerID,
  });

  final String petID;
  final String ownerID;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream:
          PetFirestoreService().readAPet(petID)
              as Stream<DocumentSnapshot<Map<String, dynamic>>>,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('ERROR: ${snapshot.error}');
        }
        if (snapshot.hasData) {
          var pet = Pet.fromMap(
            snapshot.data!.data() as Map<String, dynamic>,
            petID,
          );
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                "/eachpet",
                arguments: {'pet': pet, 'edit_access': false, 'owner': ownerID},
              );
            },
            child: Container(
              height: 225,
              width: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: DecorationImage(
                  image: ImageManager().getImageProvider(pet.petImage),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.bottomLeft,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          pet.petName,
                          style: TextStyle(
                            fontSize: 16,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        const SizedBox(width: 10),
                        ImageIcon(
                          AssetImage(
                            pet.petGender == "female"
                                ? "assets/images/female_icon.png"
                                : "assets/images/male_icon.png",
                          ),
                          color:
                              pet.petGender == "female"
                                  ? Colors.pink[200]
                                  : Colors.blue[400],
                          size: 30,
                        ),
                      ],
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
