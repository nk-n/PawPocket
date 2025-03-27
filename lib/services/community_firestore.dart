import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawpocket/services/pet_firestore.dart';

class CommunityFirestoreServices {
  final CollectionReference community = FirebaseFirestore.instance.collection(
    'Community',
  );

  Stream<QuerySnapshot> getCommunityStream() {
    final communityStream = community.snapshots();
    return communityStream;
  }

  Stream<DocumentSnapshot> readData(String docId) {
    return community.doc(docId).snapshots();
  }

  void createData(
    String ownerID,
    String petID,
  ) {
    community.doc(petID).set({
      'pet_id': petID,
      'owner_id': ownerID
    });
  }

    Future<Map> isExist(String petID) async {
    final snapshot = await community.get();

    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        var sharedPetData = doc.data() as Map<String, dynamic>;
        print("${sharedPetData['pet_id']} : $petID");
        if (sharedPetData['pet_id'] == petID) {
          return sharedPetData;
        }
      }
    }
    return {};
  }
}
