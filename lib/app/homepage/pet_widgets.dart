import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pawpocket/model/home_model.dart';
import 'package:pawpocket/model/pet.dart';
import '../each-pet/each-pet.dart';

class PetPanel extends StatelessWidget {
  const PetPanel({super.key, required this.pet});
  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/eachpet", arguments: {'pet': pet, 'edit_access': true});
      },
      child: Container(
        height: 225,
        width: 420,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
            image: NetworkImage(pet.petImage),
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
                    style: TextStyle(fontSize: 16, overflow: TextOverflow.fade),
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
  }
}

class AddPetButton extends StatelessWidget {
  const AddPetButton({super.key, required this.homeId});
  final String homeId;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(
          context,
          "/addpet",
          arguments: {"homeId": homeId, "status": "create"},
        );
      },
      style: ElevatedButton.styleFrom(
        fixedSize: Size(double.infinity, 225),
        overlayColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 66, 133, 244),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(width: 0, color: Color.fromARGB(255, 40, 178, 30)),
        ),
      ),
      child: Icon(Icons.add, size: 72, color: Colors.white),
    );
  }
}

class PetRecent extends StatelessWidget {
  const PetRecent({
    super.key,
    required this.pet,
    required this.date,
    required this.reminderDesc,
  });
  final Pet pet;
  final String date;
  final String reminderDesc;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(
          width: 420,
          child: Column(
            children: [
              SizedBox(
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(16),
                // ),
                height: 150,
                width: 420,
                child: Image.asset(
                  "assets/images/${pet.petImage}",
                  fit: BoxFit.cover,
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 15, right: 15),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${pet.petName}, ${pet.petBreed}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.more_horiz_rounded),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.calendar_month_sharp),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5, right: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      date,
                      style: TextStyle(
                        fontSize: 16,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                ],
              ),

              Container(
                margin: EdgeInsets.only(top: 5, left: 15, right: 15),
                alignment: Alignment.centerLeft,
                child: Text(
                  reminderDesc,
                  style: TextStyle(fontSize: 16, overflow: TextOverflow.fade),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
