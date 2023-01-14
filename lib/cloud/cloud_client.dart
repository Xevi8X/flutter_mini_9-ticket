import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_mini/cloud/cloud_ticket.dart';
import 'package:flutter_firebase_mini/cloud/cloud_user.dart';

class CloudService {

  Future<CloudUser> readUser(String uid) async
  {
    DocumentReference doc = FirebaseFirestore.instance.collection('users').doc(uid);
    var res = await doc.get();
    final data = res.data() as Map<String, dynamic>;
    return CloudUser.FromSnapshot(data);
  }

  Future<void> createUser(CloudUser user) async
  {
    DocumentReference doc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    await doc.set(user.toJson());
  }

  Future<void> updateUser(CloudUser user) async
  {
    DocumentReference doc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    await doc.update(user.toJson());
  }

  Future<List<CloudTicket>> readTickets(String uid) async
  {
    var snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).collection('tickets').get();
    return snapshot.docs.map((e) =>CloudTicket.fromQuery(e)).toList();
  }

  Future<List<CloudTicket>> readShop() async
  {
    var snapshot = await FirebaseFirestore.instance.collection('shop').get();
    return snapshot.docs.map((e) =>CloudTicket.fromQuery(e)).toList();
  }

  Future<void> addTicket(String uid, CloudTicket cloudTicket) async
  {
    DocumentReference doc = FirebaseFirestore.instance.collection('users').doc(uid).collection('tickets').doc(cloudTicket.name);
    await doc.set(cloudTicket.toJson());
  }

  void addTicketSubsriber(String uid, Function func)
  {
    final docRef = FirebaseFirestore.instance.collection('users').doc(uid).collection('tickets');
    docRef.snapshots().listen(
          (event) {
            func();
      },
      onError: (error) => print("Listen failed: $error"),
    );
  }
}

