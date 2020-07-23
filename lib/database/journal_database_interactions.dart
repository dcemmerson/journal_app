import 'package:flutter/foundation.dart';
import 'package:journal/database/journal_database_transfer.dart';

class JournalDatabaseInteractions {
  final Function(JournalDatabaseTransfer) saveJournalEntry;

  JournalDatabaseInteractions({@required this.saveJournalEntry});
}
