import 'package:flutter/material.dart';

class AssistsScreen extends StatelessWidget {
  const AssistsScreen({Key? key }) : super(key: key);
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
          body: const CreateEventForm()
      ),
    );
  }
}

// Create a Form widget.
class CreateEventForm extends StatefulWidget {
  const CreateEventForm({Key? key}) : super(key: key);

  @override
  CreateEventFormState createState() {
    return CreateEventFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class CreateEventFormState extends State<CreateEventForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  bool _validate = false;
  final nameFieldController = TextEditingController();
  final dateFieldController = TextEditingController(
      text: DateTime.now().toString());

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(top: 20),
                  // add padding to adjust text
                  isDense: true,
                  hintText: 'Complete name',
                  prefixIcon: Icon(Icons.account_box, color: Colors.grey),
                ),
                controller: nameFieldController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ],
          ),
        )
    );
  }


}