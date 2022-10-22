import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_soccer_team/services/event_types_service.dart';

class CreateEventScreen extends StatelessWidget {
  const CreateEventScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'New Event',
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text("New Event"),
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
  final typeFieldController = TextEditingController();
  final dateFieldController = TextEditingController(text: DateTime.now().toString());

  String dropdownValue = '43BDpq9x2PRjtrjULWCw';

  Future _getEventTypes(){
    return EventTypeService().getEventTypes();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(20),
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Name',
              ),
              controller: nameFieldController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            FutureBuilder(
              future: _getEventTypes(),
              builder: (_, snapshot) {
                dynamic data = snapshot.data!;
                return DropdownButton(
                  isExpanded: true,
                  value: dropdownValue,
                  elevation: 16,
                  underline: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value!;
                      print(dropdownValue);
                    });
                  },
                  items: data.map<DropdownMenuItem<String>>((dynamic value) {
                    return DropdownMenuItem<String>(
                      value: value.id,
                      child: Text(value['name']),
                    );
                  }).toList(),
                );
              },
            ),
            DateTimePicker(
              controller: dateFieldController,
              type: DateTimePickerType.dateTimeSeparate,
              dateMask: 'd MMMM, yyyy',
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              icon: const Icon(Icons.event, color: Colors.grey,),
              dateLabelText: 'Date',
              timeLabelText: "Hour",
              onChanged: (val) => print(val),
              validator: (val) {
                return null;
              },
              //controller: dateFieldController,
              onSaved: (val) => print(val),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Saving data...')),
                    );
                    if (_sendToServer(nameFieldController.text, dropdownValue, Timestamp.fromDate(DateTime.parse(dateFieldController.text)))){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Saved :)'), backgroundColor: Colors.green),
                      );
                    }
                  }
                },
                child: const Center(
                  child: Text('Save'),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
  bool _sendToServer(String name, String type, Timestamp date){
    if (_formKey.currentState!.validate() ){
      //No error in validator
      _formKey.currentState!.save();
      FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
        CollectionReference reference = FirebaseFirestore.instance.collection('events');
        var id = await reference.add({"name": name, "type": type, "date": date});
      });
    } else {
      // validation error
      setState(() {
        _validate = true;
      });
      return false;
    }
    return true;
  }
}