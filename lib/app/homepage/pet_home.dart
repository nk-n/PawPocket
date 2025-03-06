import 'package:flutter/material.dart';
import 'pet_widgets.dart';
import '../../model/pet.dart';
import 'home.dart';

class PetHome extends StatefulWidget {
  PetHome({super.key, required this.user, required this.homeName});
  final user;
  final String homeName;
  List pets = [
    PetPanel(
      pet: Pet(
        petName: "Butter",
        petImage: "cat.png",
        petBDay: "2021-01-21",
        petGender: "Female",
        petBreed: "British Shorthair",
        petFav: "ball, bath, chicken, nugget",
        petHate: "medicine",
        petDesc:
            "cheerful and outgoing. I got her from my mom when she was only 1-year-old.",
      ),
    ),

    PetPanel(
      pet: Pet(
        petName: "Carrot",
        petImage: "baby_cat.png",
        petBDay: "2021-01-21",
        petGender: "Male",
        petBreed: "British Shorthair",
        petFav: "ball, bath, chicken, nugget",
        petHate: "medicine",
        petDesc:
            "cheerful and outgoing. I got her from my mom when she was only 1-year-old.",
      ),
    ),

    AddPetButton(),
  ];

  @override
  State<PetHome> createState() => _PetHomeState();
}

class _PetHomeState extends State<PetHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.homeName),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        child: ScrollConfiguration(
          behavior: const ScrollBehavior(),
          child: ListView.builder(
            itemCount: widget.pets.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 225,
                width: 420,
                margin: EdgeInsets.only(bottom: 25, left: 25, right: 25),
                child: widget.pets[index],
              );
            },
          ),
        ),
      ),
    );
  }
}
