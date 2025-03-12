import 'package:flutter/material.dart';
import 'package:pawpocket/app/add-pet/add-pet-form.dart';
import 'package:pawpocket/model/pet.dart';

class AddPet extends StatefulWidget {
  const AddPet({super.key});

  @override
  State<AddPet> createState() => _AddPetState();
}

class _AddPetState extends State<AddPet> {
  String status = "create";
  Pet? pet;

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)?.settings.arguments == null) {
      status = "create";
    } else {
      status = "update";
      Map<String, Pet?> data =
          ModalRoute.of(context)?.settings.arguments as Map<String, Pet?>;
      pet = data["pet"];
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${status == "create" ? "Add" : "Update"} pet"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImageIcon(
                AssetImage("assets/images/login_page_dog.png"),
                size: 150,
                color: Colors.brown[400],
              ),
              AddPetForm(pet: pet, status: status),
            ],
          ),
        ),
      ),
    );
  }
}
