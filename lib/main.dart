import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'screens/addmeeting.dart';
import 'screens/addparticipant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/meeting.dart';
import 'package:provider/provider.dart';
import 'database.dart';
import 'screens/editmeeting.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interview Scheduler',
      home: const MyHomePage(title: 'Interview Scheduler'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<meeting>>.value(
      value: DatabaseService().appoints,
      initialData: [],
      builder: (context, appointments) {
        return meetlist(context);
      },
    );
  }

  Widget meetlist(BuildContext context) {
    final meetings = Provider.of<List<meeting>>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Interview Scheduler'),
          backgroundColor: Colors.black,
        ),
        body: ListView.builder(
            itemCount: meetings.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Container(
                        width: 500,
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
                              offset: Offset(
                                  2.0, 2.0), // shadow direction: bottom right
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Meeting ID - ' + meetings[index].id,
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Color(0xff4C3C88),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                            Text(
                              'Participand 1 ID - ' +
                                  meetings[index].participant1id,
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await sendMail(meetings[index].participant1id);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('Mail Sent'),
                                ));
                              },
                              child: Text(
                                'Participant 1 Email - ' +
                                    meetings[index].email1,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                            Text(
                              'Participand 2 ID - ' +
                                  meetings[index].participant2id,
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await sendMail(meetings[index].participant2id);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('Mail Sent'),
                                ));
                              },
                              child: Text(
                                'Participant 2 Email - ' +
                                    meetings[index].email2,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                            Text(
                              'Start Time - ' + meetings[index].starttime,
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                            Text(
                              'End Time - ' + meetings[index].endtime,
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                            TextButton(
                                onPressed: () {
                                  launch(meetings[index].resume);
                                },
                                child: Text('Resume')),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => editmeeting(
                                            id: meetings[index].id,
                                            participant1id:
                                                meetings[index].participant1id,
                                            participant2id:
                                                meetings[index].participant2id,
                                            starttime:
                                                meetings[index].starttime,
                                            endtime: meetings[index].endtime,
                                            resume: meetings[index].resume)),
                                  );
                                },
                                child: Text('Edit'))
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              );
            }),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          backgroundColor: Colors.black,
          overlayOpacity: 0,
          children: [
            SpeedDialChild(
              child: const Icon(
                Icons.meeting_room,
                color: Colors.white,
              ),
              backgroundColor: Colors.black,
              label: "Add Meeting",
              labelStyle: const TextStyle(color: Colors.white),
              labelBackgroundColor: Colors.black,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => addmeeting()),
                );
              },
            ),
            SpeedDialChild(
              child: const Icon(
                Icons.person,
                color: Colors.white,
              ),
              backgroundColor: Colors.black,
              label: "Add Participant",
              labelStyle: const TextStyle(color: Colors.white),
              labelBackgroundColor: Colors.black,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => addparticipant()),
                );
              },
            ),
          ],
        ));
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
