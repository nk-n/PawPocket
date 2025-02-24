import 'package:flutter/material.dart';

class Pet {
  Pet({
    required this.petName,
    required this.petImage,
    required this.petBDay,
    required this.petGender,
    required this.petBreed,
    required this.petFav,
    required this.petHate,
    required this.petDesc,
  });

  final String petName;
  final String petImage;
  final String petBDay;
  final String petGender;
  final String petBreed;
  final String petFav;
  final String petHate;
  final String petDesc;
}
