import 'package:flutter/material.dart';
import 'package:pawpocket/app/add-pet/add-pet-form.dart';

class AddPet extends StatelessWidget {
  const AddPet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Add pet"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImageIcon(
                AssetImage("assets/images/login_page_dog.png"),
                size: 150,
                color: Colors.brown[400],
              ),
              AddPetForm()
            ],
          ),
        ),
      ),
    );
  }
}
