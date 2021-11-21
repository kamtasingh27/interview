import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/meeting.dart';

class DatabaseService {
  final CollectionReference meetings =
      FirebaseFirestore.instance.collection('meetings');
  final CollectionReference participants =
      FirebaseFirestore.instance.collection('participants');

  Future addParticipant(String id, String name, String email) async {
    return await participants
        .doc(id)
        .set({
          'id': id,
          'name': name,
          'email': email,
        })
        .then((value) => print("Participant added successfully"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future addMeeting(String id, String participant1id, String participant2id,
      String starttime, String endtime, String resume) async {
    return await meetings
        .doc(id)
        .set({
          'id': id,
          'participant1id': participant1id,
          'participant2id': participant2id,
          'starttime': starttime,
          'endtime': endtime,
          'resume': resume,
        })
        .then((value) => print("Meeting added successfully"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future addoccupancy(String id, String starttime, String endtime) async {
    DocumentReference documentReference =
        participants.doc(id).collection('occupied').doc();
    return await documentReference
        .set({
          'starttime': starttime,
          'endtime': endtime,
        })
        .then((value) => print("Occupancy added successfully"))
        .catchError((error) => print("Failed to add appointment: $error"));
  }

  Future<bool> searchoccupancy(
      String id, String starttime, String endtime) async {
    var stt = DateTime.parse(starttime);
    var ett = DateTime.parse(endtime);
    int flag = 1;
    await participants
        .doc(id)
        .collection('occupied')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        var st = DateTime.parse(doc["starttime"]);
        var et = DateTime.parse(doc["endtime"]);
        if (stt.isBefore(et) && stt.isAfter(st)) {
          flag = 0;
        }
        if (ett.isAfter(st) && ett.isBefore(et)) {
          flag = 0;
        }
      });
    });
    print(flag);
    if (flag == 0) {
      return true;
    }
    return false;
  }

  Future<String> getmail(String participantid) async {
    String email = "";
    await participants
        .doc(participantid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        email = documentSnapshot.data()["email"];
      }
    });
    return email;
  }

  Stream<List<meeting>> get appoints {
    return meetings.snapshots().map(appointmentListFromSnapshot);
  }

  List<meeting> appointmentListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return meeting(
        id: doc.data()['id'],
        participant1id: doc.data()['participant1id'],
        participant2id: doc.data()['participant2id'],
        starttime: doc.data()['starttime'],
        endtime: doc.data()['endtime'],
        resume: doc.data()['resume'],
      );
    }).toList();
  }
}
