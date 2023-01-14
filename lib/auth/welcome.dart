import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_mini/auth/AuthScaffold.dart';
import 'package:flutter_firebase_mini/auth/auth.dart';
import 'package:flutter_firebase_mini/auth/login.dart';
import 'package:flutter_firebase_mini/auth/register.dart';

import '../common.dart';

class WelcomeBody extends StatefulWidget {
  WelcomeBody({Key? key}) : super(key: key);

  @override
  State<WelcomeBody> createState() => _WelcomeBodyState();
}

class _WelcomeBodyState extends State<WelcomeBody> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  String email = "";

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading ? Common.getLoading(context,Theme.of(context).primaryColor) :
    Container(
      padding: EdgeInsets.all(20),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Welcome in 9-Euro-Ticket holder!",style: Theme.of(context).textTheme.headline5!.copyWith(color: Colors.white),),
              Spacer(),
              Text("Insert your email to begin!",style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white)),
              Padding(
                padding: const EdgeInsets.only(top: 8,bottom: 8),
                child: TextFormField(
                  decoration: Common.myTextFieldDecoration("email").copyWith(errorStyle: TextStyle(color: Colors.white)),
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                  validator: (value) => EmailValidator.validate(value ?? "")
                      ? null
                      : "Please enter a valid email",

                  onFieldSubmitted: goFurther,
                ),
              ),
              ElevatedButton(
                  //style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.yellow)),
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Theme.of(context).primaryColor)),
                  onPressed: () async => goFurther(email),
                  child: const Icon(Icons.arrow_forward,color: Colors.black,)),
              Spacer(),
              ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.grey)),
                  onPressed: () async {
                    logAnonymous();
                  },
                  child: const Text("Sign anonymously")),
            ],
          ),
        ),
      ),
    );
  }

  void goFurther(String? email) async {
    setState(() {
      loading = true;
    });
    if (_formKey.currentState!.validate()) {
      bool isEmailExist = await _authService.checkIfEmailExist(email!);
      if (isEmailExist) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AuthScaffold(
                  child: Login(email: email!),
                  appBarText: "Log in",
                )));
      } else {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                AuthScaffold(
                    child: Register(email: email!), appBarText: "Register")));
      }
    }
    setState(() {
      loading = false;
    });
  }

  void logAnonymous() async {
    User? user = await _authService.signInAnonymously();
    if (user == null) {
      Common.myShowAlert(context, "Anonymous sign is not supported!");
      return;
    }
  }
}
