import 'package:flutter/material.dart';
import 'package:pawpocket/model/pet.dart';
import '../each-pet/each-pet.dart';

class PetPanel extends StatelessWidget {
  PetPanel({super.key, required this.pet});
  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => EachPet()));
      },
      child: Container(
        height: 225,
        width: 420,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
            image: AssetImage("assets/images/${pet.petImage}"),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.bottomLeft,
        child: Container(
          margin: EdgeInsets.all(15),
          height: 50,
          width: 100,
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
                  pet.petGender == "Female"
                      ? "assets/images/female_icon.png"
                      : "assets/images/male_icon.png",
                ),
                color:
                    pet.petGender == "Female"
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
  AddPetButton({super.key});
 @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 225,
        width: 420,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 177, 223, 174),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Color.fromARGB(255, 40, 178, 30), width: 1),
        ),
        child: Icon(Icons.add, size: 72, color: Colors.white),
      ),
    );
  }
}

class PetRecent extends StatelessWidget {
  PetRecent({
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