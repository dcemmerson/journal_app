import 'package:flutter/material.dart';
import 'package:journal/views/default_scaffold.dart';

import 'home.dart';

class JournalEntries extends StatelessWidget {
  static const route = 'journal_entries';
  final title = 'Journal Entries';

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
        title: this.title,
        child: Container(
            child: Center(
                child: RaisedButton(
                    onPressed: () => Navigator.pushNamed(context, Home.route),
                    child: Text('journal screen')))));
  }
}
