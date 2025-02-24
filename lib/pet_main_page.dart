import 'package:flutter/material.dart';
import 'package:pawpocket/nav_bar.dart';
import 'model/home.dart';
import 'model/pet.dart';

class PetMainPage extends StatefulWidget {
  PetMainPage({super.key, required this.user});
  final user;
  List homes = [
    Home(homeName: "My Home", homeImage: "homePic.png"),
    Home(homeName: "Parents' home", homeImage: "homePic.png"),
    Card(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 177, 223, 174),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color.fromARGB(255, 40, 178, 30), width: 1),
        ),
        child: Icon(Icons.add, size: 72, color: Colors.white),
      ),
    ),
  ];

  @override
  State<PetMainPage> createState() => _PetMainPageState();
}

class _PetMainPageState extends State<PetMainPage> {
  List recents = [];
  @override
  void initState() {
    final Pet tmpPet = Pet(
      petName: "Butter",
      petImage: "cat.png",
      petBDay: "2021-01-21",
      petGender: "Female",
      petBreed: "British Shorthair",
      petFav: "ball, bath, chicken, nugget",
      petHate: "medicine",
      petDesc:
          "cheerful and outgoing. I got her from my mom when she was only 1-year-old.",
    );

    recents = [
      PetRecent(
        pet: tmpPet,
        date: "Thursday 14 February 2568",
        reminderDesc: "Vaccination",
      ),
      PetRecent(pet: tmpPet, date: "Monday 11 May 2568", reminderDesc: "Vaccination"),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 15),
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hello, ${widget.user}!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.notifications),
              ],
            ),
            const SizedBox(height: 20),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Color.fromARGB(50, 147, 147, 147),
                // gradient: LinearGradient(colors: [Color.fromARGB(255, 247, 30, 30)]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                height: 40,
                width: 450,
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    Icon(Icons.search),
                    const SizedBox(width: 10),
                    Text("Search"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              height: 150,
              child: ScrollConfiguration(
                behavior: const ScrollBehavior(),
                child: ListView.builder(
                  itemCount: widget.homes.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 150,
                      width: 100,
                      margin: EdgeInsets.only(right: 7, left: 7),
                      child: widget.homes[index],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Recent", style: TextStyle(fontSize: 18)),
            ),
            // const SizedBox(height: 10),
            Expanded(
              child: ScrollConfiguration(
                behavior: const ScrollBehavior(),
                child: ListView.builder(
                  itemCount: recents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 300,
                      width: 420,
                      margin: EdgeInsets.only(bottom: 15),
                      child: recents[index],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
