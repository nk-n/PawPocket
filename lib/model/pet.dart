import 'dart:io';

import 'package:flutter/material.dart';

class Pet {
  Pet({
    required String petName,
    required String petImage,
    required String petBDay,
    required String petGender,
    required String petBreed,
    required String petFav,
    required String petHate,
    required String petDesc,
  }) : _petName = petName,
       _petImage = petImage,
       _petGender = petGender,
       _petBDay = petBDay,
       _petBreed = petBreed,
       _petFav = petFav,
       _petHate = petHate,
       _petDesc = petDesc;

  String _petName;
  String _petImage;
  String _petBDay;
  String _petGender;
  String _petBreed;
  String _petFav;
  String _petHate;
  String _petDesc;

  String get petName => _petName;
  String get petImage => _petImage;
  String get petBDay => _petBDay;
  String get petGender => _petGender;
  String get petBreed => _petBreed;
  String get petFav => _petFav;
  String get petHate => _petHate;
  String get petDesc => _petDesc;

  set petName(String name) {
    if (name == "" || name.isEmpty) {
      throw FormatException("name must not be empty");
    }
    _petName = name;
  }

  set petImage(String file) {
    _petImage = file;
  }

  set petBDay(String date) {
    _petBDay = date;
  }

  set petGender(String gender) {
    _petGender = gender;
  }

  set petBreed(String breed) {
    _petBreed = breed;
  }

  set petFav(String fav) {
    _petFav = fav;
  }

  set petHate(String hate) {
    _petHate = hate;
  }

  set petDesc(String desc) {
    _petDesc = desc;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "$petName, $petImage, $petBDay, $petGender, $petBreed, $petFav, $petHate, $petDesc";
  }
}
