import 'package:flutter/material.dart';
import 'package:my_soccer_team/screens/events_scren.dart';
import 'package:my_soccer_team/screens/my_team_screen.dart';

class HomeButtons extends StatelessWidget {
  const HomeButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
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
    );
  }
}