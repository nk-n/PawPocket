import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawpocket/app/add-pet/each-form-field.dart';
import 'package:pawpocket/app/calendar/date-time-field.dart';

class AddEventForm extends StatefulWidget {
  const AddEventForm({super.key});

  @override
  State<AddEventForm> createState() => _AddEventFormState();
}

class _AddEventFormState extends State<AddEventForm> {
  bool showTimeSelect = false;
  bool isCheckMedical = false;
  final _nameController = TextEditingController();
  final _titleController = TextEditingController();
  final _likeController = TextEditingController();
  final _dateFromController = TextEditingController();
  final _timeFromController = TextEditingController();
  final _dateToController = TextEditingController();
  final _timeToController = TextEditingController();
  String gender = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EachFormField(label: "Pet name", controller: _nameController),
            EachFormField(label: "Title", controller: _titleController),
            SizedBox(height: 20),
            DateTimeField(
              needTime: true,
              fontSize: 18,
              dateController: _dateFromController,
              timeController: _timeFromController,
            ),
            DateTimeField(
              needTime: true,
              fontSize: 18,
              dateController: _dateToController,
              timeController: _timeToController,
            ),
            SizedBox(height: 20),
            EachFormField(label: "Location", controller: _likeController),
            SizedBox(height: 20),
            Text("Descriptions", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: null,
              decoration: InputDecoration(
                hintText: "Descriptions",
                hintStyle: TextStyle(color: Colors.grey[400]),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey[400] ?? Colors.grey,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue[600] ?? Colors.blue,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Transform.scale(
                  scale: 1.5,
                  child: Checkbox(
                    checkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: BorderSide(width: 1, color: Colors.grey[400]!),
                    fillColor: WidgetStateColor.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.blue[400]!;
                      }
                      return Colors.white;
                    }),
                    value: isCheckMedical,
                    onChanged: (value) {
                      setState(() {
                        isCheckMedical = value!;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Text(
                    "Marks this as a medical appointment",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
