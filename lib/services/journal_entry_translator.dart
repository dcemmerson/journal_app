/// filename: journal_entry_translator.dart
/// last modified: 08/03/2020
/// description: Implementation of stream translator, used to sort database
///   entries in the order specified by user (changed by screen gestures,
///   dragging and dropping listview of journal entries). A stream translator
///   is really not necessary to perform this task, but I implemented it for
///   exploration and learning purposes.

import 'dart:async';

import 'package:journal/database/journal_database_transfer.dart';

class JournalEntryTranslator<S, T> extends StreamTransformerBase<S, T> {
  final StreamTransformer<S, T> transformer;

  JournalEntryTranslator() : transformer = createTranslator();

  @override
  Stream<T> bind(Stream<S> stream) => transformer.bind(stream);

  static StreamTransformer<S, T> createTranslator<S, T>() =>
      StreamTransformer<S, T>((Stream inputStream, bool cancelOnError) {
        StreamController controller;
        StreamSubscription subscription;

        controller = new StreamController<T>(
          onListen: () {
            subscription = inputStream.listen(
                (entries) => controller.add(sort(entries)),
                onDone: controller.close,
                onError: controller.addError,
                cancelOnError: cancelOnError);
          },
          onPause: ([Future<dynamic> resumeSignal]) =>
              subscription.pause(resumeSignal),
          onResume: () => subscription.resume(),
          onCancel: () => subscription.cancel(),
        );

        return controller.stream.listen(null);
      });

  static List<JournalDatabaseTransfer> sort(
      List<JournalDatabaseTransfer> entries) {
    entries.sort((a, b) {
      if (a.sort > b.sort) {
        return 1;
      } else if (a.sort == b.sort) {
        return 0;
      } else {
        return -1;
      }
    });
    return entries;
  }
}