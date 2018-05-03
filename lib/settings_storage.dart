import 'dart:async';
import 'dart:io';
import 'dart:convert' as JSON;

import 'package:mathemagician/settings.dart';
import 'package:path_provider/path_provider.dart';


class SettingsStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _settingsFile async {
    final path = await _localPath;
    return new File('$path/settings.json');
  }

  Future<File> save(Settings settings) async {
    final file = await _settingsFile;
    String json = JSON.jsonEncode(settings.toMap());
    print(json);
    return file.writeAsString('$json');
  }

  Future<Settings> load() async {
    try {
      final file = await _settingsFile;
      String json = await file.readAsString();
      print(json);
      Map<String, dynamic> parsed = JSON.jsonDecode(json);
      print(parsed);
      Settings settings = new Settings.fromMap(parsed);
      return settings;
    } catch (e) {
      return null;
    }
  }
}