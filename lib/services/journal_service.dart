import 'package:journal/database/journal_database_controller.dart';
import 'package:journal/database/journal_database_transfer.dart';

import 'journal_entry_translator.dart';

abstract class JournalService {
  Stream<List<JournalDatabaseTransfer>> journalEntries();

  Future addJournalEntry(JournalDatabaseTransfer jdt);
  Future updateJournalEntry(JournalDatabaseTransfer jdt);
  Future deleteJournalEntry(int id);
}

class JournalDatabaseService implements JournalService {
  final JournalDatabaseController journalDatabaseController;

  JournalDatabaseService(this.journalDatabaseController);

  @override
  Stream<List<JournalDatabaseTransfer>> journalEntries() {
    return journalDatabaseController.journalChangeNotifier.stream
        .transform(JournalEntryTranslator());
  }

  @override
  Future addJournalEntry(JournalDatabaseTransfer jdt) async {
    return await journalDatabaseController.insertJournalEntry(jdt);
  }

  @override
  Future updateJournalEntry(JournalDatabaseTransfer jdt) async {
    return await journalDatabaseController.updateJournalEntry(jdt.id, jdt);
  }

  @override
  Future deleteJournalEntry(int id) async {
    return await journalDatabaseController.deleteJournalEntry(id);
  }
}
