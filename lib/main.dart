import 'package:flutter/material.dart';

void main() {
  runApp(MainWidget());
}

class MainWidget extends StatelessWidget {
  MainWidget({super.key});

  MaterialColor primaryColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nine Euro Ticket',
      theme: ThemeData(
        primarySwatch: primaryColor,
      ),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => MyScaffold(Center(child: Text("/"))),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/login': (context) => MyScaffold(Center(child: Text("/login"))),
        '/register': (context) => MyScaffold(Center(child: Text("/register"))),
        '/buy': (context) => MyScaffold(Center(child: Text("/buy"))),
        '/inspect': (context) => MyScaffold(Center(child: Text("/inspect"))),
        '/settings': (context) => MyScaffold(Center(child: Text("/settings"))),
      },
    );
  }
}

class MyScaffold extends StatelessWidget {
  MyScaffold(
    this.content, {
    Key? key,
  }) : super(key: key);

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Nine Euro Ticket"),
        ),
        endDrawer: Drawer(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Text('Drawer Header'),
                    ),
                    ListTile(
                      title: const Text('Sign in'),
                      onTap: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        Navigator.of(context).pushNamed('/login');
                      },
                    ),
                    ListTile(
                      title: const Text('Sign up'),
                      onTap: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        Navigator.of(context).pushNamed('/register');
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Text('Settings'),
                onTap: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.of(context).pushNamed('/settings');
                },
              ),
              ListTile(
                title: const Text('Log out'),
                onTap: () {

                },
              ),
            ],
          ),
        ),
        body: content);
  }
}
