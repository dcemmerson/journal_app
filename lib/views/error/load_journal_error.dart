import 'package:flutter/material.dart';

class LoadJournalError extends StatelessWidget {
  static const Error =
      'An eror seems to have occured while loading previous journal entries';

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Center(child: Text(LoadJournalError.Error)));
  }
}
