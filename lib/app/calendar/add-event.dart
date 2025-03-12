import 'package:flutter/material.dart';
import 'package:pawpocket/app/add-pet/add-pet-form.dart';
import 'package:pawpocket/app/calendar/add-event-form.dart';

class AddEvent extends StatelessWidget {
  const AddEvent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Add Event")),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImageIcon(
                AssetImage("assets/images/calendar-fill-icon.png"),
                size: 150,
                color: Color.fromARGB(255, 66, 133, 244),
              ),
              AddEventForm(),
            ],
          ),
        ),
      ),
    );
  }
}
