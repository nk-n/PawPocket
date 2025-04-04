import 'package:flutter/material.dart';
import 'package:pawpocket/app/add-pet/add-pet.dart';
import 'package:pawpocket/app/calendar/add-event.dart';
import 'package:pawpocket/app/calendar/calendar.dart';
import 'package:pawpocket/app/calendar/event-detail.dart';
import 'package:pawpocket/app/calendar/history_calendar.dart';
import 'package:pawpocket/app/each-pet/each-pet.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawpocket/app/homepage/pet_home.dart';
import 'package:pawpocket/app/medical-history/medical-history.dart';
import 'package:pawpocket/firebase_options.dart';
import 'package:pawpocket/nav_bar.dart';
import 'package:pawpocket/services/noti_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login.dart';
import 'package:pawpocket/app/user_profile.dart';

void main() async {
  await Supabase.initialize(
    url: "https://sfubvmgltjrzjresfedi.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNmdWJ2bWdsdGpyempyZXNmZWRpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE4NjIwNzIsImV4cCI6MjA1NzQzODA3Mn0.7JcS1ePajIl7GkmTxv0qy8cGUe-vA6J_0uUFLe4GMqI",
  );
  WidgetsFlutterBinding.ensureInitialized();
  // await NotiService().requestPermission();
  NotiService().initNotification();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PawPocket Project",
      theme: ThemeData(
        fontFamily: 'NotoSansThai',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      // initialRoute: '/login',
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? '/login' : '/home',
          // '/debug',
      routes: {
        '/login': (context) => LoginPage(),
        '/eachpet': (context) => EachPet(),
        '/addpet': (context) => AddPet(),
        '/home': (context) => Navbar(),
        '/medicalhistory': (context) => MedicalHistory(),
        '/calendar': (context) => Calendar(),
        '/eventdetail': (context) => EventDetail(),
        '/addeventform': (context) => AddEvent(),
        '/allpet': (context) => PetHome(),
        '/historycalendar': (context) => HistoryCalendar(),
        '/profile': (context) => UserProfile(),
        '/debug': (context) => MyHomePage(title: "Debug"),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                NotiService().testNotification(
                  title: "Test Notification",
                  body: "This is a test notification",
                );
              },
              child: Text("Send Notification"),
            ),
            ElevatedButton(
              onPressed: () {
                NotiService().showNotification(
                  year: 2023,
                  month: 3,
                  day: 29,
                  hour: 14,
                  minute: 50,
                  title: "Test Schedule Notification",
                  body: "This is a schedule notification",
                );
              },
              child: Text("Schedule Notification"),
            ),
          ],
        ),
      ),
    );
  }
}
