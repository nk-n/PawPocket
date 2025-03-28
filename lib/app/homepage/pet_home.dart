import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pawpocket/model/home_model.dart';
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
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final HomeModel home = data["home"];
    return Scaffold(
      appBar: AppBar(
        title: Text(home.name),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 20, left: 25, right: 25),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextFormField(
                style: TextStyle(fontSize: 18),
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 40),
                  border: InputBorder.none,
                  fillColor: Colors.grey,
                  hintText: "Search",
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(bottom: 25, left: 25, right: 25),
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior(),
                  child: StreamBuilder(
                    stream: firestoreService.getPetStream(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data == null) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text('ERROR: ${snapshot.error}');
                      }
                      if (snapshot.hasData) {
                        var petList = snapshot.data?.docs ?? [];
                        var petListFilter = [];
                        for (int i = 0; i < petList.length; i++) {
                          Pet fliPet = Pet.fromMap(
                            petList[i].data() as Map<String, dynamic>,
                            petList[i].id,
                          );
                          if (fliPet.petName.toLowerCase().contains(
                                searchText.toLowerCase(),
                              ) ||
                              fliPet.petBreed.toLowerCase().contains(
                                searchText.toLowerCase(),
                              ) ||
                              fliPet.petGender.toLowerCase().contains(
                                searchText.toLowerCase(),
                              )) {
                            petListFilter.add(petList[i]);
                          }
                        }
                        return ListView.builder(
                          itemCount: petListFilter.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == petListFilter.length) {
                              return AddPetButton(homeId: home.uuid);
                            } else {
                              DocumentSnapshot document = petListFilter[index];
                              String docId = document.id;
                              var eachPet = Pet.fromMap(
                                petListFilter[index].data()
                                    as Map<String, dynamic>,
                                docId,
                              );
                              if (eachPet.homeId == home.uuid) {
                                return Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  height: 225,
                                  child: PetPanel(pet: eachPet),
                                );
                              } else {
                                return Container();
                              }
                            }
                          },
                        );
                      } else {
                        return Center(
                          child: Text(
                            "No pet found",
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
