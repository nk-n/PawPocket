import 'package:flutter/material.dart';

class Pet {
  Pet({required this.petName, required this.petImage, required this.petBDay, 
  required this.petGender, required this.petBreed, 
  required this.petFav, required this.petHate, required this.petDesc});

  final String petName;
  final String petImage;
  final String petBDay;
  final String petGender;
  final String petBreed;
  final String petFav;
  final String petHate;
  final String petDesc;
}

// class PetPanel extends StatelessWidget {
//   PetPanel({super.key, required this.pet});
//   final Pet pet;



// }

class PetRecent extends StatelessWidget {
  PetRecent({super.key, required this.pet, required this.date, required this.reminderDesc});
  final Pet pet;
  final String date;
  final String reminderDesc;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, overflow: TextOverflow.fade),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_horiz_rounded)
                ),
            )
            ],
          ),
           
           Row(
            children: [
            IconButton(
              onPressed: () {}, 
              icon: Icon(Icons.calendar_month_sharp)
            ),
            Container(
              margin: EdgeInsets.only(left: 5, right: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                date,
                style: TextStyle(fontSize: 16, overflow: TextOverflow.fade),
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
        )
        )
      ),
    );
  }
}