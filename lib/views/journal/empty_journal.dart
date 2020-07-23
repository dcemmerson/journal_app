import 'package:flutter/material.dart';
import 'package:journal/database/journal_database_interactions.dart';
import 'package:journal/views/journal/new_journal_entry/journal_entry_form.dart';

class EmptyJournal extends StatelessWidget {
  final JournalDatabaseInteractions journalDatabaseInteractions;
  final Function(BuildContext) createNewEntry;
  EmptyJournal(
      {@required this.journalDatabaseInteractions,
      @required this.createNewEntry});

  Widget textRow() {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Your journal is empty.')]));
  }

  Widget buttonRow(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          RaisedButton(
              onPressed: () => createNewEntry(context),
              child: Text('Add your first entry!'))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [textRow(), buttonRow(context)],
    ));
  }
}
