import 'package:flutter/material.dart';
import 'package:flutter_firebase_mini/cloud/cloud_ticket.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../cloud/cloud_user.dart';
import '../common.dart';


class InspectionScreen extends StatefulWidget {
  final CloudUser cloudUser;
  final CloudTicket cloudTicket;


  const InspectionScreen({Key? key,required this.cloudUser,required this.cloudTicket}) : super(key: key);

  @override
  _InspectionScreenState createState() => _InspectionScreenState();
}

class _InspectionScreenState extends State<InspectionScreen> with SingleTickerProviderStateMixin{


  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1), vsync: this,
    )
      ..repeat(reverse: true);
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(-2, 0.0),
      end: const Offset(2, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    Map<String,String> json=
    {
    "name": widget.cloudUser.name ?? "Unknown",
    "surname" : widget.cloudUser.surname?? "Unknown",
    "hash": widget.cloudTicket.id ?? "Unknown"
    };

    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,

        children:
        [
          Expanded(
            child: FittedBox(
                fit: BoxFit.fill,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: QrImage(data: json.toString(), size: 200,),
                )
            ),
          ),
          const Divider(thickness: 3,),
          Padding(
            padding: const EdgeInsets.only(left: 20),

            child: Container(
                alignment: Alignment.centerLeft,
                child: const Text("Ticket info", style: TextStyle(fontSize: 22),)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35,right: 35, top: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Expanded(
                    flex: 1,
                    child: Text("Ticket name:")
                ),
                Expanded(
                    flex: 1,
                    child: Container(alignment: Alignment.centerRight,

                        child: Text(widget.cloudTicket.name)
                    )
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35,right: 35, top: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Expanded(
                    flex: 1,
                    child: Text("From: ")
                ),
                Expanded(
                    flex: 1,
                    child: Container(alignment: Alignment.centerRight,

                        child: Text(Common.fromDateTime(widget.cloudTicket.from))
                    )
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35,right: 35, top: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Expanded(
                    flex: 1,
                    child: Text("To: ")
                ),
                Expanded(
                    flex: 1,
                    child: Container(alignment: Alignment.centerRight,

                        child: Text(Common.fromDateTime(widget.cloudTicket.to))
                    )
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35,right: 35, top: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Expanded(
                    flex: 1,
                    child: Text("Ticket ID:")
                ),
                Expanded(
                    flex: 1,
                    child: Container(alignment: Alignment.centerRight,

                        child: Text(widget.cloudTicket.id ?? "Unknown")
                    )
                )
              ],
            ),
          ),
          const Divider(thickness: 3,),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Container(
                alignment: Alignment.centerLeft,
                child: const Text("Passanger info", style: TextStyle(fontSize: 22),)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35,right: 35, top: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Expanded(
                    flex: 1,
                    child: Text("Name:")
                ),
                Expanded(
                    flex: 1,
                    child: Container(alignment: Alignment.centerRight,

                        child: Text(widget.cloudUser.name!)
                    )
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35,right: 35, top: 7, bottom: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Expanded(
                    flex: 1,
                    child: Text("Surname:")
                ),
                Expanded(
                    flex: 1,
                    child: Container(alignment: Alignment.centerRight,

                        child: Text(widget.cloudUser.surname!),
                    )
                )
              ],
            ),
          ),
          SizedBox(
            height: 50,
            child: Container(
              child: SlideTransition(
                position: _offsetAnimation,

                child: Icon(Icons.directions_bus_sharp,color: Colors.green,size: 40,),
              ),

            ),
          )
        ]
    );



      //Column(
     // children: [
     //   Padding(
     //     padding: const EdgeInsets.all(15.0),
    //      child: ,
    //    )
    //  ],
   // );
  }
}
