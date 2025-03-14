import 'package:flutter/material.dart';
import 'package:pawpocket/model/pet.dart';

class Event {
  Event({
    required String uuid,
    required List<String> petId,
    required String userId,
    required String title,
    required String date,
    required String time,
    required String location,
    required String descriptions,
    required bool isMedical,
    required DateTime startEvent,
    required int color,
  }) : _petId = petId,
       _userId = userId,
       _title = title,
       _date = date,
       _time = time,
       _location = location,
       _descriptions = descriptions,
       _isMedical = isMedical,
       _startEvent = startEvent,
       _color = color,
       _uuid = uuid;

  String _uuid;
  List<String> _petId;
  String _userId;
  String _title;
  DateTime _startEvent;
  String _date;
  String _time;
  String _location;
  String _descriptions;
  bool _isMedical;
  int _color;

  String get uuid => _uuid;
  String get userId => _userId;
  List<String> get petId => _petId;
  DateTime get startEvent => _startEvent;
  String get title => _title;
  String get date => _date;
  String get time => _time;
  String get location => _location;
  String get descriptions => _descriptions;
  bool get isMedical => _isMedical;
  int get color => _color;

  factory Event.fromMap(Map<String, dynamic> data, String docId) {
    return Event(
      uuid: docId,
      title: data["title"],
      descriptions: data["description"],
      isMedical: data["isMedical"],
      location: data["location"],
      petId: List<String>.from(data["petId"]),
      startEvent: data["startEvent"].toDate(),
      date: data["date"],
      time: data["time"],
      userId: data["userId"],
      color: data["color"],
    );
  }
  set setUuid(String uuid) {
    _uuid = uuid;
  }

  set setColor(int newColor) {
    _color = newColor;
  }

  set setStartEvent(DateTime time) {
    _startEvent = time;
  }

  set setUserId(String id) {
    _userId = id;
  }

  set pet(List<String> id) {
    _petId = id;
  }

  set title(String title) {
    _title = title;
  }

  set dateStart(String dateStart) {
    _date = dateStart;
  }

  set timeStart(String timeStart) {
    _time = timeStart;
  }

  set location(String location) {
    _location = location;
  }

  set descriptions(String desc) {
    _descriptions = desc;
  }

  set isMedical(bool isMed) {
    _isMedical = isMed;
  }
}
