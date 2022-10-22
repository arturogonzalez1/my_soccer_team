import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:my_soccer_team/screens/assists_screen.dart';
import 'package:my_soccer_team/screens/events_scren.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_soccer_team/screens/my_team_screen.dart';
import 'package:my_soccer_team/screens/scan_screen.dart' as sc;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_soccer_team/services/event_service.dart';
import 'package:my_soccer_team/services/toast_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'models/event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      title: 'My Soccer Team',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState  extends State<MyHomePage> {

  Color floattinActionButtonColor = Colors.grey;
  Function floattingActionButtonBehavior = () => {  };

  Future _getEvent(){
    return EventService().getEvents();
  }

  Event verifyTodayEvents(dynamic values) {

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    for(var i = 0; i < values.length; i++) {
      var date = values[i]['date'].toDate().toString();
      print('event date: ' + date);
      print('today date: ' + DateTime.now().toString());
      if(formatter.format(values[i]['date'].toDate()) == formatter.format(DateTime.now())){
        var event = Event();
        event.id = values[i].id;
        event.type = values[i]['type'];
        event.date = values[i]['date'];
        return event;
      }
    }
    var event = Event();
    event.id = "0";
    return event;
  }

  Future scan() async {
    var scanner = sc.Scanner();
    String read = await scanner.newScan();
    return read;
  }

  @override
  void initState() {
    super.initState();
  }

  _scanAndRegister(String eventId){
    scan().then((secretId) => ToastService().showToast(secretId + ' with ' + eventId, Colors.white));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chivitas'),
        ),
        body: Center(
          child: Column(
            children: [
              Card(
                margin: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const ListTile(
                      leading: Icon(Icons.notifications_active),
                      title: Text('Training'),
                      subtitle: Text('Unidad deportiva 09:00 am.'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: const Text('SCAN ASSISTS'),
                          onPressed: () {/* ... */},
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                direction: Axis.horizontal,
                children: [
                  Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child:
                      MaterialButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EventsScreen()
                            )
                        ),
                        child: const Text(' Events '),
                        textColor: Colors.white,
                        color: Colors.indigo,
                        padding: const EdgeInsets.fromLTRB(12, 30, 12, 30),
                      )
                  ),
                  Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child:
                      MaterialButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyTeamScreen()
                            )
                        ),
                        child: const Text(' Team '),
                        textColor: Colors.white,
                        color: Colors.cyan,
                        padding: const EdgeInsets.fromLTRB(12, 30, 12, 30),
                      )
                  ),
                ],
              ),
            ],
          )
        ),
        floatingActionButton: FutureBuilder(
          future: _getEvent(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              final event = verifyTodayEvents(snapshot.data);
              if (event.id != "0") {
                return FloatingActionButton(
                  onPressed: () => { _scanAndRegister(event.id) } ,
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.qr_code),
                );
              }
            }
            return FloatingActionButton(
              onPressed: () => { },
              backgroundColor: Colors.grey,
              child: const Icon(Icons.qr_code),
            );
          },
        )
      );
  }
}