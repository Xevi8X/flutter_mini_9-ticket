import 'package:cloud_firestore/cloud_firestore.dart';

class CloudUser
{
  String uid;
  String? name;
  String? surname;

  CloudUser(this.uid ,{this.name,this.surname});

  Map<String,dynamic> toJson()
  {
    Map<String,dynamic> json = {};
    json['id'] = uid;
    if(name != null) json['name'] = name!;
    if(surname != null) json['surname'] = surname!;
    return json;
  }

  static CloudUser FromSnapshot(Map<String,dynamic> json) {
    CloudUser user = CloudUser(json["id"]);
    if(json.containsKey("name")) user.name = json["name"];
    if(json.containsKey("surname")) user.surname = json["surname"];
    return user;
  }
}