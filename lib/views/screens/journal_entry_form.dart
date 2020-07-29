import 'package:flutter/material.dart';
import 'package:journal/blocs/journal_bloc.dart';
import 'package:journal/blocs/journal_state.dart';
import 'package:journal/database/journal_database_controller.dart';
import 'package:journal/database/journal_database_transfer.dart';
import 'package:journal/views/default_scaffold.dart';
import 'package:journal/views/widgets/tappable_stars.dart';

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
  JournalDatabaseTransfer _journalDatabaseTransfer = JournalDatabaseTransfer();
  bool _errorSaving = false;
  bool _formChanged = false;

  void _onFormChanged() {
    if (!_formChanged) {
      setState(() => _formChanged = true);
    }
  }

  Future<bool> _onWillPop() {
    if (!_formChanged) {
      return Future<bool>.value(true);
    }

    return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
                'Are you sure you want to abandon form? Unsaved changes will be lost.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                textColor: Colors.red,
                onPressed: () => Navigator.pop(context, false),
              ),
              FlatButton(
                  child: Text('Abandon'),
                  onPressed: () => Navigator.pop(context, true)),
            ],
          );
        });
  }

  Widget _buildForm() {
    return SingleChildScrollView(
        child: Form(
            key: widget._formKey,
            onWillPop: _onWillPop,
            onChanged: _onFormChanged,
            child: Column(
              children: [
                _titleField(),
                _bodyField(),
                _starRatingField(),
                _buttonRow(),
              ],
            )));
  }

  Widget _titleField() {
    return Padding(
        padding: EdgeInsets.fromLTRB(widget.paddingLeft, widget.paddingTop,
            widget.paddingRight, widget.paddingBottom),
        child: TextFormField(
          decoration:
              InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
          initialValue:
              widget.previousJdt != null ? widget.previousJdt.title : '',
          validator: (value) => _emptyStringValidator(value, 'title'),
          onSaved: (value) => _journalDatabaseTransfer.title = value,
        ));
  }

  Widget _bodyField() {
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
          validator: (value) => _emptyStringValidator(value, 'body'),
          onSaved: (value) => _journalDatabaseTransfer.body = value,
        ));
  }

  Widget _starRatingField() {
    return Padding(
        padding: EdgeInsets.fromLTRB(widget.paddingLeft, widget.paddingTop,
            widget.paddingRight, widget.paddingBottom),
        child: FormField(
          initialValue: widget.previousJdt != null
              ? widget.previousJdt.rating.toString()
              : '0',
          validator: (value) => null,
          onSaved: (value) =>
              _journalDatabaseTransfer.rating = double.parse(value),
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

  Widget _buttonRow() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [_cancelButton(), _saveButton()]);
  }

  Widget _cancelButton() {
    return RaisedButton(
        child: Text('Cancel'),
        onPressed: () async {
          if (await _onWillPop()) {
            Navigator.pop(context);
          }
        });
  }

  Widget _saveButton() {
    return Builder(builder: (BuildContext ctx) {
      return RaisedButton(
          child: Text('Save'),
          onPressed: () {
            if (widget._formKey.currentState.validate()) {
              _persistEntry(ctx);
            }
          });
    });
  }

  /// Save/update and validation related
  void _persistEntry(BuildContext ctx) async {
    try {
      JournalDatabaseController jdc = JournalDatabaseController.getInstance();
      widget._formKey.currentState.save();
      if (widget.previousJdt != null) {
        _journalDatabaseTransfer.id = widget.previousJdt.id;
        // Then this entry exists in db and we are updating
        Scaffold.of(ctx).showSnackBar(SnackBar(content: Text('Updating')));
        JournalStateContainer.of(context)
            .blocProvider
            .journalBloc
            .updateJournalEntrySink
            .add(UpdateJournalEntryEvent(_journalDatabaseTransfer));
        Scaffold.of(ctx).showSnackBar(SnackBar(content: Text('Updated!')));
      } else {
        // Else new entry we need to insert into db.
        Scaffold.of(ctx).showSnackBar(SnackBar(content: Text('Saving')));
        JournalStateContainer.of(context)
            .blocProvider
            .journalBloc
            .addJournalEntrySink
            .add(AddJournalEntryEvent(_journalDatabaseTransfer));
        Scaffold.of(ctx).showSnackBar(SnackBar(content: Text('Saved!')));
      }

      Navigator.pop(ctx);
    } catch (err) {
      print(err);
      setState(() => _errorSaving = true);
    }
  }

  String _emptyStringValidator(String value, String fieldName) {
    if (value.isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }

  String _intValidator(String value, String fieldName, int min, int max) {
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
    return DefaultScaffold(title: widget.pageTitle, child: _buildForm());
  }
}
