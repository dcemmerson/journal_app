import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class JsonReader {
  /// name: read
  /// description: Read file located at fileUri and convert to members
  ///               in Resume class.
  static Future<Map<String, String>> read(String fileUri) {
    print('read file');
    print(fileUri);
    return Future<Map<String, String>>(() {
      return rootBundle.loadString(fileUri).then(jsonDecode).then((decoded) {
        return decoded.cast<String, String>();
      });
    });
  }
}
