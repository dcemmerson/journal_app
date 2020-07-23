import 'package:flutter/material.dart';
import 'package:journal/database/journal_database_interactions.dart';
import 'package:journal/views/journal/new_journal_entry/journal_entry_form.dart';

class DisplayJournal extends StatelessWidget {
  final List<Map<String, dynamic>> journalEntries;
  final JournalDatabaseInteractions journalDatabaseInteractions;

  DisplayJournal(
      {@required this.journalEntries,
      @required this.journalDatabaseInteractions});

  void createNewEntry(BuildContext ctx) {
    Navigator.pushNamed(ctx, JournalEntryForm.route,
        arguments: journalDatabaseInteractions);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListView.builder(
        padding: EdgeInsets.all(12),
        shrinkWrap: true,
        itemCount: journalEntries.length,
        itemBuilder: (_, index) {
          return Column(
              children: [Text(journalEntries[index]['title']), Divider()]);
        },
      ),
    ]);
  }
}
