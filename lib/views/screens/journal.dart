import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:journal/blocs/journal_bloc.dart';
import 'package:journal/blocs/journal_state.dart';
import 'package:journal/database/journal_database_transfer.dart';
import 'package:journal/routes/routes.dart';
import 'package:journal/views/default_scaffold.dart';

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
          JournalEntryDetailView(
              journalEntry: entries[_selectedIndex], sizeFactor: 1 / 2),
        ]);
  }

  // Widget detailView(JournalDatabaseTransfer jdt) {
  //   return Column(children: [JournalEntryDetail(journalEntry: jdt)]);
  // }

  // void handleDismissedItem(
  //     DismissDirection direction, JournalDatabaseTransfer jdt) async {
  //   try {
  //     List<JournalDatabaseTransfer> updatedJournal = List.from(journalEntries);

  //     //Remove from widget tree otherwise ListView will throw error.
  //     updatedJournal
  //         .removeWhere((entry) => (entry.id == jdt.id) ? true : false);
  //     setState(() => journalEntries = updatedJournal);

  //     //Now decide if we are deleting or updating.
  //     if (direction == DismissDirection.startToEnd) {
  //       await journalDatabaseController.deleteJournalEntry(jdt.id);
  //     } else {
  //       //JournalDatabaseTransfer updatedEntry =
  //       await goToJournalUpdateScreen(jdt);
  //       List<JournalDatabaseTransfer> updatedEntries =
  //           await journalDatabaseController.getAllJournalEntries();

  //       setState(() => journalEntries = updatedEntries);
  //     }
  //   } catch (err) {
  //     print(err);
  //     setState(() => loadJournalError = true);
  //   }
  // }

  // Widget listView(
  //     List<JournalDatabaseTransfer> snapshot, Function onTapCallback) {
  //   return Padding(
  //       padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
  //       child: ListView.separated(
  //         padding: EdgeInsets.all(2),
  //         shrinkWrap: true,
  //         itemCount: snapshot.length,
  //         separatorBuilder: (_, __) => Divider(),
  //         itemBuilder: (_, index) {
  //           return Dismissible(
  //               key: ValueKey(snapshot[index].id),
  //               background: Container(
  //                   alignment: Alignment.centerLeft,
  //                   color: Colors.red,
  //                   child: Padding(
  //                       padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
  //                       child: Icon(Icons.delete_forever))),
  //               secondaryBackground: Container(
  //                   alignment: Alignment.centerRight,
  //                   color: Colors.green,
  //                   child: Padding(
  //                       padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
  //                       child: Icon(Icons.edit))),
  //               // onDismissed: (direction) =>
  //               //     handleDismissedItem(direction, journalEntries[index]),
  //               child: ListTile(
  //                 leading: Icon(Icons.arrow_forward_ios),
  //                 trailing: Text(Helper.ratingToString(snapshot[index].rating) +
  //                     ' / ' +
  //                     JournalEntryForm.maxRating.toString()),
  //                 title: Text(snapshot[index].title),
  //                 subtitle: Text(Helper.toHumanDate(snapshot[index].date)),
  //                 onTap: () => onTapCallback(index),
  //               ));
  //         },
  //       ));
  // }

  Widget listViewStreamBuilder() {
    return StreamBuilder(
        stream: _bloc.journalEntries,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth > 500) {
                return masterDetailView(snapshot.data);
              } else {
                return JournalListView(
                  journalEntries: snapshot.data,
                  // onTapCallback: (int index) =>
                  //     goToDetailView(context, snapshot.data[index]),
                );
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
