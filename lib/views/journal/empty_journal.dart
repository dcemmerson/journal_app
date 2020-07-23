import 'package:flutter/material.dart';
import 'package:journal/routes/routes.dart';

class EmptyJournal extends StatelessWidget {
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
              onPressed: () => Routes.createNewEntry(context),
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
