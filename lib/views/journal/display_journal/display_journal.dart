import 'package:flutter/material.dart';
import 'package:journal/database/journal_database_transfer.dart';
import 'package:journal/misc.dart/day_of_week.dart';
import 'package:journal/misc.dart/month.dart';
import 'package:journal/views/journal/new_journal_entry/journal_entry_form.dart';

class DisplayJournal extends StatelessWidget {
  final List<Map<String, dynamic>> journalEntries;

  DisplayJournal({@required this.journalEntries});

  String toHumanDate(String date) {
    var datetime = DateTime.parse(date);
    return DayOfWeek.short[datetime.weekday - 1] +
        ', ' +
        Month.short[datetime.month - 1] +
        ' ' +
        datetime.day.toString() +
        ', ' +
        datetime.year.toString();
  }

  void showDetailView(JournalDatabaseTransfer journalEntry) {
    print(journalEntry);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(2),
      shrinkWrap: true,
      itemCount: journalEntries.length,
      separatorBuilder: (_, __) => Divider(),
      itemBuilder: (_, index) {
        return ListTile(
          leading: Icon(Icons.arrow_forward_ios),
          trailing: Text(journalEntries[index]['rating'].toString() +
              ' / ' +
              JournalEntryForm.maxRating.toString()),
          title: Text(journalEntries[index]['title']),
          subtitle: Text(toHumanDate(journalEntries[index]['date'])),
          onTap: () => showDetailView(
              JournalDatabaseTransfer.fromMap(journalEntries[index])),
        );
      },
    );
  }
}
