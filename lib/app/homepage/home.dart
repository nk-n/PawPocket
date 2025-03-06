import 'package:flutter/material.dart';
import '../../model/pet.dart';
import 'pet_home.dart';

class Home extends StatelessWidget {
  Home({super.key, required this.homeName, required this.homeImage});

  String homeName;
  String homeImage;

  List<Pet> pets = [
    Pet(
      petName: "Butter",
      petImage: "homePic.png",
      petBDay: "2021-01-21",
      petGender: "Female",
      petBreed: "British Shorthair",
      petFav: "ball, bath, chicken, nugget",
      petHate: "medicine",
      petDesc:
          "cheerful and outgoing. I got her from my mom when she was only 1-year-old.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PetHome(user: "user", homeName: homeName),
          ),
        );
      },

      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Container(
              height: 150,
              width: 100,
              child: Image.asset(
                "assets/images/homePic.png",
                fit: BoxFit.contain,
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                homeName,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, overflow: TextOverflow.fade),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
