import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawpocket/model/pet.dart';

class PetFirestoreService {
  final CollectionReference pet = FirebaseFirestore.instance.collection('Pet');

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

  Future<void> deletePet(String docId) {
    return pet.doc(docId).delete();
  }
}
