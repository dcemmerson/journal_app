import 'package:flutter/material.dart';

import 'journal.dart';

class JournalEntries extends StatelessWidget {
  static const route = 'journal_entries';
  final title = 'Journal Entries';

  final List<Map<String, dynamic>> journalEntries;

  JournalEntries({this.journalEntries});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: RaisedButton(
                onPressed: () => Navigator.pushNamed(context, Journal.route),
                child: Text('journal screen'))));
  }
}
