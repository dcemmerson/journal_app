import 'package:journal/database/journal_database_controller.dart';
import 'package:journal/database/journal_database_transfer.dart';

abstract class JournalService {
  // Stream<int> journalEntryCount();
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
    return journalDatabaseController.journalChangeNotifier.stream;
  }

  // @override
  // Stream<int> journalEntryCount() {
  // return journalDatabaseController.journalChangeNotifier.stream.map((entry) => )
//    return journalDatabaseController.journalChangeNotifier.stream;

  // return journalDatabaseController.journalChangeNotifier.stream
  //     .reduce((count) => count++);
  // }

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
