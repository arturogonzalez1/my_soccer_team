import 'package:flutter/material.dart';
import 'package:my_soccer_team/models/event.dart';
import 'package:my_soccer_team/services/event_types_service.dart';

class CardEvent extends StatelessWidget {

  final Event event;

  const CardEvent({
    Key? key, required this.event,
  }) : super(key: key);

  Future _getEventTypeById(String id){
    return EventTypeService().getEventTypeById(id);
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: _getEventTypeById(event.id),
      builder: (_, snapshot) {

        dynamic data = snapshot.data;

        print('datos: ' + data.toString());

        return Card(
          margin: const EdgeInsets.only(bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                leading: Icon(Icons.notifications_active),
                title: Text(''),
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
        );
      },
    );
  }
}