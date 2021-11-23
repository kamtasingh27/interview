class meeting {
  String id;
  String participant1id;
  String email1;
  String participant2id;
  String email2;
  var starttime;
  var endtime;
  String resume;

  meeting({
    required this.id,
    required this.participant1id,
    required this.email1,
    required this.participant2id,
    required this.email2,
    required this.starttime,
    required this.endtime,
    required this.resume,
  });
}
