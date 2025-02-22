import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawpocket/app/add-pet/each-form-field.dart';

class AddPetForm extends StatefulWidget {
  const AddPetForm({super.key});

  @override
  State<AddPetForm> createState() => _AddPetFormState();
}

class _AddPetFormState extends State<AddPetForm> {
  final _nameController = TextEditingController();
  final _speciesController = TextEditingController();
  final _dateController = TextEditingController();
  final _likeController = TextEditingController();
  final _dislikeController = TextEditingController();
  String? _selectedImage = "";
  String gender = "";

  void updateGender(String value) {
    setState(() {
      gender = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _selectDate() async {
      DateTime? _picked = await showDatePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        initialDate: DateTime.now(),
      );

      if (_picked != null) {
        setState(() {
          _dateController.text = _picked.toString().split(" ")[0];
        });
      }
    }

    Future _pickImageFromGallery() async {
      final returnedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (returnedImage == null) return;
      setState(() {
        _selectedImage = returnedImage.path;
      });
    }

    return Padding(
      padding: const EdgeInsets.all(25),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                  child: IconButton(
                    key: ValueKey(gender),
                    onPressed: () {
                      updateGender("male");
                    },
                    color: Colors.blue[400],
                    style: IconButton.styleFrom(
                      backgroundColor: gender == "male"
                          ? Colors.blue[400]
                          : Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                        side: BorderSide(
                            color: Colors.blue[400] ?? Colors.blue, width: 3),
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    icon: ImageIcon(
                      AssetImage("assets/images/male_icon.png"),
                      color: gender == "male" ? Colors.white : null,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                  child: IconButton(
                    key: ValueKey(gender),
                    onPressed: () {
                      updateGender("female");
                    },
                    color: Colors.pink[300],
                    style: IconButton.styleFrom(
                      backgroundColor: gender == "female"
                          ? Colors.pink[300]
                          : Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                        side: BorderSide(
                            color: Colors.pink[300] ?? Colors.pink, width: 3),
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    icon: ImageIcon(
                      AssetImage("assets/images/female_icon.png"),
                      color: gender == "female" ? Colors.white : null,
                    ),
                  ),
                )
              ],
            ),
            EachFormField(label: "Name", controller: _nameController),
            EachFormField(label: "Species", controller: _speciesController),
            Text(
              "Birthday",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              readOnly: true,
              onTap: () {
                _selectDate();
              },
              controller: _dateController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                prefixIcon: Icon(Icons.calendar_today),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.grey[400] ?? Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.blue[400] ?? Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            EachFormField(label: "Likes", controller: _likeController),
            EachFormField(label: "Dislikes", controller: _dislikeController),
            Text(
              "Pet Image",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 2, color: Colors.grey[400] ?? Colors.grey),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(_selectedImage!)),
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      _pickImageFromGallery();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.blue[400],
                          borderRadius: BorderRadius.circular(10)),
                      child: const Text(
                        "Choose File",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Descriptions",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: null,
              decoration: InputDecoration(
                hintText: "Descriptions",
                hintStyle: TextStyle(color: Colors.grey[400]),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey[400] ?? Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.blue[600] ?? Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            Container(
              child: Text(""),
            )
          ],
        ),
      ),
    );
  }
}
