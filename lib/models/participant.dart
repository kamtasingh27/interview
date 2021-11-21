class participant {
  String id;
  String name;
  String email;
  List<occupied> occ = [];
  participant({required this.id, required this.name, required this.email});
}

class occupied {
  var starttime;
  var endtime;
  occupied({this.starttime, this.endtime});
}
