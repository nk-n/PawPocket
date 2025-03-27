import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawpocket/model/event.dart';

class EventFirestoreService {
  final CollectionReference event = FirebaseFirestore.instance.collection(
    'Event',
  );

  Future<QuerySnapshot> getEvent() async {
    QuerySnapshot eventSnapshot = await event.get();

    return eventSnapshot;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getEventStreamById(
    String docId,
  ) {
    final eventStream = event.doc(docId).snapshots();

    return eventStream as Stream<DocumentSnapshot<Map<String, dynamic>>>;
  }

  Stream<QuerySnapshot> getEventStream() {
    final eventStream =
        event.orderBy("startEvent", descending: false).snapshots();

    return eventStream;
  }

  Future<void> updateEvent(String docId, Event newEvent) {
    return event.doc(docId).update({
      "startEvent": newEvent.startEvent,
      "petId": newEvent.petId,
      "userId": newEvent.userId,
      "title": newEvent.title,
      "date": newEvent.date,
      "time": newEvent.time,
      "location": newEvent.location,
      "description": newEvent.descriptions,
      "type": newEvent.type,
      "color": newEvent.color,
      "uuid": newEvent.uuid,
    });
  }

  Future<void> addEvent(Event newEvent) async {
    DocumentReference createEvent = await event.add({
      "startEvent": newEvent.startEvent,
      "petId": newEvent.petId,
      "userId": newEvent.userId,
      "title": newEvent.title,
      "date": newEvent.date,
      "time": newEvent.time,
      "location": newEvent.location,
      "description": newEvent.descriptions,
      "type": newEvent.type,
      "color": newEvent.color,
    });

    String docId = createEvent.id;
    newEvent.setUuid = docId;
    updateEvent(docId, newEvent);
  }

  Future<void> deleteEvent(String docId) {
    return event.doc(docId).delete();
  }
}
