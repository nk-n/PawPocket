import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pawpocket/model/pet.dart';
import 'package:pawpocket/services/image_manager.dart';

class PetPanel extends StatelessWidget {
  const PetPanel({super.key, required this.pet});
  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          "/eachpet",
          arguments: {'pet': pet, 'edit_access': true},
        );
      },
      child: Container(
        height: 225,
        width: 420,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
            image: NetworkImage(ImageManager().getImageUrl(pet.petImage)),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.bottomLeft,
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          margin: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  pet.petName,
                  style: TextStyle(
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                  ),
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
  PetRecent({
    super.key,
    required this.targetTime,
    required this.reminderDesc,
    required this.title,
    required this.id,
  });
  final String id;
  final String title;
  final DateTime targetTime;
  final String reminderDesc;
  final weekDay = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];
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
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/eventdetail", arguments: id);
      },
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
                  "assets/images/calendar-wallpaper/cw-${Random(targetTime.microsecondsSinceEpoch).nextInt(12)}.jpg",
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 5, left: 15, right: 15),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.fade,
                      ),
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
                      "${weekDay[targetTime.weekday - 1]} ${targetTime.day} ${month[targetTime.month - 1]} ${targetTime.year}",
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
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 66, 133, 244),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    reminderDesc,
                    style: TextStyle(
                      fontSize: 16,
                      overflow: TextOverflow.fade,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
