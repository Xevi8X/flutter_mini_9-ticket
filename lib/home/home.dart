import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_mini/cloud/cloud_client.dart';
import 'package:flutter_firebase_mini/cloud/cloud_user.dart';
import 'package:flutter_firebase_mini/home/ticket_list.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common.dart';
import 'HomeScaffold.dart';

class HomeScreen extends StatefulWidget {

  HomeScreen({Key? key}) : super(key: key);
  late CloudUser user;
  Color backgroundColor = Colors.lightGreen;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CloudService _cloudService = CloudService();

  @override
  Widget build(BuildContext context) {
    //init();
    final u = Provider.of<User?>(context);
    Future<CloudUser> user =
        _cloudService.readUser(u!.isAnonymous ? "1" :u.uid);

    return FutureBuilder(
        future: user,
        builder: (BuildContext context, AsyncSnapshot<CloudUser> snapshot) {
          if (snapshot.hasData && snapshot.connectionState ==ConnectionState.done)
          {
            var ticketList  = TicketList(backgroundColor: Colors.lightBlueAccent,);
            return Provider<CloudUser?>.value(
              value: snapshot.data,
              child: HomeScaffold(
                ticketList,
                true,
                user: snapshot.data,
                backgroundColor: widget.backgroundColor,
              ),
            );
          }
          else
          {
            return HomeScaffold(Common.getLoading(context,Theme.of(context).primaryColor),false,backgroundColor: Colors.lightGreen,);
          }
        });
  }

  Future<void> init()
  async {
    final prefs = await SharedPreferences.getInstance();
    int? newColor = prefs.getInt("color");
    if(newColor != null) widget.backgroundColor = Color(newColor);
  }
}
