import 'package:journal/database/journal_database_transfer.dart';
import 'package:journal/io/json_reader.dart';
import 'package:sqflite/sqflite.dart';

class JournalDatabaseController {
  final _createJournalIfNotExists = 'createJournalIfNotExists';
  final _selectAllJournalEntries = 'selectAllJournalEntries';
  final _insertJournalEntry = 'insertJournalEntry';
  final _tableName = 'journalEntries';

  final jsonPath;
  final filename;

  Map<String, String> dbQueries;
  Database db;

  JournalDatabaseController(
      {this.filename: 'journal.sqlite3.db',
      this.jsonPath: 'assets/database/database_queries.json'});

  Future<void> init() async {
    await readInJsonDbQueries();
    await openDb();
  }

  Future<void> readInJsonDbQueries() async {
    print('in read in json db queries');
    this.dbQueries = await JsonReader.read(jsonPath);
    print(dbQueries);
  }

  Future<void> openDb() async {
    db = await openDatabase(filename, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(dbQueries[_createJournalIfNotExists]);
    });
  }

  Future<void> closeDb() async {
    await db.close();
  }

  Future<int> getJournalEntryCount() {
    getAllJournalEntries().then((entries) => entries.length).catchError((err) {
      print(err);
      return -1;
    });
  }

  Future<List<Map<String, dynamic>>> getAllJournalEntries() async {
    List<Map<String, dynamic>> journalEntries =
        await db.rawQuery(dbQueries[_selectAllJournalEntries]);
    return journalEntries;
  }

  Future<JournalDatabaseTransfer> insertJournalEntry(
      JournalDatabaseTransfer jdt) async {
    jdt.id = await db.insert(_tableName, jdt.toMap());
    return jdt;
  }
}
