import 'package:cloud_firestore/cloud_firestore.dart';

class EventTypesService {
  Future getEventTypes() async {
    final firestore = FirebaseFirestore.instance;
    final response = await firestore.collection('event_types')
        .get();

    return response.docs;
  }
}