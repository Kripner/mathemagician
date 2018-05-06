import 'dart:async';
import 'dart:io';
import 'dart:convert' as JSON;

import 'package:mathemagician/settings.dart';
import 'package:mathemagician/settings_migrations/settings_migration.dart';
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
    Map<String, dynamic> values = settings.toMap();
    assert(!values.containsKey('serialVersionID'), 'reserved settings key used');
    values['serialVersionID'] = Settings.SERIAL_VERSION_ID;
    String json = JSON.jsonEncode(values);
    return file.writeAsString(json);
  }

  Future<Settings> load() async {
    try {
      final file = await _settingsFile;
      String json = await file.readAsString();
      Map<String, dynamic> values = JSON.jsonDecode(json);

      int serialVersionID = values['serialVersionID'] as int;
      if (serialVersionID != Settings.SERIAL_VERSION_ID)
        values = migrate(values, serialVersionID); // try to migrate the settings
      Settings settings = new Settings.fromMap(values, storage: this);
      if (serialVersionID != Settings.SERIAL_VERSION_ID) save(settings); // save the migrated settings

      return settings;
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> migrate(Map<String, dynamic> values, int serialVersionID) {
    if (serialVersionID == Settings.SERIAL_VERSION_ID) return values; // doesn't need migration
    SettingsMigration migration = Settings.MIGRATIONS[serialVersionID];
    if (migration == null)
      return throw new Exception('Couldn\'t find migration from $serialVersionID to ${Settings.SERIAL_VERSION_ID}');
    return migrate(migration.migrate(values), migration.endVersion);
  }
}