import 'package:flutter/material.dart';
import 'package:flutter_firebase_mini/cloud/cloud_client.dart';
import 'package:flutter_firebase_mini/cloud/cloud_user.dart';
import 'package:flutter_firebase_mini/screens/setting.dart';
import 'package:flutter_firebase_mini/screens/shop.dart';
import 'package:flutter_firebase_mini/screens/support.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/auth.dart';
import '../common.dart';
import 'license.dart';

class HomeScaffold extends StatefulWidget {
  Color backgroundColor = Colors.lightGreen;
  CloudUser? user;
  HomeScaffold(
    this.body, this.isFAB, {
    Key? key,
    this.user,
        required this.backgroundColor,
  }) : super(key: key);

  final Widget body;
  final bool isFAB;

  @override
  State<HomeScaffold> createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  AuthService _authService = AuthService();

  Future<void>? _initUser;

  @override
  void initState() {
    super.initState();
    _initUser = _init();
  }


  Future<void> rebuild() async {
    final prefs = await SharedPreferences.getInstance();
    int? newColor = await prefs.getInt("color");
    if(newColor != null) widget.backgroundColor = Color(newColor);
    widget.user = await CloudService().readUser(
        _authService.currentUser()!.isAnonymous
            ? "1"
            : _authService.currentUser()!.uid);
    setState(() {});
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    int? newColor = await prefs.getInt("color");
    if(newColor != null) widget.backgroundColor = Color(newColor);
    widget.user = await CloudService().readUser(
        _authService.currentUser()!.isAnonymous
            ? "1"
            : _authService.currentUser()!.uid);
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<void>(
        future: _initUser,
        builder: (context, snapshot) {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: widget.backgroundColor,
                  centerTitle: true,
                  title:
                      Text("9€", style: Theme.of(context).textTheme.headline3),
                ),
                endDrawer: Drawer(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: SafeArea(
                          child: ListView(
                            children: [
                              SizedBox(
                                height: 64,
                                child: DrawerHeader(

                                  decoration: BoxDecoration(
                                    color: widget.backgroundColor,
                                  ),
                                  child: Column(
                                    children: [
                                      FractionallySizedBox(
                                        widthFactor: 0.8,
                                        child: Center(
                                          child: Text(widget.user == null
                                              ? ""
                                              : (widget.user!.name ?? "") +
                                                  " " +
                                                  (widget.user!.surname ?? ""),
                                          style:TextStyle(fontSize: 22)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.picture_as_pdf_outlined),
                        title: const Text('License'),
                        onTap: () {

                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScaffold(LicenseWebView(),false,user: widget.user,backgroundColor: widget.backgroundColor),));
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.contact_support),
                        title: const Text('Support'),
                        onTap: () {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScaffold(SupportScreen(cloudUser: widget.user!,backgroundColor: widget.backgroundColor),false,user: widget.user,backgroundColor: widget.backgroundColor),));
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text('Settings'),
                        onTap: () {
                          if(_authService.currentUser()!.isAnonymous)
                            {
                              Common.myShowAlert(context, "Setting are aviable only for logged users!");
                              return;
                            }
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScaffold(SettingScreen(cloudUser: widget.user!,rebuild,widget.backgroundColor),false,user: widget.user,backgroundColor: widget.backgroundColor),));
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text('Log out'),
                        onTap: () {
                          _authService.signOut();
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                      ),
                    ],
                  ),
                ),
                body: ((snapshot.connectionState == ConnectionState.done)) ?
                (isAcountComplete() ? widget.body : UpdateName(rebuild,widget.backgroundColor)) :
                  Center(child: CircularProgressIndicator(color: widget.backgroundColor,)),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: (widget.isFAB && isAcountComplete()) ? Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: FloatingActionButton.extended(
                    backgroundColor: widget.backgroundColor,
                      onPressed: () {
                        if(_authService.currentUser()!.isAnonymous)
                        {
                            Common.myShowAlert(context, "Shop are aviable only for logged users!");
                            return;
                        }
                        var shop = ShopList(cloudUser: widget.user!,rebuild,widget.backgroundColor);
                        var home = HomeScaffold(shop,false,user: widget.user,backgroundColor: widget.backgroundColor,);
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => home))
                            .then((value) => setState(() {
                            }));
                      },
                      label: Icon(
                        Icons.shopping_cart,
                        size: 40,
                      )),
                ) : null,
            );
        });
  }

  bool isAcountComplete() {
    return widget.user != null &&
        widget.user!.surname != null &&
        widget.user!.name != null;
  }
}

class UpdateName extends StatefulWidget {
  Color backgroundColor;
  void Function() rebuild;
  UpdateName(this.rebuild,this.backgroundColor, {Key? key}) : super(key: key);

  @override
  _UpdateNameState createState() => _UpdateNameState();
}

class _UpdateNameState extends State<UpdateName> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String name = "";
  String surname = "";

  @override
  Widget build(BuildContext context) {
    return loading
        ? Common.getLoading(context,widget.backgroundColor)
        : Center(
            child: Container(

              padding: EdgeInsets.all(20),
              child: SafeArea(
                child: Form(
                  key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Set name and surname",style: Theme.of(context).textTheme.headline6),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: TextFormField(
                              decoration: Common.myTextFieldDecoration("name"),
                              onChanged: (val) {
                                setState(() => name = val);
                              },
                              validator: (value) =>
                                  (value ?? "").length < 1 ? "Name to short!" : null),
                        ),
                        Padding(
                          padding: const EdgeInsets.only( bottom: 8.0),
                          child: TextFormField(
                              onFieldSubmitted: goFurther,
                              decoration: Common.myTextFieldDecoration("Surname"),
                              onChanged: (val) {
                                setState(() => surname = val);
                              },
                              validator: (value) => (value ?? "").length < 1
                                  ? "Surname to short!"
                                  : null),
                        ),
                        ElevatedButton(
                            style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(widget.backgroundColor)),
                            onPressed: () async => goFurther(surname),
                            child: const Icon(Icons.arrow_forward)),
                      ],
                    ),
                ),
              ),
            ),
          );
  }

  void goFurther(String? surname) async {
    setState(() {
      loading = true;
    });
    if (_formKey.currentState!.validate()) {
      await CloudService().updateUser(CloudUser(
          AuthService().currentUser()!.uid,
          name: name!,
          surname: surname!));
      widget.rebuild();
    }
    setState(() {
      loading = false;
    });
  }
}
