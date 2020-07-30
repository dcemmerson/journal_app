import 'package:flutter/material.dart';
import 'package:journal/database/journal_database_transfer.dart';
import 'package:journal/views/screens/journal.dart';
import 'package:journal/views/screens/journal_details.dart';
import 'package:journal/views/screens/journal_entry_form.dart';

class Routes {
  static final routes = {
    Journal.route: (context) => Journal(),
    JournalDetails.route: (conext) => JournalDetails(),
    JournalEntryForm.route: (context) => JournalEntryForm(
        previousJdt:
            (ModalRoute.of(context).settings.arguments as Map)['journalEntry'],
        entrySort:
            (ModalRoute.of(context).settings.arguments as Map)['entrySort']),
  };

  static Future createNewEntry(BuildContext context,
      {@required int entrySort}) {
    print('entry sort ' + entrySort.toString());
    return Navigator.pushNamed(context, JournalEntryForm.route,
        arguments: {'entrySort': entrySort});
  }

  static Future updateEntry(BuildContext context,
      {JournalDatabaseTransfer journalEntry, @required int entrySort}) {
    return Navigator.pushNamed(context, JournalEntryForm.route,
        arguments: {'journalEntry': journalEntry, 'entrySort': entrySort});
  }

  static Future journalDetailView(BuildContext context,
      {@required journalEntry}) {
    return Navigator.pushNamed(context, JournalDetails.route,
        arguments: journalEntry);
  }
}
