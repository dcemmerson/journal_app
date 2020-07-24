import 'package:flutter/material.dart';
import 'package:journal/views/journal.dart';
import 'package:journal/views/journal/new_journal_entry/journal_entry_form.dart';
import 'package:journal/views/journal_entries.dart';

class Routes {
  static final routes = {
    Journal.route: (context) => Journal(),
    JournalEntries.route: (context) => JournalEntries(),
    JournalEntryForm.route: (context) => JournalEntryForm(),
  };

  static Future createNewEntry(BuildContext context) {
    return Navigator.pushNamed(context, JournalEntryForm.route);
  }
}
