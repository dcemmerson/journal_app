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
    JournalDatabaseTransfer journalEntry = await Routes.updateEntry(context,
        journalEntry: jdt, entrySort: jdt.sort);

    return journalEntry;
  }

  Future<bool> handleDismissedItem(
      DismissDirection direction, JournalDatabaseTransfer jdt) async {
    try {
      //Now decide if we are deleting or updating.
      if (direction == DismissDirection.startToEnd) {
        // User chose to delete entry. Add delete event to sink.
        JournalStateContainer.of(context)
            .blocProvider
            .journalBloc
            .deleteJournalEntrySink
            .add(DeleteJournalEntryEvent(jdt.id));
      } else {
        // User chose to update entry
        goToJournalUpdateScreen(jdt);
      }
    } catch (err) {
      print(err);
    }
    return false;
  }

/*
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
*/

  void reorderJournal(BuildContext context, int oldIndex, newIndex) {
    List<JournalDatabaseTransfer> entries = List.from(journalEntries);

    if (oldIndex < newIndex) {
      swapAndReorderEntries(entries, oldIndex, newIndex - 1);
    } else {
      // Just swap the indices
      swapAndReorderEntries(entries, oldIndex, newIndex);
    }
    JournalStateContainer.of(context)
        .blocProvider
        .journalBloc
        .reorderJournalEntriesSink
        .add(ReorderJournalEntriesEvent(entries));
  }

  void swapAndReorderEntries(
      List<JournalDatabaseTransfer> entries, int removeAt, int insertAt) {
    JournalDatabaseTransfer removedEntry = entries.removeAt(removeAt);
    entries.insert(insertAt, removedEntry);
    for (int i = 0; i < entries.length; i++) {
      entries[i].sort = i;
    }
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
        child: ReorderableListView(
            padding: EdgeInsets.all(2),
            onReorder: (int oldIndex, int newIndex) {
              reorderJournal(context, oldIndex, newIndex);
            },
            children: List.generate(
              journalEntries.length,
              (int index) => Dismissible(
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
                  )),
            )));
  }
}
