import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:journal/database/journal_database_controller.dart';
import 'package:journal/database/journal_database_transfer.dart';
import 'package:journal/misc/helper.dart';
import 'package:journal/routes/routes.dart';
import 'package:journal/views/default_scaffold.dart';
import 'package:journal/views/error/load_journal_error.dart';
import 'package:journal/views/journal/display_journal/journal_entry_detail.dart';
import 'package:journal/views/journal/empty_journal.dart';
import 'package:journal/views/loading/loading.dart';

import 'journal_entry_form.dart';

class Journal extends StatefulWidget {
  static const route = 'home';
  final title = 'Home';

  @override
  _JournalState createState() => _JournalState();
}

class _JournalState extends State<Journal> {
  bool loading = true;
  bool loadJournalError = false;
  int selectedJournalIndex = 0;
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

  void setSelectedJournalIndex(int index) {
    setState(() => selectedJournalIndex = index);
  }

  Widget shouldDisplayLoadingOrJournal() {
    if (loading) {
      return Loading();
    } else if (loadJournalError) {
      return LoadJournalError();
    } else if (journalEntries.length == 0) {
      return EmptyJournal(createNewEntry: goToJournalEntryScreen);
    } else {
      return chooseIfMasterDetailView();
    }
  }

  Future handleDeleteJournalEntry(int journalEntryId) async {
    try {
      JournalDatabaseController jdc = JournalDatabaseController.getInstance();
      await jdc.deleteJournalEntry(journalEntryId);
      List<Map> updatedJournalEntries =
          await journalDatabaseController.getAllJournalEntries();
      setState(() => journalEntries = updatedJournalEntries);
    } catch (err) {
      print(err);
    }
  }

  void goToJournalEntryScreen() async {
    List<Map<String, dynamic>> updatedJournalEntries =
        await Routes.createNewEntry(context);

    if (updatedJournalEntries != null) {
      setState(() => journalEntries = updatedJournalEntries);
    }
  }

  void goToDetailView(BuildContext context, int index) {
    setSelectedJournalIndex(index);
    JournalDatabaseTransfer journalEntry =
        JournalDatabaseTransfer.fromMap(journalEntries[index]);
    Routes.journalDetailView(context, journalEntry: journalEntry);
  }

  Widget chooseIfMasterDetailView() {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 500) {
        return masterDetailView();
      } else {
        return listView((index) => goToDetailView(context, index));
      }
    });
  }

  Widget masterDetailView() {
    return GridView.count(
        crossAxisCount: 2,
        children: [listView(setSelectedJournalIndex), detailView()]);
  }

  Widget detailView() {
    return Column(children: [
      JournalEntryDetail(
          journalEntry: JournalDatabaseTransfer.fromMap(
              journalEntries[selectedJournalIndex]))
    ]);
  }

  void handleDismissedItem(int journalEntryId) async {
    List<Map<String, dynamic>> updatedJournal = List.from(journalEntries);

    print('before');
    print(updatedJournal);
    updatedJournal
        .removeWhere((entry) => (entry['id'] == journalEntryId) ? true : false);
    print('after');

    print(updatedJournal);
    setState(() => journalEntries = updatedJournal);
    await journalDatabaseController.deleteJournalEntry(journalEntryId);
  }

  Widget listView(Function onTapCallback) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
        child: ListView.separated(
          padding: EdgeInsets.all(2),
          shrinkWrap: true,
          itemCount: journalEntries.length,
          separatorBuilder: (_, __) => Divider(),
          itemBuilder: (_, index) {
            return Dismissible(
                key: ValueKey(journalEntries[index]['id']),
                background: Container(color: Colors.red),
                onDismissed: (direction) =>
                    handleDismissedItem(journalEntries[index]['id']),
                child: ListTile(
                  leading: Icon(Icons.arrow_forward_ios),
                  trailing: Text(journalEntries[index]['rating'].toString() +
                      ' / ' +
                      JournalEntryForm.maxRating.toString()),
                  title: Text(journalEntries[index]['title']),
                  subtitle:
                      Text(Helper.toHumanDate(journalEntries[index]['date'])),
                  onTap: () => onTapCallback(index),
                ));
          },
        ));
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
