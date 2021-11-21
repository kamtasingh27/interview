import 'package:flutter/material.dart';
import 'package:interview/models/participant.dart';
import '../database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

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
    TextEditingController id = TextEditingController(text: "");
    TextEditingController participant1id = TextEditingController(text: "");
    TextEditingController participant2id = TextEditingController(text: "");
    TextEditingController starttime =
        TextEditingController(text: DateTime.now().toString());
    TextEditingController endtime =
        TextEditingController(text: DateTime.now().toString());
    TextEditingController resume = TextEditingController(text: "");
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
          TextFormField(
            controller: resume,
            decoration: const InputDecoration(
              icon: const Icon(Icons.person),
              hintText: 'https://example.com/resume.pdf',
              labelText: 'Resume Link',
            ),
          ),
          GestureDetector(
            onTap: () async {
              try {
                var st = DateTime.parse(starttime.text);
                var et = DateTime.parse(endtime.text);
                var now = DateTime.now();
                if (id.text == "") {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('ID is empty'),
                  ));
                } else if (participant1id.text == "") {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Participant 1 ID is empty'),
                  ));
                } else if (participant2id.text == "") {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Participant 2 ID is empty'),
                  ));
                } else if (starttime == "") {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Start Time is empty'),
                  ));
                } else if (endtime == "") {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('End Time is empty'),
                  ));
                } else if (resume.text == "") {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Participant 2 ID is empty'),
                  ));
                } else if (participant1id.text == participant2id.text) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Enter 2 different participants'),
                  ));
                } else if (st.isBefore(now)) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Start Time before current time'),
                  ));
                } else if (st.isAfter(et)) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('End Time before Start Time'),
                  ));
                } else if (await DatabaseService().searchoccupancy(
                            participant1id.text,
                            starttime.text,
                            endtime.text) ==
                        true ||
                    await DatabaseService().searchoccupancy(participant2id.text,
                            starttime.text, endtime.text) ==
                        true) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Time Overlap of Participants'),
                  ));
                } else {
                  await DatabaseService().addMeeting(
                      id.text,
                      participant1id.text,
                      participant2id.text,
                      starttime.text,
                      endtime.text,
                      resume.text);
                  await DatabaseService().addoccupancy(
                      participant1id.text, starttime.text, endtime.text);
                  await DatabaseService().addoccupancy(
                      participant2id.text, starttime.text, endtime.text);
                  await sendMail(participant1id.text);
                  await sendMail(participant2id.text);
                  Navigator.pop(context);
                }
              } on FirebaseException catch (e) {
                print(e);
              }
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
                      child: Text('Add Meeting',
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

Future<void> sendMail(participantid) async {
  String username = 'studywithdummy@gmail.com';
  String password = '9540892961';
  String email = await DatabaseService().getmail(participantid);

  final smtpServer = gmail(username, password);
  final equivalentMessage = Message()
    ..from = Address(username, 'Interview')
    ..recipients.add(Address(email))
    ..subject = 'Interview Scheduled'
    ..text = 'Your Interview is Scheduled.';

  await send(equivalentMessage, smtpServer);
}
