import 'package:flutter/material.dart';
import 'package:journal/database/journal_database_controller.dart';
import 'package:journal/routes/routes.dart';
import 'package:journal/views/default_scaffold.dart';
import 'package:journal/views/error/load_journal_error.dart';
import 'package:journal/views/journal/display_journal/display_journal.dart';
import 'package:journal/views/journal/empty_journal.dart';
import 'package:journal/views/loading/loading.dart';

class Journal extends StatefulWidget {
  static const route = 'home';
  final title = 'Home';

  @override
  _JournalState createState() => _JournalState();
}

class _JournalState extends State<Journal> {
  bool loading = true;
  bool loadJournalError = false;
  List<Map<String, dynamic>> journalEntries;
  JournalDatabaseController journalDatabaseController;
  // JournalDatabaseInteractions journalDatabaseInteractions;

  _JournalState() {
    initDatabase();
  }

  void initDatabase() async {
    try {
      await JournalDatabaseController.init();
      journalDatabaseController = JournalDatabaseController.getInstance();
      journalEntries = await journalDatabaseController.getAllJournalEntries();
    } catch (err) {
      print(err);
      setState(() => loadJournalError = true);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Widget shouldDisplayLoadingOrJournal() {
    if (loading) {
      return Loading();
    } else if (loadJournalError) {
      return LoadJournalError();
    } else if (journalEntries.length == 0) {
      return EmptyJournal();
    } else {
      return DisplayJournal(
        journalEntries: journalEntries,
      );
    }
  }

  void goToJournalEntryScreen() async {
    List<Map<String, dynamic>> updatedJournalEntries =
        await Routes.createNewEntry(context);

    if (updatedJournalEntries != null) {
      setState(() => journalEntries = updatedJournalEntries);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      title: widget.title,
      child: shouldDisplayLoadingOrJournal(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: goToJournalEntryScreen,
      ),
    );
  }
}
