import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_soccer_team/main.dart';
import 'package:my_soccer_team/screens/create_player_screen.dart';

class MyTeamScreen extends StatelessWidget {
  const MyTeamScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Team',
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop()
          ),
          title: const Text('Team'),
          centerTitle: true,
        ),
        body: _buildListView(),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreatePlayerScreen()
                )
            ),
            backgroundColor: Colors.green,
            child: Icon(Icons.add),
          )
      ),
    );
  }
}

Future getPlayers() async {
  var firestore = FirebaseFirestore.instance;
  QuerySnapshot qn = await firestore.collection("players").get();
  return qn.docs;
}

String getPlayerAgeByBirth(DateTime birth){
  final days = DateTime.now().difference(birth).inDays;
  final years = days / 365.25;
  return years.toInt().toString();
}

_buildListView() {
  return FutureBuilder(
      future: getPlayers(),
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
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.account_circle),
                        title: Text(data[index]['name']),
                        subtitle: Text(getPlayerAgeByBirth(data[index]['birth'].toDate()) + ' years old'),
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