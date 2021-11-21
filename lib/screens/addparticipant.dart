import 'package:flutter/material.dart';
import '../database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class addparticipant extends StatefulWidget {
  const addparticipant({Key? key}) : super(key: key);

  @override
  _addparticipantState createState() => _addparticipantState();
}

class _addparticipantState extends State<addparticipant> {
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
    TextEditingController name = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController id = TextEditingController();
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: id,
            decoration: const InputDecoration(
              icon: const Icon(Icons.circle_notifications_outlined),
              hintText: 'Enter Participant ID',
              labelText: 'ID',
            ),
          ),
          TextFormField(
            controller: name,
            decoration: const InputDecoration(
              icon: const Icon(Icons.person),
              hintText: 'Enter Participant Name',
              labelText: 'Name',
            ),
          ),
          TextFormField(
            controller: email,
            decoration: const InputDecoration(
              icon: const Icon(Icons.email),
              hintText: 'Enter Email',
              labelText: 'Email',
            ),
          ),
          GestureDetector(
            onTap: () async {
              try {
                await DatabaseService()
                    .addParticipant(id.text, name.text, email.text);
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
                      child: Text('Add Participant',
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
