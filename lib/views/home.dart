import 'package:flutter/material.dart';
import 'package:journal/database/journal_database_controller.dart';
import 'package:journal/database/journal_database_interactions.dart';
import 'package:journal/views/default_scaffold.dart';
import 'package:journal/views/error/load_journal_error.dart';
import 'package:journal/views/journal/journal.dart';
import 'package:journal/views/journal/new_journal_entry/journal_entry_form.dart';
import 'package:journal/views/loading/loading.dart';

class Home extends StatefulWidget {
  static const route = 'home';
  final title = 'Home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loading = true;
  bool loadJournalError = false;
  List<Map<String, dynamic>> journalEntries;
  JournalDatabaseController journalDatabaseController;
  JournalDatabaseInteractions journalDatabaseInteractions;

  _HomeState() {
    journalDatabaseController = JournalDatabaseController();
    journalDatabaseInteractions = JournalDatabaseInteractions(
        saveJournalEntry: journalDatabaseController.insertJournalEntry);
    initDatabase();
  }

  void initDatabase() async {
    try {
      await journalDatabaseController.init();
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
    } else {
      return Journal(
        journalEntries: journalEntries,
        journalDatabaseInteractions: journalDatabaseInteractions,
        createNewEntry: createNewEntry,
      );
    }
  }

  void createNewEntry(BuildContext context) {
    Navigator.pushNamed(context, JournalEntryForm.route,
        arguments: journalDatabaseInteractions);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      title: widget.title,
      child: shouldDisplayLoadingOrJournal(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => createNewEntry(context),
      ),
    );
  }
}
