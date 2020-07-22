import 'package:flutter/material.dart';
import 'package:journal/views/journal/journal_entry_form.dart';

class EmptyJournal extends StatelessWidget {
  void createNewEntry(BuildContext context) {
    Navigator.pushNamed(context, JournalEntryForm.route);
  }

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
