import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawpocket/app/add-pet/each-form-field.dart';
import 'package:pawpocket/app/add-pet/multipleline-form-field.dart';
import 'package:pawpocket/app/calendar/date-time-field.dart';
import 'package:pawpocket/app/each-pet/delete-popup.dart';
import 'package:pawpocket/app/each-pet/memory-popup.dart';
import 'package:pawpocket/model/pet.dart';
import 'package:pawpocket/services/image_manager.dart';
import 'package:pawpocket/services/pet_firestore.dart';

class EachPet extends StatefulWidget {
  const EachPet({super.key});

  @override
  State<EachPet> createState() => _EachPetState();
}

class _EachPetState extends State<EachPet> {
  final PetFirestoreService firestoreService = PetFirestoreService();
  final month = [
    "JAN",
    "FEB",
    "MAR",
    "APR",
    "MAY",
    "JUN",
    "JUL",
    "AUG",
    "SEP",
    "OCT",
    "NOV",
    "DEC",
  ];

  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    Pet pet = data["pet"];
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream:
          firestoreService.readAPet(pet.uuid)
              as Stream<DocumentSnapshot<Map<String, dynamic>>>,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('ERROR: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          pet = Pet.fromMap(
            snapshot.data!.data() as Map<String, dynamic>,
            pet.uuid,
          );
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(pet.petName),
              actions: [
                if (data['edit_access'])
                  IconButton(
                    padding: EdgeInsets.all(0),
                    focusColor: Colors.white,
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        "/addpet",
                        arguments: {
                          "pet": pet,
                          "status": "update",
                          "homeId": pet.homeId,
                        },
                      );
                    },
                    icon: ImageIcon(
                      AssetImage("assets/images/pen-icon.png"),
                      size: 25,
                    ),
                    style: ButtonStyle(
                      iconColor: WidgetStateColor.resolveWith((states) {
                        if (states.contains(WidgetState.pressed)) {
                          return Colors.blue; // สีตอนกด
                        }
                        return Colors.grey;
                      }),
                      overlayColor: WidgetStateProperty.all(Colors.white),
                    ),
                  ),
                if (data['edit_access'])
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        focusColor: Colors.white,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return DeletePopup(pet: pet, type: "pet");
                            },
                          );
                        },
                        icon: Icon(Icons.delete),
                        style: ButtonStyle(
                          iconColor: WidgetStateColor.resolveWith((states) {
                            if (states.contains(WidgetState.pressed)) {
                              return Colors.redAccent;
                            }
                            return Colors.grey;
                          }),
                          overlayColor: WidgetStateProperty.all(Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            body: ListView.builder(
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: FutureBuilder<String>(
                                    future: ImageManager().getImageUrl(
                                      pet.petImage,
                                    ),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                              ConnectionState.waiting ||
                                          !snapshot.hasData) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Center(
                                          child: Text(
                                            "ERROR: ${snapshot.error}",
                                          ),
                                        );
                                      }
                                      return Image.network(
                                        snapshot.data!,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: ImageIcon(
                                  AssetImage(
                                    "assets/images/${pet.petGender}_icon.png",
                                  ),
                                  color:
                                      pet.petGender == "female"
                                          ? Colors.pink[200]
                                          : Colors.blue,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${pet.petBreed}",
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    ImageIcon(
                                      const AssetImage(
                                        "assets/images/location_icon.png",
                                      ),
                                      color: Colors.grey[500],
                                      size: 30,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "${pet.petLocation}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 30),
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                "/medicalhistory",
                                arguments: {
                                  'edit_access': data['edit_access'],
                                  'pet': pet,
                                },
                              );
                            },
                            padding: const EdgeInsets.all(15),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.pink[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            icon: const ImageIcon(
                              AssetImage("assets/images/aid_icon.png"),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: List.generate(4, (index) {
                            final List<Map<String, dynamic>> petDesc = [
                              {
                                "icon": "hbd_icon.png",
                                "desc": pet.petBDay,
                                "color": Colors.grey[600],
                              },
                              {
                                "icon": "like_icon.png",
                                "desc": pet.petFav,
                                "color": Colors.blue[400],
                              },
                              {
                                "icon": "dislike_icon.png",
                                "desc": pet.petHate,
                                "color": Colors.red[400],
                              },
                              {
                                "icon": "doc_icon.png",
                                "desc": pet.petDesc,
                                "color": Colors.grey[600],
                              },
                            ];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  ImageIcon(
                                    AssetImage(
                                      "assets/images/${petDesc[index]["icon"]}",
                                    ),
                                    color: petDesc[index]["color"],
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "${petDesc[index]["desc"]}",
                                      style: TextStyle(
                                        color: petDesc[index]["color"],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 66, 133, 244),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  ImageIcon(
                                    const AssetImage(
                                      "assets/images/sand_clock_icon.png",
                                    ),
                                    color: Colors.white,
                                    size: 80,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Your Precious Memories",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 30),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: pet.memories.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 15),
                                    child: IntrinsicHeight(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                DateTime.parse(
                                                  pet.memories[index]["date"],
                                                ).year.toString(),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color.fromARGB(
                                                    255,
                                                    66,
                                                    133,
                                                    244,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                month[DateTime.parse(
                                                  pet.memories[index]["date"],
                                                ).month],
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Color.fromARGB(
                                                    255,
                                                    66,
                                                    133,
                                                    244,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                width: 50,
                                                height: 50,
                                                child: Text(
                                                  DateTime.parse(
                                                    pet.memories[index]["date"],
                                                  ).day.toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 23,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        100,
                                                      ),
                                                  color: Color.fromARGB(
                                                    255,
                                                    66,
                                                    133,
                                                    244,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Expanded(
                                                child: Container(
                                                  width: 7,
                                                  decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                      255,
                                                      66,
                                                      133,
                                                      244,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          100,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 20),
                                          Expanded(
                                            child: Stack(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(
                                                    15,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color: Colors.grey[200]!,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                          right: 50,
                                                        ),
                                                        child: Text(
                                                          "${pet.memories[index]["title"]}",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        "${pet.memories[index]["description"]}",
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                15,
                                                              ),
                                                        ),
                                                        child: Image.file(
                                                          File(
                                                            "${pet.memories[index]["image"]}",
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (data['edit_access'])
                                                  Positioned(
                                                    top: 15,
                                                    right: 15,
                                                    child: PopupMenuButton(
                                                      color: Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              15,
                                                            ),
                                                      ),
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            WidgetStateProperty.all(
                                                              Colors.white,
                                                            ),
                                                      ),
                                                      icon: ImageIcon(
                                                        AssetImage(
                                                          "assets/images/menu_icon.png",
                                                        ),
                                                      ),
                                                      itemBuilder:
                                                          (context) => [
                                                            PopupMenuItem(
                                                              onTap:
                                                                  () => showDialog(
                                                                    context:
                                                                        context,
                                                                    builder: (
                                                                      context,
                                                                    ) {
                                                                      return StatefulBuilder(
                                                                        builder: (
                                                                          context,
                                                                          setState,
                                                                        ) {
                                                                          return MemoryPopup(
                                                                            pet:
                                                                                pet,
                                                                            type:
                                                                                "edit",
                                                                            newMemory:
                                                                                pet.memories[index],
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                  ),
                                                              child: Text(
                                                                "Edit",
                                                                style:
                                                                    TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                    ),
                                                              ),
                                                            ),
                                                            PopupMenuItem(
                                                              onTap: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (
                                                                    context,
                                                                  ) {
                                                                    return DeletePopup(
                                                                      pet: pet,
                                                                      type:
                                                                          "memory",
                                                                      memory:
                                                                          pet.memories[index],
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child: Text(
                                                                "Delete",
                                                                style:
                                                                    TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (data['edit_access'])
                              ElevatedButton(
                                onPressed:
                                    () => showDialog(
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (context, setState) {
                                            return MemoryPopup(
                                              pet: pet,
                                              type: "create",
                                            );
                                          },
                                        );
                                      },
                                    ),
                                style: ElevatedButton.styleFrom(
                                  overlayColor: Colors.white,
                                  backgroundColor: Color.fromARGB(
                                    255,
                                    66,
                                    133,
                                    244,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ImageIcon(
                                        AssetImage(
                                          "assets/images/plus_icon.png",
                                        ),
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      SizedBox(width: 20),
                                      Text(
                                        "Add new memories",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
