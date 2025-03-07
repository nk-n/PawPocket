import 'package:pawpocket/model/pet.dart';

class Event {
  Event({
    required Pet pet,
    required String title,
    required String dateStart,
    required String timeStart,
    required String dateStop,
    required String timeStop,
    required String location,
    required String descriptions,
    required bool isMedical,
  }) : _pet = pet,
       _title = title,
       _dateStart = dateStart,
       _timeStart = timeStart,
       _dateStop = dateStop,
       _timeStop = timeStop,
       _location = location,
       _descriptions = descriptions,
       _isMedical = isMedical;

  Pet _pet;
  String _title;
  String _dateStart;
  String _timeStart;
  String _dateStop;
  String _timeStop;
  String _location;
  String _descriptions;
  bool _isMedical;

  Pet get pet => _pet;
  String get title => _title;
  String get dateStart => _dateStart;
  String get timeStart => _timeStart;
  String get dateStop => _dateStop;
  String get timeStop => _timeStop;
  String get location => _location;
  String get descriptions => _descriptions;
  bool get isMedical => _isMedical;

  set pet(Pet yourPet) {
    _pet = yourPet;
  }

  set title(String title) {
    _title = title;
  }

  set dateStart(String dateStart) {
    _dateStart = dateStart;
  }

  set timeStart(String timeStart) {
    _timeStart = timeStart;
  }

  set dateStop(String dateStop) {
    _dateStop = dateStop;
  }

  set timeStop(String timeStop) {
    _timeStop = timeStop;
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
