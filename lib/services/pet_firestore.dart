import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:pawpocket/model/event.dart';
import 'package:pawpocket/model/pet.dart';
import 'package:pawpocket/services/event_firestore.dart';

class PetFirestoreService {
  final CollectionReference pet = FirebaseFirestore.instance.collection('Pet');

  Future<QuerySnapshot> getPet() async {
    QuerySnapshot petGet = await pet.get();

    return petGet;
  }

  Stream<QuerySnapshot> getPetStream() {
    final petStream = pet.snapshots();

    return petStream;
  }

  Future<void> addPet(Pet newPet) {
    var createPet = pet.add({
      "uuid": newPet.uuid,
      "name": newPet.petName,
      "species": newPet.petBreed,
      "gender": newPet.petGender,
      "birthday": newPet.petBDay,
      "location": newPet.petLocation,
      "image": newPet.petImage,
      "favorite": newPet.petFav,
      "hate": newPet.petHate,
      "description": newPet.petDesc,
      "memories": newPet.memories,
      "homeId": newPet.homeId,
    });

    return createPet;
  }

  Stream<DocumentSnapshot> readAPet(String docId) {
    return pet.doc(docId).snapshots();
  }

  Future<void> updatePet(String uuid, Pet newPet) {
    return pet.doc(uuid).update({
      "uuid": newPet.uuid,
      "name": newPet.petName,
      "species": newPet.petBreed,
      "gender": newPet.petGender,
      "birthday": newPet.petBDay,
      "location": newPet.petLocation,
      "image": newPet.petImage,
      "favorite": newPet.petFav,
      "hate": newPet.petHate,
      "description": newPet.petDesc,
      "memories": newPet.memories,
    });
  }

  Future<void> deletePet(Pet? deletePet) async {
    EventFirestoreService eventFirestoreService = EventFirestoreService();
    var eventList = await eventFirestoreService.getEvent();
    if (eventList.docs.isNotEmpty) {
      for (int index = 0; index < eventList.docs.length; index++) {
        String docId = eventList.docs[index].id;
        Event event = Event.fromMap(
          eventList.docs[index].data() as Map<String, dynamic>,
          docId,
        );
        for (int j = 0; j < event.petId.length; j++) {
          if (event.petId[j] == deletePet?.uuid) {
            event.petId.removeAt(j);
            break;
          }
        }
        if (event.petId.isEmpty) {
          eventFirestoreService.deleteEvent(docId);
          continue;
        } else {
          eventFirestoreService.updateEvent(docId, event);
        }
      }
    }
    pet.doc(deletePet?.uuid).delete();
  }
}
