import 'package:flutter/material.dart';
import 'package:journal/blocs/journal_bloc.dart';
import 'package:journal/blocs/journal_state.dart';
import 'package:journal/database/journal_database_transfer.dart';
import 'package:journal/misc/helper.dart';
import 'package:journal/routes/routes.dart';
import 'package:journal/views/screens/journal_entry_form.dart';

// typedef TapCallback = void Function(int index);

class JournalListView extends StatelessWidget {
  final List<JournalDatabaseTransfer> journalEntries;
  final bool isMasterDetailView;
  BuildContext context;

  JournalListView(
      {@required this.journalEntries, this.isMasterDetailView: false});

  void _handleTappedEntry(BuildContext context, int index) {
    JournalStateContainer.of(context).selectedIndex = index;

    if (!isMasterDetailView) {
      goToDetailViewPage(context, journalEntries[index]);
    }
  }

  void goToDetailViewPage(BuildContext context, JournalDatabaseTransfer jdt) {
    // setSelectedJournalIndex(index);
    Routes.journalDetailView(context, journalEntry: jdt);
  }

  Future<JournalDatabaseTransfer> goToJournalUpdateScreen(
      JournalDatabaseTransfer jdt) async {
    JournalDatabaseTransfer journalEntry =
        await Routes.updateEntry(context, jdt);

    return journalEntry;
  }

  Future<bool> handleDismissedItem(
      DismissDirection direction, JournalDatabaseTransfer jdt) async {
    try {
      //Remove from widget tree otherwise ListView will throw error.
      // List<JournalDatabaseTransfer> updatedJournal = List.from(journalEntries);
      // updatedJournal
      //     .removeWhere((entry) => (entry.id == jdt.id) ? true : false);

      //Now decide if we are deleting or updating.
      if (direction == DismissDirection.startToEnd) {
        JournalStateContainer.of(context)
            .blocProvider
            .journalBloc
            .deleteJournalEntrySink
            .add(DeleteJournalEntryEvent(jdt.id));
      } else {
        //JournalDatabaseTransfer updatedEntry =
        //Remove from widget tree otherwise ListView will throw error.

//        journalEntries = updatedJournal;
//        setState(() => journalEntries = updatedJournal);

        goToJournalUpdateScreen(jdt);
      }
    } catch (err) {
      print(err);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
        child: ListView.separated(
          padding: EdgeInsets.all(2),
          shrinkWrap: true,
          itemCount: journalEntries.length,
          separatorBuilder: (_, __) => Divider(),
          itemBuilder: (_, index) {
            return Dismissible(
                //               key: UniqueKey(),
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
                confirmDismiss: (direction) =>
                    handleDismissedItem(direction, journalEntries[index]),
//                onDismissed: (direction) =>
                //                   handleDismissedItem(direction, journalEntries[index]),
                child: ListTile(
                  leading: Icon(Icons.arrow_forward_ios),
                  trailing: Text(
                      Helper.ratingToString(journalEntries[index].rating) +
                          ' / ' +
                          JournalEntryForm.maxRating.toString()),
                  title: Text(journalEntries[index].title),
                  subtitle:
                      Text(Helper.toHumanDate(journalEntries[index].date)),
                  onTap: () {
                    _handleTappedEntry(context, index);
                  },
                ));
          },
        ));
  }
}
