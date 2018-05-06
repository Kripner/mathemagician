import 'package:mathemagician/settings_migrations/settings_migration.dart';
import 'package:mathemagician/training.dart';

// removes 'batchesSolved' (number of collected rainbows)
// adds 'rainbows' (number of collected rainbows)
// adds 'problemsSolved' (number of solved problems)
class Migration0to1 extends SettingsMigration {
  const Migration0to1();

  @override
  Map<String, dynamic> migrate(Map<String, dynamic> oldMap) {
    Map<String, dynamic> newMap = super.migrate(oldMap);
    int rainbows = newMap.remove('batchesSolved') as int;
    newMap['rainbows'] = rainbows;
    newMap['problemsSolved'] = rainbows * Training.PROBLEMS_BATCH_SIZE;
    return newMap;
  }

  @override
  int get startVersion => 0;

  @override
  int get endVersion => 1;
}