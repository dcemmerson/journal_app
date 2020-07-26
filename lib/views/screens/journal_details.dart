import 'package:flutter/material.dart';
import 'package:journal/database/journal_database_transfer.dart';
import 'package:journal/misc/helper.dart';
import 'package:journal/views/default_scaffold.dart';
import 'package:journal/views/journal/display_journal/journal_entry_detail.dart';

class JournalDetails extends StatelessWidget {
  static const route = 'journalDetails';
  static const title = 'Journal Entry';

  @override
  Widget build(BuildContext context) {
    JournalDatabaseTransfer jdt = ModalRoute.of(context).settings.arguments;

    return DefaultScaffold(
        title: Helper.toHumanDate(jdt.date),
        child: JournalEntryDetail(journalEntry: jdt));
  }
}
