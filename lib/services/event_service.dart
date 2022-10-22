import 'package:cloud_firestore/cloud_firestore.dart';

class EventService {
  Future getEvents() async {
    final firestore = FirebaseFirestore.instance;
    final response = await firestore.collection('events')
        .get();

    return response.docs;
  }
}