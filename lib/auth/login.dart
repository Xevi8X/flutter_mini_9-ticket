import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../common.dart';
import 'auth.dart';

class Login extends StatefulWidget {

  final String email;

  const Login({Key? key,required this.email}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String password = "";
  final AuthService _authService = AuthService();
  bool loading = false;


  @override
  Widget build(BuildContext context) {
    return loading ? Common.getLoading(context,Theme.of(context).primaryColor): Center(
      child: Container(
        padding: EdgeInsets.all(20),
        child: SafeArea(
          child: Form(
            key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Insert password!",style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        decoration: Common.myTextFieldDecoration("Password"),
                        obscureText: true,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                        validator: (value) =>  (value ?? "").length < 1 ? "Password cant be empty!" : null,
                        onFieldSubmitted: goFurther,
                    ),
                  ),
                  ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Theme.of(context).primaryColor)),
                      onPressed: () async => goFurther(password),
                      child: const Icon(Icons.arrow_forward)),
                ],
              ),
            ),
        ),
      ),
    );
  }

  void goFurther(String? password) async
  {
    setState(() {
      loading = true;
    });
    if(_formKey.currentState!.validate())
    {
      User? userCredential = await _authService.signInEmailPassword(widget.email, password!,context);
      if(userCredential != null) Navigator.of(context).pop();
    }
    setState(() {
      loading = false;
    });
  }
}
