import 'package:flutter/material.dart';

class EmptyJournal extends StatelessWidget {
  final Function goToJournalEntryScreen;
  EmptyJournal({@required this.goToJournalEntryScreen});

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
              onPressed: goToJournalEntryScreen,
              child: Icon(Icons.border_color))
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
