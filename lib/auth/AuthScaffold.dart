import 'package:flutter/material.dart';

class AuthScaffold extends StatefulWidget {

  final Widget child;
  String? appBarText;

  AuthScaffold({
    Key? key,
    required this.child,
    this.appBarText,
  }) : super(key: key);

  @override
  State<AuthScaffold> createState() => _AuthScaffoldState();
}

class _AuthScaffoldState extends State<AuthScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.lightBlueAccent.shade200,
      body: widget.child,
      appBar: widget.appBarText == null ? null : AppBar(title: Text(widget.appBarText!),backgroundColor: Theme.of(context).primaryColor,)
    );
  }
}
