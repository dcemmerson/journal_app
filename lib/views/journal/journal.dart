import 'package:flutter/material.dart';
import 'package:journal/views/journal/empty_journal.dart';
import 'package:journal/views/journal_entries.dart';

class Journal extends StatelessWidget {
  final List<Map<String, dynamic>> journalEntries;

  Journal({@required this.journalEntries});

  Widget displayAnyJournalEntries(BuildContext context) {
    if (journalEntries.length == 0) {
      return EmptyJournal();
    } else {
      return Container(
          child: Center(
              child: RaisedButton(
        child: Icon(Icons.portrait),
        onPressed: () {
          Navigator.pushNamed(context, JournalEntries.route);
        },
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return displayAnyJournalEntries(context);
  }
}
