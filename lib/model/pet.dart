import 'dart:io';

import 'package:flutter/material.dart';

class Pet {
  String _uuid = "";
  String _petName = "";
  String _petImage = "";
  String _petBDay = "";
  String _petGender = "";
  String _petBreed = "";
  String _petFav = "";
  String _petHate = "";
  String _petDesc = "";
  String _petLocation = "";
  late List<Map<String, dynamic>> _memories;
  String _homeId = "";

  Pet({
    required String petName,
    required String petImage,
    required String petBDay,
    required String petGender,
    required String petBreed,
    required String petFav,
    required String petHate,
    required String petDesc,
    required String petLocation,
    required List<Map<String, dynamic>> memories,
    required String uuid,
    required String homeId,
  }) {
    setName = petName;
    setImage = petImage;
    setGender = petGender;
    setBirthday = petBDay;
    setBreed = petBreed;
    setFav = petFav;
    setHate = petHate;
    setDesc = petDesc;
    setLocation = petLocation;
    setMerories = memories;
    setUuid = uuid;
    setHomeId = homeId;
  }

  factory Pet.fromMap(Map<String, dynamic> data, String docId) {
    return Pet(
      uuid: docId,
      petName: data["name"] ?? "",
      petImage: data["image"] ?? "",
      petBDay: data["birthday"] ?? "",
      petGender: data["gender"] ?? "",
      petBreed: data["species"] ?? "",
      petFav: data["favorite"] ?? "",
      petHate: data["hate"] ?? "",
      petDesc: data["description"] ?? "",
      petLocation: data["location"] ?? "",
      memories: List<Map<String, dynamic>>.from(data["memories"] ?? []),
      homeId: data["homeId"],
    );
  }

  String get homeId => _homeId;
  String get uuid => _uuid;
  String get petName => _petName;
  String get petImage => _petImage;
  String get petBDay => _petBDay;
  String get petGender => _petGender;
  String get petBreed => _petBreed;
  String get petFav => _petFav;
  String get petHate => _petHate;
  String get petDesc => _petDesc;
  String get petLocation => _petLocation;
  List<Map<String, dynamic>> get memories => _memories;

  set setHomeId(String newId) {
    _homeId = newId;
  }

  set setUuid(String newId) {
    _uuid = newId;
  }

  set setName(String name) {
    if (name == "" || name.isEmpty) {
      throw FormatException("name must not be empty");
    }
    _petName = name;
  }

  set setImage(String file) {
    _petImage = file;
  }

  set setBirthday(String date) {
    _petBDay = date;
  }

  set setGender(String gender) {
    _petGender = gender;
  }

  set setBreed(String breed) {
    _petBreed = breed;
  }

  set setFav(String fav) {
    _petFav = fav;
  }

  set setHate(String hate) {
    _petHate = hate;
  }

  set setDesc(String desc) {
    _petDesc = desc;
  }

  set setLocation(String location) {
    _petLocation = location;
  }

  set setMerories(List<Map<String, dynamic>> newMemo) {
    _memories = newMemo;
  }

  void addMemories(Map<String, dynamic> item) {
    _memories.add(item);
  }

  void updateMemories(int index, Map<String, dynamic> item) {
    _memories[index] = item;
  }

  void removeMemoriesByIndex(int index) {
    _memories.removeAt(index);
  }

  void removeMemoreiesByID(String id) {
    for (int i = 0; i < _memories.length; i++) {
      Map<String, dynamic> item = _memories[i];
      if (item["id"] == id) {
        _memories.removeAt(i);
        break;
      }
    }
  }

  @override
  String toString() {
    return "$petName, $petImage, $petBDay, $petGender, $petBreed, $petFav, $petHate, $petDesc";
  }
}
