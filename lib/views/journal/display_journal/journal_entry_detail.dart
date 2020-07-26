import 'package:flutter/material.dart';
import 'package:journal/database/journal_database_transfer.dart';
import 'package:journal/misc/helper.dart';
import 'package:journal/views/screens/journal_entry_form.dart';

class JournalEntryDetail extends StatelessWidget {
  static const defaultPadding = 5.0;

  final titleStyle = TextStyle(fontSize: 30);
  final ratingStyle = TextStyle(fontSize: 15);

  final JournalDatabaseTransfer journalEntry;

  JournalEntryDetail({this.journalEntry});

  @override
  Widget build(BuildContext context) {
    double maxTitleWidth = MediaQuery.of(context).size.width * 0.8;

    return SingleChildScrollView(
        child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          width: maxTitleWidth,
          padding: EdgeInsets.all(defaultPadding),
          child: Text(journalEntry.title, style: titleStyle),
        ),
        Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: Text(
              Helper.ratingToString(journalEntry.rating) +
                  ' / ' +
                  JournalEntryForm.maxRating.toString(),
              style: ratingStyle),
        )
      ]),
      Row(children: [
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 5),
            child: Text(
              Helper.toHumanDate(journalEntry.date),
              style: TextStyle(
                  fontSize: 12, color: Theme.of(context).primaryColorLight),
            )),
      ]),
      Divider(),
      Row(
        children: [
          Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: Text(journalEntry.body))
        ],
      )
    ]));
  }
}
