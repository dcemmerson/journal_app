import 'package:flutter/material.dart';
import 'package:journal/database/journal_database_interactions.dart';
import 'package:journal/views/journal/display_journal/display_journal.dart';
import 'package:journal/views/journal/empty_journal.dart';
import 'package:journal/views/journal_entries.dart';

class Journal extends StatelessWidget {
  final List<Map<String, dynamic>> journalEntries;
  final JournalDatabaseInteractions journalDatabaseInteractions;
  final Function(BuildContext) createNewEntry;

  Journal({
    @required this.journalEntries,
    @required this.journalDatabaseInteractions,
    @required this.createNewEntry,
  });

  Widget displayAnyJournalEntries(BuildContext context) {
    if (journalEntries.length == 0) {
      return EmptyJournal(
        journalDatabaseInteractions: journalDatabaseInteractions,
        createNewEntry: createNewEntry,
      );
    } else {
      return DisplayJournal(
          journalEntries: journalEntries,
          journalDatabaseInteractions: journalDatabaseInteractions);
    }
  }

  @override
  Widget build(BuildContext context) {
    return displayAnyJournalEntries(context);
  }
}
