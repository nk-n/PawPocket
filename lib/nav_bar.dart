import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawpocket/app/calendar/calendar.dart';
import 'app/homepage/pet_main_page.dart';
import 'app/user_profile.dart';

class Navbar extends StatefulWidget {
  Navbar({super.key});

  @override
  State<Navbar> createState() => _NavBarState();
}

class _NavBarState extends State<Navbar> {
  int indexNavBar = 0;
  List<Widget> widgetOption = [];
  @override
  void initState() {
    super.initState();
    widgetOption = [
      PetMainPage(user: FirebaseAuth.instance.currentUser?.email),
      Calendar(),
      const Text('Community'),
      // IconButton(
      //   onPressed: () async {
      //     await FirebaseAuth.instance.signOut();
      //     if (context.mounted) {
      //       Navigator.pushReplacementNamed(context, '/login');
      //     }
      //   },
      //   icon: Icon(Icons.emergency),
      // ),
      UserProfile(userID: FirebaseAuth.instance.currentUser?.uid,),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: widgetOption[indexNavBar]),
      bottomNavigationBar: BottomNavigationBar(
        unselectedLabelStyle: TextStyle(color: Colors.black),
        selectedLabelStyle: TextStyle(color: Colors.black),
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Colors.red,
            icon: ImageIcon(
              AssetImage("assets/images/nav_bar_pet.png"),
              size: 30,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/nav_bar_calendar.png"),
              size: 30,
            ),
            label: "Calendar",
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/nav_bar_community.png"),
              size: 30,
            ),
            label: "Community",
          ),
          // BottomNavigationBarItem(icon: Icon(Icons.pets, color: Color.fromARGB(177, 99, 57, 54),), label: "Home"),
          // BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: "Calendar"),
          // BottomNavigationBarItem(icon: Icon(Icons.south_america_outlined), label: "Community"),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, size: 30),
            label: "Profile",
          ),
        ],
        // showUnselectedLabels: false,
        // showSelectedLabels: false,
        selectedItemColor: const Color.fromARGB(255, 66, 133, 244),
        unselectedItemColor: Colors.grey,
        currentIndex: indexNavBar,
        type: BottomNavigationBarType.fixed,
        onTap: (value) => setState(() => indexNavBar = value),
      ),
    );
  }
}
