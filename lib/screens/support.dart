import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_mini/cloud/cloud_user.dart';
import 'package:flutter_firebase_mini/common.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SupportScreen extends StatelessWidget {
  CloudUser cloudUser;
  Color backgroundColor;
  TextEditingController textarea = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  SupportScreen(
      {Key? key, required this.cloudUser, required this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 30),
            child: Text(
              "Contact with support",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0,left: 20,top: 30.0),
                    child: TextField(
                      controller: textarea,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1000),
                      ],
                      keyboardType: TextInputType.multiline,
                      minLines: 3,
                      maxLines: 10,
                      decoration: InputDecoration(
                          hintText: "What's happen?",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Colors.black)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: backgroundColor)
                          )
                      ),

                    ),
                  ),
                  Text("Limit 1000 characters!"),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                        onPressed: () async {
                          if(textarea.text.isEmpty)
                            {
                              Common.myShowAlert(context,"Message can not be empty!");
                              return;
                            }
                          await sendMessage();
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(backgroundColor)),
                        child: Text("Send!",style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white))
                    ),
                  )
                ],
              )
          )
        ],
      ),
    );
  }
  sendMessage() {
    var webhook = 'https://discord.com/api/webhooks/1063888515471003739/1Zfaep_uHQF1aLa7AlkrOVfOjpOLxWw2nQDtTtexgEA19DxtgX-zk72RzyqCdTDlDWIt';
    var msg = """================================
User info:
    uid: ${cloudUser.uid}
    name: ${cloudUser.name}
    surname: ${cloudUser.surname}
Message:
    ${textarea.text}
================================""";
    return http.post(
      Uri.parse(webhook),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'content': msg,
      }),
    );

  }
}
