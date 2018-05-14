import 'package:mathemagician/settings_migrations/settings_migration.dart';
import 'package:mathemagician/training.dart';

// adds 'visitedSettings'
class Migration2to3 extends SettingsMigration {
  const Migration2to3();

  @override
  Map<String, dynamic> migrate(Map<String, dynamic> oldMap) {
    Map<String, dynamic> newMap = super.migrate(oldMap);
    newMap['problemsSeen'] = oldMap['problemsSolved'];
    return newMap;
  }

  @override
  int get startVersion => 2;

  @override
  int get endVersion => 3;
}