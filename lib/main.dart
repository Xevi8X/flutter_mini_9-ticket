import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_mini/wrapper.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'auth/auth.dart';


final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final AuthService _authService;

  MyApp({super.key}) : _authService = AuthService()
  {
    _authService.signOutIfAnonymous();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: _authService.user,
      initialData: null,
      child: MaterialApp(
        title: '9-Euro-Ticket',
        theme: ThemeData(
          primaryColor: Colors.lightGreen,
          //backgroundColor: Colors.deepPurpleAccent
        ),
        home: const Wrapper(),
        navigatorKey: navigatorKey,
      ),
    );
  }
}

