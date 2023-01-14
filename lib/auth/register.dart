import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_mini/cloud/cloud_client.dart';
import 'package:flutter_firebase_mini/cloud/cloud_user.dart';

import '../common.dart';
import 'auth.dart';

class Register extends StatefulWidget {
  final String email;

  Register({Key? key,required this.email}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _formKey = GlobalKey<FormState>();
  String password = "";
  final AuthService _authService = AuthService();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading ? Common.getLoading(context,Theme.of(context).primaryColor) :Center(
      child: Container(
        padding: EdgeInsets.all(20),
        child: SafeArea(
          child: Form(
            key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Set password!",style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white)),
                  Padding(
                    padding: const EdgeInsets.only(top: 8,bottom: 8),
                    child: TextFormField(
                      decoration: Common.myTextFieldDecoration("Password"),
                      obscureText: true,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                      validator: (value) =>  (value ?? "").length < 6 ? "Password to short!" : null
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextFormField(
                       onFieldSubmitted: goFurther,
                        decoration: Common.myTextFieldDecoration("Confirm password"),
                        obscureText: true,
                        validator: (value) =>  (value ?? "") != password ? "Passwords are different!" : null
                    ),
                  ),
                  ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Theme.of(context).primaryColor)),
                      onPressed: () async => goFurther(password),
                      child: const Icon(Icons.arrow_forward,color: Colors.black,)),
                ],
              ),

          ),
        ),
      ),
    );
  }

  void goFurther(String? password) async {
    setState(() {
      loading = true;
    });
    if(_formKey.currentState!.validate())
    {
      UserCredential? userCredential = await _authService.registerEmailPassword(widget.email, password!,context);
      if(userCredential != null)
      {
        if(userCredential.user != null) CloudService().createUser(CloudUser(userCredential.user!.uid));
        Navigator.of(context).pop();
      }
    }
    setState(() {
      loading = false;
    });
  }
}
