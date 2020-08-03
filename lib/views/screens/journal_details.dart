/// filename: journal_details.dart
/// last_modified: 08/03/2020
/// description: Stateless widget that sets up scaffold with title and inserts
///   journal entry to be formatted for view by journal_entry_detail_view.

import 'package:flutter/material.dart';
import 'package:journal/database/journal_database_transfer.dart';
import 'package:journal/misc/helper.dart';
import 'package:journal/views/default_scaffold.dart';
import 'package:journal/views/widgets/journal_entry_detail_view.dart';

class JournalDetails extends StatelessWidget {
  static const route = 'journalDetails';
  static const title = 'Journal Entry';

  @override
  Widget build(BuildContext context) {
    JournalDatabaseTransfer jdt = ModalRoute.of(context).settings.arguments;

    return DefaultScaffold(
        title: Helper.toHumanDate(jdt.date),
        child: JournalEntryDetailView(journalEntry: jdt));
  }
}
