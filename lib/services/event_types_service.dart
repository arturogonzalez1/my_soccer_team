import 'package:cloud_firestore/cloud_firestore.dart';

class EventTypeService {

  Future getEventTypes() async {
    final firestore = FirebaseFirestore.instance;
    final response = await firestore.collection('event_types')
        .get();

    return response.docs;
  }

  Future getEventTypeById(String id) async {
    final firestore = FirebaseFirestore.instance;
    final response = await firestore.collection('event_types')
    .where('id', isEqualTo: id)
        .get();

    return response.docs;
  }
}