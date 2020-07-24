import 'package:flutter/material.dart';
import 'package:journal/database/journal_database_controller.dart';
import 'package:journal/database/journal_database_transfer.dart';
import 'package:journal/views/default_scaffold.dart';

class JournalEntryForm extends StatefulWidget {
  static const minRating = 1;
  static const maxRating = 5;

  static const route = 'journalentryform';

  final String pageTitle;
  final double paddingLeft = 20;
  final double paddingTop = 10;
  final double paddingRight = 20;
  final double paddingBottom = 10;

  final _formKey = GlobalKey<FormState>();

  JournalEntryForm({this.pageTitle: 'New Journal Entry'});

  @override
  _JournalEntryFormState createState() => _JournalEntryFormState();
}

class _JournalEntryFormState extends State<JournalEntryForm> {
  JournalDatabaseTransfer journalDatabaseTransfer = JournalDatabaseTransfer();
  bool errorSaving = false;

  Widget buildForm() {
    return SingleChildScrollView(
        child: Form(
            key: widget._formKey,
            child: Column(
              children: <Widget>[
                titleField(),
                bodyField(),
                ratingField(),
                buttonRow()
              ],
            )));
  }

  Widget titleField() {
    return Padding(
        padding: EdgeInsets.fromLTRB(widget.paddingLeft, widget.paddingTop,
            widget.paddingRight, widget.paddingBottom),
        child: TextFormField(
          decoration:
              InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
          validator: (value) => emptyStringValidator(value, 'title'),
          onSaved: (value) => journalDatabaseTransfer.title = value,
        ));
  }

  Widget bodyField() {
    return Padding(
        padding: EdgeInsets.fromLTRB(widget.paddingLeft, widget.paddingTop,
            widget.paddingRight, widget.paddingBottom),
        child: TextFormField(
          decoration: InputDecoration(
              labelText: 'Review', border: OutlineInputBorder()),
          minLines: 2,
          maxLines: 4,
          validator: (value) => emptyStringValidator(value, 'body'),
          onSaved: (value) => journalDatabaseTransfer.body = value,
        ));
  }

  Widget ratingField() {
    return Padding(
        padding: EdgeInsets.fromLTRB(widget.paddingLeft, widget.paddingTop,
            widget.paddingRight, widget.paddingBottom),
        child: TextFormField(
          decoration: InputDecoration(
              labelText: 'Rating', border: OutlineInputBorder()),
          validator: (value) => emptyIntValidator(value, 'rating'),
          onSaved: (value) => journalDatabaseTransfer.rating = int.parse(value),
        ));
  }

  Widget buttonRow() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [cancelButton(), saveButton()]);
  }

  Widget cancelButton() {
    return RaisedButton(
        child: Text('Cancel'),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  Widget saveButton() {
    return Builder(builder: (BuildContext ctx) {
      return RaisedButton(
          child: Text('Save'),
          onPressed: () {
            if (widget._formKey.currentState.validate()) {
              saveEntry(ctx);
            }
          });
    });
  }

  /// Save and validation related
  void saveEntry(BuildContext ctx) async {
    try {
      JournalDatabaseController jdc = JournalDatabaseController.getInstance();
      Scaffold.of(ctx).showSnackBar(SnackBar(content: Text('Saving')));
      widget._formKey.currentState.save();
      await jdc.insertJournalEntry(journalDatabaseTransfer);
      Scaffold.of(ctx).showSnackBar(SnackBar(content: Text('Saved!')));
      Navigator.pop(ctx, await jdc.getAllJournalEntries());
    } catch (err) {
      print(err);
      setState(() {
        errorSaving = true;
      });
    }
  }

  String emptyStringValidator(String value, String fieldName) {
    if (value.isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }

  String emptyIntValidator(String value, String fieldName) {
    if (value.isEmpty || !_isInteger(value)) {
      return 'Please enter valid $fieldName (${JournalEntryForm.minRating} - ${JournalEntryForm.maxRating})';
    }
    return null;
  }

  bool _isInteger(value) {
    try {
      var checkedInt = int.parse(value);
      return checkedInt is int;
    } catch (err) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(title: widget.pageTitle, child: buildForm());
  }
}
