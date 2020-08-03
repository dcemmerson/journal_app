/// filename: journal_database_controller.dart
/// last modified: 08/03/2020
/// description: File manages connecting to sqflite database and performing
///   database read, write, update, delete functionallities. Database instance
///   is accessed using a factory constructor.

import 'dart:async';

import 'package:journal/database/journal_database_transfer.dart';
import 'package:journal/io/json_reader.dart';
import 'package:sqflite/sqflite.dart';

class JournalDatabaseController {
  static const _dropJournalIfExists = 'dropJournalIfExists';
  static const _createJournalIfNotExists = 'createJournalIfNotExists';
  static const _selectAllJournalEntries = 'selectAllJournalEntries';
  static const _insertJournalEntry = 'insertJournalEntry';
  static const _updateJournalEntrySort = 'updateJournalEntrySort';
  static const _tableName = 'journalEntries';

  static const jsonPath = 'assets/database/database_queries.json';
  static const filename = 'journal.sqlite3.db';

  static Map<String, String> _dbQueries;
  static JournalDatabaseController _instance;
  final Database _db;

  StreamController<List<JournalDatabaseTransfer>> journalChangeNotifier =
      StreamController<List<JournalDatabaseTransfer>>.broadcast();

  JournalDatabaseController._(Database database) : _db = database {
    journalEntries.then((entries) => journalChangeNotifier.add(entries));
  }

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

  Future<int> get journalEntryCount =>
      journalEntries.then((entries) => entries.length).catchError((err) {
        print(err);
        return -1;
      });

  Future<List<JournalDatabaseTransfer>> get journalEntries => _db
      .rawQuery(_dbQueries[_selectAllJournalEntries])
      .then((entries) => entries
          .map((entry) => JournalDatabaseTransfer.fromMap(entry))
          .toList());

  Future insertJournalEntry(JournalDatabaseTransfer jdt) async {
    jdt.id = await _db.insert(_tableName, jdt.toMap());
    journalChangeNotifier.add(await journalEntries);
  }

  Future deleteJournalEntry(int id) async {
    await _db.delete(_tableName, where: 'id=?', whereArgs: [id]);
    journalChangeNotifier.add(await journalEntries);
  }

  Future updateJournalEntry(int id, JournalDatabaseTransfer jdt) async {
    await _db.update(_tableName, jdt.toMap(), where: 'id=?', whereArgs: [id]);
    journalChangeNotifier.add(await journalEntries);
  }

  Future reorderJournalEntriesEvent(List<JournalDatabaseTransfer> jdts) async {
    var awaitFutures = jdts
        .map((JournalDatabaseTransfer jdt) => _db
            .rawQuery(_dbQueries[_updateJournalEntrySort], [jdt.sort, jdt.id]))
        .toList();

    await Future.wait(awaitFutures);
    journalChangeNotifier.add(await journalEntries);
  }

  Future dropJournalTable() async {
    await _db.execute(_dbQueries[_dropJournalIfExists]);
  }

  Future createJournalTable() async {
    return await _db.execute(_dbQueries[_createJournalIfNotExists]);
  }
}
