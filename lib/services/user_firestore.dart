import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user.dart';

class UserFirestoreServices {
  final CollectionReference user = FirebaseFirestore.instance.collection(
    'User',
  );

  Stream<QuerySnapshot> getUserStream() {
    final userStream = user.snapshots();
    return userStream;
  }

  Stream<DocumentSnapshot> readUserData(String docId) {
    return user.doc(docId).snapshots();
  }

  void createUserData(
    String username,
    String displayName,
    String email,
    String uuid,
  ) {
    user.doc(uuid).set({
      'email': email,
      'username': username,
      'display_name': displayName,
      'about': ' ',
      'profile_picture': 'none',
      'location': 'N/A',
      'pet_home': FieldValue.arrayUnion([]),
      'socials': {}
    });
  }

  Future<String> checkUserExistWithUsername(String username) async {
    final snapshot = await user.get();

    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        var userData = doc.data() as Map<String, dynamic>;
        if (userData['username'] == username) {
          return userData['email'];
        }
      }
    }
    return '';
  }
}
