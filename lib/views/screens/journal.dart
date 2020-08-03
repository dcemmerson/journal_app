/// filename: journal.dart
/// last modified: 08/03/2020
/// description: Stateful widget that provides rendering for journal based
///   on screen size/orientation. The only state that is kept track of here
///   is which journal entry is selected. State object here also has reference
///   to the number of journal entries count and journal bloc, but count is
///   just used for making rendering decision, and journal bloc gives us access
///   to the database streams and insert/update/delete sinks.
///

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:journal/blocs/journal_bloc.dart';
import 'package:journal/blocs/journal_state.dart';
import 'package:journal/database/journal_database_transfer.dart';
import 'package:journal/routes/routes.dart';
import 'package:journal/views/default_scaffold.dart';
import 'package:journal/views/error/load_journal_error.dart';
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
  int _selectedIndex = 0;
  int _journalEntryCount = 0;

  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = JournalStateContainer.of(context).blocProvider.journalBloc;
    _selectedIndex = JournalStateContainer.of(context).selectedIndex;
  }

  Future<JournalDatabaseTransfer> goToJournalEntryScreen() async {
    JournalDatabaseTransfer journalEntry =
        await Routes.createNewEntry(context, entrySort: _journalEntryCount);

    return journalEntry;
  }

  void goToDetailView(BuildContext context, JournalDatabaseTransfer jdt) {
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
          if (snapshot.hasError) {
            return LoadJournalError();
          } else if (snapshot.hasData) {
            _journalEntryCount = snapshot.data.length;
            return LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth > 500 && snapshot.data.length > 0) {
                return masterDetailView(snapshot.data);
              } else if (snapshot.data.length > 0) {
                return JournalListView(
                  journalEntries: snapshot.data,
                );
              } else {
                return EmptyJournal(
                    goToJournalEntryScreen: goToJournalEntryScreen);
              }
            });
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
