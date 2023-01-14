import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_mini/auth/AuthScaffold.dart';
import 'package:flutter_firebase_mini/auth/welcome.dart';
import 'package:flutter_firebase_mini/screens/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    final user = Provider.of<User?>(context);
    return user == null ? AuthScaffold(child: WelcomeBody()) : HomeScreen();
  }
}
