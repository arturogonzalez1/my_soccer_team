import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_soccer_team/screens/create_event_screen.dart';
import 'package:intl/intl.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Events',
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop()
          ),
          title: const Text('Events'),
          centerTitle: true,
        ),
          body: _buildListView(),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreateEventScreen()
                )
            ),
            backgroundColor: Colors.green,
            child: Icon(Icons.add),
          )
      ),
    );
  }
}

Future getEvents() async {
  var firestore = FirebaseFirestore.instance;
  QuerySnapshot qn = await firestore.collection("events").get();
  return qn.docs;
}

final DateFormat formatter = DateFormat('yyyy-MM-dd');

_buildListView() {
  return FutureBuilder(
      future: getEvents(),
      builder: (_, snapshot) {
        var data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text('Loadding...'),
          );
        }
        if (snapshot.hasData) {
          data = snapshot.data!;
          return Container(
            margin: const EdgeInsets.all(20),
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (_, index) {

                final date = data[index]['date'].toDate();
                final day = date.day.toString();
                final month = date.month.toString();
                final year = date.year.toString();

                final String dateFormated = day + '/' + month + '/' + year;

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.notifications_active),
                        title: Text(data[index]['name']),
                        subtitle: Text(dateFormated),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }
        else {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
      });
}