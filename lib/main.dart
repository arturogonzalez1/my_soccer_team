import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_soccer_team/screens/scan_screen.dart' as sc;
import 'package:my_soccer_team/services/event_service.dart';
import 'package:my_soccer_team/services/toast_service.dart';
import 'package:my_soccer_team/widgets/home/card_event.dart';
import 'package:my_soccer_team/widgets/home/home_buttons.dart';
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
          title: const Text('NRG'),
          backgroundColor: Colors.red,
        ),
        body: Container(
          margin: const EdgeInsets.all(20),
          child: Center(
            child: FutureBuilder(
              future: _getEvent(),
              builder: (_, snapshot) {

                List<Widget> items = [];

                if (snapshot.hasData) {

                  final event = verifyTodayEvents(snapshot.data);
                  if (event.id != "0") {
                    items.add(CardEvent(event: event,));
                  }
                }

                items.add(const HomeButtons());

                return Column(
                  children: items,
                );
              },
            )
          ),
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



