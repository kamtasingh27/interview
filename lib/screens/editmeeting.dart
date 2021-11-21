import 'package:flutter/material.dart';
import 'package:interview/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:interview/models/participant.dart';

class editmeeting extends StatefulWidget {
  String id;
  String participant1id;
  String participant2id;
  var starttime;
  var endtime;
  String resume;
  editmeeting(
      {Key? key,
      required this.id,
      required this.participant1id,
      required this.participant2id,
      required this.starttime,
      required this.endtime,
      required this.resume})
      : super(key: key);

  @override
  _editmeetingState createState() => _editmeetingState();
}

class _editmeetingState extends State<editmeeting> {
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
      body: MyCustomForm(
        id: widget.id,
        participant1id: widget.participant1id,
        participant2id: widget.participant2id,
        starttime: widget.starttime,
        endtime: widget.endtime,
        resume: widget.resume,
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  String id;
  String participant1id;
  String participant2id;
  var starttime;
  var endtime;
  String resume;
  MyCustomForm(
      {Key? key,
      required this.id,
      required this.participant1id,
      required this.participant2id,
      required this.starttime,
      required this.endtime,
      required this.resume})
      : super(key: key);
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
    TextEditingController id = TextEditingController(text: widget.id);
    TextEditingController participant1id =
        TextEditingController(text: widget.participant1id);
    TextEditingController participant2id =
        TextEditingController(text: widget.participant2id);
    TextEditingController starttime =
        TextEditingController(text: widget.starttime);
    TextEditingController endtime = TextEditingController(text: widget.endtime);
    TextEditingController resume = TextEditingController(text: widget.resume);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            readOnly: true,
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
                      child: Text('Update Details',
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
