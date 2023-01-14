import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/auth.dart';
import '../cloud/cloud_client.dart';
import '../cloud/cloud_user.dart';
import '../common.dart';

class SettingScreen extends StatefulWidget {
  Color backgroundColor;
  final CloudUser cloudUser;
  late Function reload;
  bool isLoading = false;

  SettingScreen(this.reload,this.backgroundColor, {Key? key,required this.cloudUser}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = "";
  String surname = "";


  @override
  void initState() {
    super.initState();
    name = widget.cloudUser.name!;
    surname = widget.cloudUser.surname!;
  }

  @override
  Widget build(BuildContext context) {
    return widget.isLoading? Center(child: CircularProgressIndicator(),) : Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          child: Text("Setting:",
            style: Theme
                .of(context)
                .textTheme
                .headline3,
          ),
        ),
        Spacer(),
        Form(
          key: _formKey,
          child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("name:",style: Theme.of(context).textTheme.headline6),
                Padding(
                  padding: const EdgeInsets.only(top:8.0,bottom: 8.0),
                  child: TextFormField(
                      initialValue: widget.cloudUser.name!,
                      decoration: Common.myTextFieldDecoration("name"),
                      onChanged: (val) {
                        setState(() => name = val);
                      },
                      validator: (value) =>
                          (value ?? "").length < 1 ? "Name to short!" : null),
                ),
                Text("surname:",style: Theme.of(context).textTheme.headline6),
                Padding(
                  padding: const EdgeInsets.only(top:8.0,bottom: 8.0),
                  child: TextFormField(
                    initialValue: widget.cloudUser.surname!,
                      onFieldSubmitted: goFurther,
                      decoration: Common.myTextFieldDecoration("Surname"),
                      onChanged: (val) {
                        setState(() => surname = val);
                      },
                      validator: (value) =>
                          (value ?? "").length < 1 ? "Surname to short!" : null),
                ),
                ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(widget.backgroundColor)),
                    onPressed: ()
                    {
                      showDialog(
                        context: context,
                        builder: (BuildContext b) => AlertDialog(
                          title: const Text('Pick a color!'),
                          content: SingleChildScrollView(
                            child: BlockPicker(
                              pickerColor: widget.backgroundColor,
                              onColorChanged: changeColor,
                            ),
                            // Use Material color picker:
                            //
                            // child: MaterialPicker(
                            //   pickerColor: pickerColor,
                            //   onColorChanged: changeColor,
                            //   showLabel: true, // only on portrait mode
                            // ),
                            //
                            // Use Block color picker:
                            //
                            // child: BlockPicker(
                            //   pickerColor: currentColor,
                            //   onColorChanged: changeColor,
                            // ),
                            //
                            // child: MultipleChoiceBlockPicker(
                            //   pickerColors: currentColors,
                            //   onColorsChanged: changeColors,
                            // ),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text('Got it'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text("Change theme color",style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white),),
                ),
                ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(widget.backgroundColor)),
                    onPressed: () async => goFurther(surname),
                    child: const Icon(Icons.arrow_forward)),
              ],
            ),

        ),
        Spacer(),
      ]),
    );
  }

  void goFurther(String? surname) async {
    if (_formKey.currentState!.validate()) {
      setState(() {widget.isLoading = true;});
      await CloudService().updateUser(CloudUser(
          AuthService().currentUser()!.uid,
          name: name!,
          surname: surname!));
      setState(() {widget.isLoading = false;});
      Navigator.of(context)
          .popUntil((route) => route.isFirst);
      Navigator.of(context).pop();
    }
  }

  Future<void> changeColor(Color color) async {
    setState(() {widget.isLoading = true;});
    widget.backgroundColor = color;
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("color", color.value);
    await widget.reload();
    setState(() {widget.isLoading = false;});
  }
}
