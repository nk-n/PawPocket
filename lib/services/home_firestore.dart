import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawpocket/model/home_model.dart';

class HomeFirestoreService {
  final home = FirebaseFirestore.instance.collection("Home");

  Stream<QuerySnapshot> getHomeStream() {
    final petStream = home.snapshots();

    return petStream;
  }

  Future<String> addHome(HomeModel newHome) async {
    DocumentReference createHome = await home.add({
      "uuid": newHome.uuid,
      "name": newHome.name,
      "image": newHome.image,
    });

    return createHome.id;
  }
}
