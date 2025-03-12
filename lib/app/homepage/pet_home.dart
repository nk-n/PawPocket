import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawpocket/services/pet_firestore.dart';
import 'pet_widgets.dart';
import '../../model/pet.dart';

class PetHome extends StatefulWidget {
  const PetHome({super.key});

  @override
  State<PetHome> createState() => _PetHomeState();
}

class _PetHomeState extends State<PetHome> {
  final PetFirestoreService firestoreService = PetFirestoreService();

  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text(data["homename"]),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(bottom: 25, left: 25, right: 25),
        child: ScrollConfiguration(
          behavior: const ScrollBehavior(),
          child: StreamBuilder(
            stream: firestoreService.getPetStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('ERROR: ${snapshot.error}');
              }
              if (snapshot.hasData) {
                var petList = snapshot.data?.docs ?? [];
                return ListView.builder(
                  itemCount: petList.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == petList.length) {
                      return AddPetButton();
                    } else {
                      DocumentSnapshot document = petList[index];
                      String docId = document.id;
                      var eachPet = Pet.fromMap(
                        petList[index].data() as Map<String, dynamic>,
                        docId,
                      );
                      return Container(
                        margin: EdgeInsets.only(bottom: 20),
                        height: 225,
                        child: PetPanel(pet: eachPet),
                      );
                    }
                  },
                );
              } else {
                return Center(
                  child: Text("No pet found", style: TextStyle(fontSize: 20)),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
