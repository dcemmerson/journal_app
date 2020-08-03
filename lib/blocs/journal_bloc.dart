/// filename: journal_bloc.dart
/// last modified: 08/03/2020
/// description: Business logic component for database input/output.
///   This file handles connecting to the controller.dart files, turning
///   database logic into streams.

import 'dart:async';

import 'package:journal/database/journal_database_transfer.dart';
import 'package:journal/services/journal_service.dart';
import 'package:rxdart/rxdart.dart';

class JournalBloc {
  final JournalService _service;

  //inputs
  StreamController<AddJournalEntryEvent> addJournalEntrySink =
      StreamController<AddJournalEntryEvent>();
  StreamController<DeleteJournalEntryEvent> deleteJournalEntrySink =
      StreamController<DeleteJournalEntryEvent>();
  StreamController<UpdateJournalEntryEvent> updateJournalEntrySink =
      StreamController<UpdateJournalEntryEvent>();
  StreamController<ReorderJournalEntriesEvent> reorderJournalEntriesSink =
      StreamController<ReorderJournalEntriesEvent>();

  //outputs
  Stream<List<JournalDatabaseTransfer>> get journalEntries =>
      _journalEntriesStreamController.stream;
  StreamController _journalEntriesStreamController =
      BehaviorSubject<List<JournalDatabaseTransfer>>();

  Stream<int> get journalEntryCount =>
      _journalEntryCountStreamController.stream;
  StreamController _journalEntryCountStreamController = BehaviorSubject<int>();

  JournalBloc(this._service) {
    addJournalEntrySink.stream.listen(_handleAddJournalEntry);
    deleteJournalEntrySink.stream.listen(_handleDeleteJournalEntry);
    updateJournalEntrySink.stream.listen(_handleUpdateJournalEntry);
    reorderJournalEntriesSink.stream.listen(_handleReorderJournalEntries);

    _service.journalEntries().listen(
        (List<JournalDatabaseTransfer> journalEntries) =>
            _journalEntriesStreamController.add(journalEntries));
    _service.journalEntries();
  }

  void _handleAddJournalEntry(AddJournalEntryEvent addJournalEntryEvent) {
    _service.addJournalEntry(addJournalEntryEvent.jdt);
  }

  void _handleDeleteJournalEntry(
      DeleteJournalEntryEvent deleteJournalEntryEvent) {
    _service.deleteJournalEntry(deleteJournalEntryEvent.id);
  }

  void _handleUpdateJournalEntry(
      UpdateJournalEntryEvent updateJournalEntryEvent) {
    _service.updateJournalEntry(updateJournalEntryEvent.jdt);
  }

  void _handleReorderJournalEntries(ReorderJournalEntriesEvent rjee) {
    _service.reorderJournalEntries(rjee.journalEntries);
  }

  close() {
    addJournalEntrySink.close();
    deleteJournalEntrySink.close();
    updateJournalEntrySink.close();
    reorderJournalEntriesSink.close();
    _journalEntriesStreamController.close();
    _journalEntryCountStreamController.close();
  }
}

class AddJournalEntryEvent {
  final JournalDatabaseTransfer jdt;
  AddJournalEntryEvent(this.jdt);
}

class DeleteJournalEntryEvent {
  final int id;
  DeleteJournalEntryEvent(this.id);
}

class UpdateJournalEntryEvent {
  final JournalDatabaseTransfer jdt;
  UpdateJournalEntryEvent(this.jdt);
}

class ReorderJournalEntriesEvent {
  final List<JournalDatabaseTransfer> journalEntries;
  ReorderJournalEntriesEvent(this.journalEntries);
}
