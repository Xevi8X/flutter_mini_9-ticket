import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_mini/auth/auth.dart';
import 'package:flutter_firebase_mini/cloud/cloud_client.dart';
import 'package:flutter_firebase_mini/cloud/cloud_ticket.dart';
import 'package:flutter_firebase_mini/cloud/cloud_user.dart';
import 'package:flutter_firebase_mini/screens/HomeScaffold.dart';
import 'package:provider/provider.dart';

import '../common.dart';
import 'inspection.dart';

class ListElem extends StatefulWidget {

  final CloudTicket cloudTicket;
  final Color backgroundColor;

  const ListElem({Key? key,required this.cloudTicket,required this.backgroundColor}) : super(key: key);

  @override
  _ListElemState createState() => _ListElemState();
}

class _ListElemState extends State<ListElem> {
  @override
  Widget build(BuildContext context) {
    String validity = "";
    if(widget.cloudTicket.from != null && widget.cloudTicket.to != null)
    {
      validity =  Common.fromDateTime(widget.cloudTicket.from!) + " - " + Common.fromDateTime(widget.cloudTicket.to!);
    }

    return Card(
      margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: const BorderSide(width: 1, color: Colors.black)
        ),
        color: Colors.white,
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(widget.cloudTicket.name, style: Theme
                  .of(context)
                  .textTheme
                  .headline4),
              subtitle: Text(validity,
                  style: const TextStyle(color: Colors.black)),
            ),
            ButtonBarTheme(
              data: const ButtonBarThemeData(),
              child: ButtonBar(
                children: <Widget>[
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      // Foreground color
                        backgroundColor: widget.backgroundColor,
                    ),
                    icon: const Icon(Icons.qr_code_2),
                    label: const Text(
                        'Inspection', style: TextStyle(color: Colors.white,  fontSize: 22)),
                    onPressed: () => {openInspectionScreen(context, widget.cloudTicket)},
                  ),
                ],
              ),
            ),
          ],
        ),
    );
  }

  openInspectionScreen(BuildContext context, CloudTicket cloudTicket) async {
    final u = AuthService().currentUser();
    var user = await CloudService().readUser(u!.isAnonymous ? "1" :u!.uid);

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScaffold(InspectionScreen(cloudUser: user, cloudTicket: cloudTicket),false,user: user,backgroundColor: widget.backgroundColor,)));
  }

}
