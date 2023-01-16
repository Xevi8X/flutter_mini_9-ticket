


import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class CloudTicket
{
  late String name;
  String? id;
  DateTime? from;
  DateTime? to;
  bool isBought = false;

  static CloudTicket fromQuery(QueryDocumentSnapshot<Map<String, dynamic>> q)
  {
    var t = CloudTicket();
    t.name = q.id;
    var json = q.data();
    if(json.containsKey("id")) t.id = json["id"];
    var a = json["from"];
    if(json.containsKey("from"))
    {
      Timestamp from = json["from"];
      t.from = from.toDate();
    }
    if(json.containsKey("to"))
    {
      Timestamp to = json["to"];
      t.to = to.toDate();
    }
    return t;
  }

  @override
  bool operator ==(Object other) {
    return id == (other as CloudTicket).id;
  }

  Map<String, Object?> toJson() {
    Map<String, Object?> json= {};
    json["id"] = getRandomString(15);
    json["from"] = Timestamp.fromDate(from!);
    json["to"] = Timestamp.fromDate(to!);
    return json;
  }


  final Random _rnd = Random();

  String getRandomString(int length)
  {
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(_rnd.nextInt(chars.length))));
  }


}