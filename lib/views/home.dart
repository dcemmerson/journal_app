import 'package:flutter/material.dart';
import 'package:journal/views/default_scaffold.dart';

import 'journal_entries.dart';

class Home extends StatelessWidget {
  static const route = 'home';
  final title = 'Home';

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
        title: this.title,
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
