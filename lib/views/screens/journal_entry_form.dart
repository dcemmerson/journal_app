import 'package:flutter/material.dart';
import 'package:journal/database/journal_database_controller.dart';
import 'package:journal/database/journal_database_transfer.dart';
import 'package:journal/views/default_scaffold.dart';
import 'package:journal/views/miscellaneous_widgets/tappable_stars.dart';

class JournalEntryForm extends StatefulWidget {
  static const minRating = 1;
  static const maxRating = 5;

  static const route = 'journalentryform';

  final JournalDatabaseTransfer previousJdt;

  final String pageTitle;
  final double paddingLeft = 20;
  final double paddingTop = 10;
  final double paddingRight = 20;
  final double paddingBottom = 10;

  final _formKey = GlobalKey<FormState>();

  JournalEntryForm({this.pageTitle: 'New Journal Entry', this.previousJdt});

  @override
  _JournalEntryFormState createState() => _JournalEntryFormState();
}

class _JournalEntryFormState extends State<JournalEntryForm> {
  JournalDatabaseTransfer journalDatabaseTransfer = JournalDatabaseTransfer();
  bool errorSaving = false;

  Widget buildForm() {
    print('previous jdt');
    print(widget.previousJdt);
    return SingleChildScrollView(
        child: Form(
            key: widget._formKey,
            child: Column(
              children: [
                titleField(),
                bodyField(),
                starRatingField(),
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
          initialValue:
              widget.previousJdt != null ? widget.previousJdt.title : '',
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
          initialValue:
              widget.previousJdt != null ? widget.previousJdt.body : '',
          minLines: 2,
          maxLines: 4,
          validator: (value) => emptyStringValidator(value, 'body'),
          onSaved: (value) => journalDatabaseTransfer.body = value,
        ));
  }

  // Widget ratingField() {
  //   return Padding(
  //       padding: EdgeInsets.fromLTRB(widget.paddingLeft, widget.paddingTop,
  //           widget.paddingRight, widget.paddingBottom),
  //       child: TextFormField(
  //         decoration: InputDecoration(
  //             labelText: 'Rating', border: OutlineInputBorder()),
  //         initialValue: widget.previousJdt != null
  //             ? widget.previousJdt.rating.toString()
  //             : '',
  //         validator: (value) => intValidator(value, 'rating',
  //             JournalEntryForm.minRating, JournalEntryForm.maxRating),
  //         onSaved: (value) => journalDatabaseTransfer.rating = int.parse(value),
  //       ));
  // }

  Widget starRatingField() {
    return Padding(
        padding: EdgeInsets.fromLTRB(widget.paddingLeft, widget.paddingTop,
            widget.paddingRight, widget.paddingBottom),
        child: FormField(
          initialValue: widget.previousJdt != null
              ? widget.previousJdt.rating.toString()
              : '0',
          validator: (value) => null,
          onSaved: (value) =>
              journalDatabaseTransfer.rating = double.parse(value),
          builder: (FormFieldState<String> field) {
            double rating =
                (field.value != null) ? double.parse(field.value) : 0;
            return TappableStars(
                rating: rating,
                setRating: (double rating) {
                  field.didChange(rating.toString());
                  print(rating);
                });
          },
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
              persistEntry(ctx);
            }
          });
    });
  }

  /// Save/update and validation related
  void persistEntry(BuildContext ctx) async {
    try {
      JournalDatabaseController jdc = JournalDatabaseController.getInstance();
      widget._formKey.currentState.save();
      if (widget.previousJdt != null) {
        // Then this entry exists in db and we are updating
        Scaffold.of(ctx).showSnackBar(SnackBar(content: Text('Updating')));
        await jdc.updateJournalEntry(
            widget.previousJdt.id, journalDatabaseTransfer);
        Scaffold.of(ctx).showSnackBar(SnackBar(content: Text('Updated!')));
      } else {
        // Else new entry we need to insert into db.
        Scaffold.of(ctx).showSnackBar(SnackBar(content: Text('Saving')));
        await jdc.insertJournalEntry(journalDatabaseTransfer);
        Scaffold.of(ctx).showSnackBar(SnackBar(content: Text('Saved!')));
      }

      Navigator.pop(ctx, journalDatabaseTransfer);
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

  String intValidator(String value, String fieldName, int min, int max) {
    if (value.isEmpty ||
        !_isInteger(value) ||
        int.parse(value) < min ||
        int.parse(value) > max) {
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
