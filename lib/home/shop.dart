import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_mini/cloud/cloud_user.dart';
import 'package:flutter_firebase_mini/home/shop_elem.dart';
import 'package:provider/provider.dart';

import '../auth/auth.dart';
import '../cloud/cloud_client.dart';
import '../cloud/cloud_ticket.dart';


class ShopList extends StatefulWidget {
  final _cloudService = CloudService();
  Color backgroundColor;
  final CloudUser cloudUser;
  late Function reload;
  late Function reloadMyself;
  ShopList(this.reload,this.backgroundColor, {Key? key, required this.cloudUser}) : super(key: key);

  @override
  _ShopListState createState() => _ShopListState();
}

class _ShopListState extends State<ShopList> {
  List<CloudTicket> ticketList = List.empty();
  Future<void>? _initTicketData;

  @override
  void initState() {
    super.initState();
    _initTicketData = _initTicket();
  }

  @override
  Widget build(BuildContext context) {
    widget.reloadMyself = reload;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30),
            child: Text("Shop",
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
                            reload();
                          },
                          child: ticketList.isNotEmpty
                              ? ListView.builder(
                            itemCount: ticketList.length,

                            shrinkWrap:true,
                            itemBuilder: (context, index) {
                              return ShopElem(reload,cloudTicket: ticketList[index]);
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

  void reload() async {
    final u = AuthService().currentUser();
    var userTickets = await widget._cloudService.readTickets(u!.uid);
    var newTicketList = await widget._cloudService.readShop();
    newTicketList.sort((a,b) => a.from!.microsecondsSinceEpoch - b.from!.microsecondsSinceEpoch);
    if(userTickets.isNotEmpty) for (var element in newTicketList) {element.isBought = userTickets.any((element2) => element2.name == element.name);}
    setState(() {
      ticketList = newTicketList;
    });
  }

  Future<void> _initTicket() async {

    final u = AuthService().currentUser();
    var userTickets = await widget._cloudService.readTickets(u!.isAnonymous? "1" : u.uid);
    ticketList = await widget._cloudService.readShop();
    ticketList.sort((a,b) => a.from!.microsecondsSinceEpoch - b.from!.microsecondsSinceEpoch);
    if(userTickets.isNotEmpty) for (var element in ticketList) {element.isBought = userTickets.any((element2) => element2.name == element.name);}
  }
}
