import 'package:flutter/material.dart';
import 'pet.dart';

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
        Navigator.pushNamed(context, '/eachpet');
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
              // height: 150,
              // width: 100,
              alignment: Alignment.center,
              child: Text(
                homeName,
                style: TextStyle(fontSize: 16, overflow: TextOverflow.fade),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
