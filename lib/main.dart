import 'package:flutter/material.dart';

import 'routes/home.dart';
import 'routes/journal_entries.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final routes = {
    Home.route: (context) => Home(),
    JournalEntries.route: (context) => JournalEntries(),
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
//      home: MyHomePage(title: 'Flutter Demo Home Page'),
      routes: routes,
      initialRoute: Home.route,
    );
  }
}
