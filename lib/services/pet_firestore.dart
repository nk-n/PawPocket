import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:pawpocket/model/event.dart';
import 'package:pawpocket/model/pet.dart';
import 'package:pawpocket/services/community_firestore.dart';
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

  Future<void> addPet(Pet newPet) async {
    var createPet = await pet.add({
      "uuid": newPet.uuid,
      "name": newPet.petName,
      "breed": newPet.petBreed,
      "gender": newPet.petGender,
      "birthday": newPet.petBDay,
      "location": newPet.petLocation,
      "image": newPet.petImage,
      "favorite": newPet.petFav,
      "hate": newPet.petHate,
      "description": newPet.petDesc,
      "memories": newPet.memories,
      "homeId": newPet.homeId,
      "ownerId": newPet.ownerId,
    });

    String docId = createPet.id;
    newPet.setUuid = docId;
    updatePet(docId, newPet);
  }

  Stream<DocumentSnapshot> readAPet(String docId) {
    return pet.doc(docId).snapshots();
  }

  Future<Pet?> getPetData(String docId) async {
    final snapshot = await readAPet(docId).first;

    if (snapshot.exists) {
      return Pet.fromMap(snapshot.data() as Map<String, dynamic>, docId);
    } else {
      return null;
    }
  }

  Future<void> updatePet(String uuid, Pet newPet) {
    return pet.doc(uuid).update({
      "uuid": newPet.uuid,
      "name": newPet.petName,
      "breed": newPet.petBreed,
      "gender": newPet.petGender,
      "birthday": newPet.petBDay,
      "location": newPet.petLocation,
      "image": newPet.petImage,
      "favorite": newPet.petFav,
      "hate": newPet.petHate,
      "description": newPet.petDesc,
      "memories": newPet.memories,
      "homeId": newPet.homeId,
      "ownerId": newPet.ownerId,
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
    CommunityFirestoreServices().deleteData((deletePet?.uuid)!);
    pet.doc(deletePet?.uuid).delete();
  }

  Future<int> getPetCount(String uuid) async {
    final snapshot = await pet.get();
    int petCount = 0;
    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        var petData = doc.data() as Map<String, dynamic>;
        if (petData['ownerId'] == uuid) {
          petCount++;
        }
      }
    }
    return petCount;
  }
}
