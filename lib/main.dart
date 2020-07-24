import 'package:flutter/material.dart';
import 'package:journal/routes/routes.dart';
import 'package:journal/views/screens/journal.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
      routes: Routes.routes,
      initialRoute: Journal.route,
    );
  }
}
