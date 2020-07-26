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
  List<JournalDatabaseTransfer> journalEntries;
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
      List<JournalDatabaseTransfer> updatedJournalEntries =
          await journalDatabaseController.getAllJournalEntries();
      setState(() => journalEntries = updatedJournalEntries);
    } catch (err) {
      print(err);
    }
  }

  Future<JournalDatabaseTransfer> goToJournalEntryScreen() async {
    JournalDatabaseTransfer journalEntry = await Routes.createNewEntry(context);

    return journalEntry;
  }

  Future<JournalDatabaseTransfer> goToJournalUpdateScreen(
      JournalDatabaseTransfer jdt) async {
    JournalDatabaseTransfer journalEntry =
        await Routes.updateEntry(context, jdt);

    return journalEntry;
  }

  void goToDetailView(BuildContext context, int index) {
    setSelectedJournalIndex(index);
    Routes.journalDetailView(context, journalEntry: journalEntries[index]);
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
      JournalEntryDetail(journalEntry: journalEntries[selectedJournalIndex])
    ]);
  }

  void handleDismissedItem(
      DismissDirection direction, JournalDatabaseTransfer jdt) async {
    try {
      List<JournalDatabaseTransfer> updatedJournal = List.from(journalEntries);

      //Remove from widget tree otherwise ListView will throw error.
      updatedJournal
          .removeWhere((entry) => (entry.id == jdt.id) ? true : false);
      setState(() => journalEntries = updatedJournal);

      //Now decide if we are deleting or updating.
      if (direction == DismissDirection.startToEnd) {
        await journalDatabaseController.deleteJournalEntry(jdt.id);
      } else {
        //JournalDatabaseTransfer updatedEntry =
        await goToJournalUpdateScreen(jdt);
        List<JournalDatabaseTransfer> updatedEntries =
            await journalDatabaseController.getAllJournalEntries();

        setState(() => journalEntries = updatedEntries);
      }
    } catch (err) {
      print(err);
      setState(() => loadJournalError = true);
    }
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
                key: ValueKey(journalEntries[index].id),
                background: Container(
                    alignment: Alignment.centerLeft,
                    color: Colors.red,
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Icon(Icons.delete_forever))),
                secondaryBackground: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.green,
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Icon(Icons.edit))),
                onDismissed: (direction) =>
                    handleDismissedItem(direction, journalEntries[index]),
                child: ListTile(
                  leading: Icon(Icons.arrow_forward_ios),
                  trailing: Text(
                      Helper.ratingToString(journalEntries[index].rating) +
                          ' / ' +
                          JournalEntryForm.maxRating.toString()),
                  title: Text(journalEntries[index].title),
                  subtitle:
                      Text(Helper.toHumanDate(journalEntries[index].date)),
                  onTap: () => onTapCallback(index),
                ));
          },
        ));
  }

  void handleFloatingButtonAddEntry() async {
    JournalDatabaseTransfer returnedEntry = await goToJournalEntryScreen();

    if (returnedEntry != null) {
      List<JournalDatabaseTransfer> updatedJournalEntries =
          await journalDatabaseController.getAllJournalEntries();
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
        onPressed: handleFloatingButtonAddEntry,
      ),
    );
  }
}
