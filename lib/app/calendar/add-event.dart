import 'package:flutter/material.dart';
import 'package:pawpocket/app/add-pet/add-pet-form.dart';
import 'package:pawpocket/app/calendar/event-form.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? data;
    if (ModalRoute.of(context)?.settings.arguments != null) {
      data = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${data == null ? "Add" : "Update"} Event"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImageIcon(
                AssetImage("assets/images/calendar-fill-icon.png"),
                size: 150,
                color: Color.fromARGB(255, 66, 133, 244),
              ),
              AddEventForm(
                status: data == null ? "add" : "update",
                event: data?["event"],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
