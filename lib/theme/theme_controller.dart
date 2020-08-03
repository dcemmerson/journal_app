/// filename: theme_controller.dart
/// last modified: 08/03/2020
/// description: Class that defines the color themes for journal app
///   and provides get method which will return the theme for current
///   dark mode setting.

import 'package:flutter/material.dart';

class ThemeController {
  final bool darkMode;

  ThemeData _themeLight = ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.lightBlue[800],
      accentColor: Colors.cyan[600],
      fontFamily: 'Ubuntu',
      textTheme: TextTheme(
        headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
      ));

  ThemeData _themeDark = ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.orange,
      accentColor: Colors.orange[800],
      fontFamily: 'Ubuntu',
      textTheme: TextTheme(
        headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
      ));

  ThemeController({this.darkMode: false});

  ThemeData get themeData => darkMode ? _themeDark : _themeLight;
}
