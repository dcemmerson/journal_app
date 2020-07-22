import 'package:flutter/material.dart';

import 'journal_entries.dart';
import 'views/default_scaffold.dart';

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
          child: Text('start a journal entry'),
          onPressed: () {
            Navigator.pushNamed(context, JournalEntries.route);
          },
        ))));
  }
}
