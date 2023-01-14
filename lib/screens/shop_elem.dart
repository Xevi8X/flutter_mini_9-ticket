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

class ShopElem extends StatefulWidget {

  final CloudTicket cloudTicket;
  Function superReload;

  ShopElem(this.superReload, {Key? key,required this.cloudTicket}) : super(key: key);

  @override
  _ShopElemState createState() => _ShopElemState();
}

class _ShopElemState extends State<ShopElem> {
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
                      backgroundColor: Theme.of(context).primaryColor
                  ),
                  icon: const Icon(Icons.shopping_cart),
                  label: Text(
                      widget.cloudTicket.isBought ? "Bought": 'Buy', style: TextStyle(color: Colors.white,  fontSize: 22)),
                  onPressed: widget.cloudTicket.isBought ? null : () => {buy(context, widget.cloudTicket)},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buy(BuildContext context, CloudTicket cloudTicket) async {
    CloudService().addTicket(AuthService().currentUser()!.uid, cloudTicket);
    widget.superReload();
  }
}