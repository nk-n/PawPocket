import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';


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
    widgetOption = [Text('Hello ${FirebaseAuth.instance.currentUser?.email}'), const Text('Calendar'), const Text('Community'),  IconButton(onPressed: () async {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }, icon: Icon(Icons.logout))];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: widgetOption[indexNavBar],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
              BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/images/nav_bar_pet.png")), label: "Home"),
              BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/images/nav_bar_calendar.png")), label: "Calendar"),
              BottomNavigationBarItem(icon: ImageIcon(AssetImage("assets/images/nav_bar_community.png")), label: "Community"),
              // BottomNavigationBarItem(icon: Icon(Icons.pets, color: Color.fromARGB(177, 99, 57, 54),), label: "Home"),
              // BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: "Calendar"),
              // BottomNavigationBarItem(icon: Icon(Icons.south_america_outlined), label: "Community"),
              BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Profile"),
          ],
          showUnselectedLabels: false,
          showSelectedLabels: false,
          selectedItemColor: const Color.fromARGB(244, 133, 74, 74),
          currentIndex: indexNavBar,
          type: BottomNavigationBarType.fixed,
          onTap: (value) => setState(() => indexNavBar = value),
        ),
    );
  }

}