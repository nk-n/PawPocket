import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawpocket/model/home_model.dart';

class HomeFirestoreService {
  final home = FirebaseFirestore.instance.collection("Home");

  Stream<QuerySnapshot> getHomeStream() {
    final petStream = home.snapshots();

    return petStream;
  }

  Future<void> addHome(HomeModel newHome) {
    var createHome = home.add({
      "uuid": newHome.uuid,
      "name": newHome.name,
      "image": newHome.image,
    });

    return createHome;
  }
}
