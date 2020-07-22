import 'package:flutter/material.dart';
import 'package:journal/database/database_controller.dart';
import 'package:journal/views/default_scaffold.dart';

import 'journal_entries.dart';

class Home extends StatefulWidget {
  static const route = 'home';
  final title = 'Home';
  final DatabaseController databaseController = DatabaseController();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loading = true;

  _HomeState() {
    widget.databaseController.readInJsonDbQueries();
  }

  void initState() {}

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
        title: widget.title,
        child: Container(
            child: Center(
                child: RaisedButton(
          child: Icon(Icons.portrait),
          onPressed: () {
            Navigator.pushNamed(context, JournalEntries.route);
          },
        ))));
  }
}
