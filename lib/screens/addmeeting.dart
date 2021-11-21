import 'package:flutter/material.dart';
import '../database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';

class addmeeting extends StatefulWidget {
  const addmeeting({Key? key}) : super(key: key);

  @override
  _addmeetingState createState() => _addmeetingState();
}

class _addmeetingState extends State<addmeeting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Meeting",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: MyCustomForm(),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController id = TextEditingController();
    TextEditingController participant1id = TextEditingController();
    TextEditingController participant2id = TextEditingController();
    TextEditingController starttime = TextEditingController();
    TextEditingController endtime = TextEditingController();
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: id,
            decoration: const InputDecoration(
              icon: const Icon(Icons.circle_notifications_outlined),
              hintText: 'Enter Meeting ID',
              labelText: 'ID',
            ),
          ),
          TextFormField(
            controller: participant1id,
            decoration: const InputDecoration(
              icon: const Icon(Icons.person),
              hintText: 'Enter Participant 1 ID',
              labelText: 'Participant 1',
            ),
          ),
          TextFormField(
            controller: participant2id,
            decoration: const InputDecoration(
              icon: const Icon(Icons.person),
              hintText: 'Enter Participant 2 ID',
              labelText: 'Participant 2',
            ),
          ),
          TextFormField(
            controller: starttime,
            decoration: const InputDecoration(
              icon: const Icon(Icons.person),
              hintText: 'Start Time (YYYY-MM-DD HH:MM:SS)',
              labelText: 'Start Time',
            ),
          ),
          TextFormField(
            controller: endtime,
            decoration: const InputDecoration(
              icon: const Icon(Icons.person),
              hintText: 'End Time (YYYY-MM-DD HH:MM:SS)',
              labelText: 'End Time',
            ),
          ),
          GestureDetector(
            onTap: () async {
              try {
                await DatabaseService().addMeeting(id.text, participant1id.text,
                    participant2id.text, starttime.text, endtime.text);
                await DatabaseService().addoccupancy(
                    participant1id.text, starttime.text, endtime.text);
                await DatabaseService().addoccupancy(
                    participant2id.text, starttime.text, endtime.text);
              } on FirebaseException catch (e) {
                print(e);
              }
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: Colors.white,
                      style: BorderStyle.solid,
                      width: 1.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffF0EFFE),
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset:
                          Offset(2.0, 2.0), // shadow direction: bottom right
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Text('Add Appointment',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff4C3C88),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat')),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
