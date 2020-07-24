import 'package:journal/database/journal_database_transfer.dart';
import 'package:journal/io/json_reader.dart';
import 'package:sqflite/sqflite.dart';

class JournalDatabaseController {
  static const _createJournalIfNotExists = 'createJournalIfNotExists';
  static const _selectAllJournalEntries = 'selectAllJournalEntries';
  static const _insertJournalEntry = 'insertJournalEntry';
  static const _tableName = 'journalEntries';

  static const jsonPath = 'assets/database/database_queries.json';
  static const filename = 'journal.sqlite3.db';

  static Map<String, String> _dbQueries;
  static JournalDatabaseController _instance;
  final Database _db;

  JournalDatabaseController._(Database database) : _db = database;

  factory JournalDatabaseController.getInstance() {
    assert(_instance != null);
    return _instance;
  }

  static Future init() async {
    await readInJsonDbQueries();
    _instance = JournalDatabaseController._(await _openDb());
  }

  static Future readInJsonDbQueries() async {
    _dbQueries = await JsonReader.read(jsonPath);
  }

  static Future _openDb() async {
    return await openDatabase(filename, version: 1,
        onCreate: (Database database, int version) async {
      return await database.execute(_dbQueries[_createJournalIfNotExists]);
    });
  }

  Future closeDb() async {
    await _db.close();
  }

  Future<int> getJournalEntryCount() {
    return getAllJournalEntries()
        .then((entries) => entries.length)
        .catchError((err) {
      print(err);
      return -1;
    });
  }

  Future<List<Map<String, dynamic>>> getAllJournalEntries() async {
    List<Map<String, dynamic>> journalEntries =
        await _db.rawQuery(_dbQueries[_selectAllJournalEntries]);
    return journalEntries;
  }

  Future<JournalDatabaseTransfer> insertJournalEntry(
      JournalDatabaseTransfer jdt) async {
    jdt.id = await _db.insert(_tableName, jdt.toMap());
    return jdt;
  }

  Future<void> deleteJournalEntry(int id) async {
    await _db.delete(_tableName, where: 'id=?', whereArgs: [id]);
  }

  Future<void> updateJournalEntry(int id, JournalDatabaseTransfer jdt) async {
    await _db.update(_tableName, jdt.toMap(), where: 'id=?', whereArgs: [id]);
  }
}
