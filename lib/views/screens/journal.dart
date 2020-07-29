import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:journal/blocs/journal_bloc.dart';
import 'package:journal/blocs/journal_state.dart';
import 'package:journal/database/journal_database_transfer.dart';
import 'package:journal/routes/routes.dart';
import 'package:journal/views/default_scaffold.dart';
import 'package:journal/views/widgets/empty_journal.dart';

import 'package:journal/views/widgets/journal_entry_detail_view.dart';
import 'package:journal/views/widgets/journal_list_view.dart';

class Journal extends StatefulWidget {
  static const route = 'home';
  final title = 'Home';

  @override
  _JournalState createState() => _JournalState();
}

class _JournalState extends State<Journal> {
  JournalBloc _bloc;
  // bool loading = true;
  // bool loadJournalError = false;
  // int selectedJournalIndex = 0;
  // List<JournalDatabaseTransfer> journalEntries;
//  JournalDatabaseController journalDatabaseController;
  int _selectedIndex = 0;

  void didChangeDependencies() {
    print('depencencies changed');
    super.didChangeDependencies();
    _bloc = JournalStateContainer.of(context).blocProvider.journalBloc;
    _selectedIndex = JournalStateContainer.of(context).selectedIndex;
  }
  // JournalDatabaseInteractions journalDatabaseInteractions;

  // _JournalState() {
  //   initDatabase();
  // }

  // void initDatabase() async {
  //   try {
  //     await JournalDatabaseController.init();
  //     journalDatabaseController = JournalDatabaseController.getInstance();
  //     journalEntries = await journalDatabaseController.getAllJournalEntries();
  //   } catch (err) {
  //     print(err);
  //     setState(() => loadJournalError = true);
  //   } finally {
  //     setState(() {
  //       loading = false;
  //     });
  //   }
  // }

  // void setSelectedJournalIndex(int index) {
  //   setState(() => selectedJournalIndex = index);
  // }

  // Future handleDeleteJournalEntry(int journalEntryId) async {
  //   try {
  //     JournalDatabaseController jdc = JournalDatabaseController.getInstance();
  //     await jdc.deleteJournalEntry(journalEntryId);
  //     List<JournalDatabaseTransfer> updatedJournalEntries =
  //         await journalDatabaseController.getAllJournalEntries();
  //     setState(() => journalEntries = updatedJournalEntries);
  //   } catch (err) {
  //     print(err);
  //   }
  // }

  Future<JournalDatabaseTransfer> goToJournalEntryScreen() async {
    JournalDatabaseTransfer journalEntry = await Routes.createNewEntry(context);

    return journalEntry;
  }

  void goToDetailView(BuildContext context, JournalDatabaseTransfer jdt) {
    // setSelectedJournalIndex(index);
    Routes.journalDetailView(context, journalEntry: jdt);
  }

  Widget masterDetailView(List<JournalDatabaseTransfer> entries) {
    return GridView.count(
        crossAxisCount: 2,
        physics: NeverScrollableScrollPhysics(),
        children: [
          JournalListView(journalEntries: entries, isMasterDetailView: true),
          (_selectedIndex < entries.length)
              ? JournalEntryDetailView(
                  journalEntry: entries[_selectedIndex], sizeFactor: 1 / 2)
              : Column(),
        ]);
  }

  Widget listViewStreamBuilder() {
    return StreamBuilder(
        stream: _bloc.journalEntries,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth > 500 && snapshot.data.length > 0) {
                return masterDetailView(snapshot.data);
              } else if (snapshot.data.length > 0) {
                return JournalListView(
                  journalEntries: snapshot.data,
                  // onTapCallback: (int index) =>
                  //     goToDetailView(context, snapshot.data[index]),
                );
              } else {
                return EmptyJournal(
                    goToJournalEntryScreen: goToJournalEntryScreen);
              }
            });
//            return listView(snapshot.data, onTapCallback);
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      title: widget.title,
      child: listViewStreamBuilder(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: goToJournalEntryScreen,
      ),
    );
  }
}
