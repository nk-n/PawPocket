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
}
