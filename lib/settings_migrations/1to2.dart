import 'package:mathemagician/settings_migrations/settings_migration.dart';
import 'package:mathemagician/training.dart';

// adds 'visitedSettings'
class Migration1to2 extends SettingsMigration {
  const Migration1to2();

  @override
  Map<String, dynamic> migrate(Map<String, dynamic> oldMap) {
    Map<String, dynamic> newMap = super.migrate(oldMap);
    newMap['visitedSettings'] = false;
    return newMap;
  }

  @override
  int get startVersion => 1;

  @override
  int get endVersion => 2;
}