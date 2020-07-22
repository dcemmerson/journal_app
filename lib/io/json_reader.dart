import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class JsonReader {
  /// name: read
  /// description: Read file located at fileUri and convert to members
  ///               in Resume class.
  static Future<List<Map<String, String>>> read(String fileUri) {
    print('read file');
    return Future<void>(() {
      return rootBundle.loadString(fileUri).then(jsonDecode).then((decoded) {
        return decoded;
      });
    });
  }
}
