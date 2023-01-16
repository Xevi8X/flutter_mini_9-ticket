import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_mini/auth/auth.dart';
import 'package:flutter_firebase_mini/cloud/cloud_ticket.dart';
import 'package:flutter_firebase_mini/home/ListElem.dart';
import 'package:provider/provider.dart';

import '../cloud/cloud_client.dart';

class TicketList extends StatefulWidget {
  final _cloudService = CloudService();
  final Color backgroundColor;
  TicketList({Key? key, required this.backgroundColor}) : super(key: key);

  @override
  _TicketListState createState() => _TicketListState();
}


class _TicketListState extends State<TicketList> {
  List<CloudTicket> ticketList = List.empty();
  Future<void>? _initTicketData;

  @override
  void initState() {
    super.initState();

    _initTicketData = _initTicket();
  }

  @override
  Widget build(BuildContext context) {
    final u = Provider.of<User?>(context);
    widget._cloudService.addTicketSubsriber(u!.uid, () => reload(u));
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30),
            child: Text("Your tickets:",
              style: Theme
                .of(context)
                .textTheme
                .headline3,
            ),
          ),
          Expanded(
            child: FractionallySizedBox(
              widthFactor: 1.0,
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(color: Colors.black),
                ),
                child: FutureBuilder<void>(
                  future: _initTicketData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done ) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          reload(u);
                        },
                        child: ticketList.isNotEmpty
                            ? ListView.builder(
                          itemCount: ticketList.length,

                          shrinkWrap:true,
                          itemBuilder: (context, index) {
                            return ListElem(cloudTicket: ticketList[index],backgroundColor: widget.backgroundColor,);
                          },
                        ):
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("No ticket? Buy the new one!",style: Theme
                                  .of(context)
                                  .textTheme
                                  .headline6, ),
                              const Icon(Icons.south,size: 50,)
                              
                            ],
                          ),
                        )
                      );
                    }
                    return CircularProgressIndicator(color: Theme.of(context).backgroundColor,);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void reload(User? u) async
  {
    var newTicketList = await widget._cloudService.readTickets(u!.isAnonymous? "1" : u.uid);
    newTicketList.sort((a,b) => a.from!.microsecondsSinceEpoch - b.from!.microsecondsSinceEpoch);
    setState(() {
      ticketList = newTicketList;
    });
  }

  Future<void> _initTicket() async {

    final u = AuthService().currentUser();
    ticketList = await widget._cloudService.readTickets(u!.isAnonymous? "1" : u.uid);
    ticketList.sort((a,b) => a.from!.microsecondsSinceEpoch - b.from!.microsecondsSinceEpoch);
  }
}


