import 'package:mathemagician/settings_migrations/0to1.dart';
import 'package:mathemagician/settings_migrations/1to2.dart';
import 'package:mathemagician/settings_migrations/2to3.dart';
import 'package:mathemagician/settings_migrations/settings_migration.dart';
import 'package:mathemagician/settings_storage.dart';
import 'package:mathemagician/utils.dart';

class Settings {
  static const int SERIAL_VERSION_ID = 3;

  static const Map<int, SettingsMigration> MIGRATIONS = {
    0: const Migration0to1(),
    1: const Migration1to2(),
    2: const Migration2to3(),
  };

  // USER SETTINGS
  final SettingsIntegerItem difficulty;
  final SettingsItem<bool> useDifficulty;

  final SettingsItem<Map<String, bool>> selectedGroups;
  final SettingsItem<Map<String, bool>> selectedTasks;

  final SettingsItem<bool> jumpAfterSolve;

  // SYSTEM SETTINGS
  // this redundancy will be convenient later (maybe)
  final SettingsIntegerItem rainbows;
  final SettingsIntegerItem problemsSolved;
  final SettingsIntegerItem problemsSeen;
  final SettingsItem<bool> visitedSettings;

  // DEFAULT
  // @formatter:off
  static const Map<String, dynamic> DEFAULT_VALUES = {
    'difficulty': 3,
    'useDifficulty': true,
    'selectedGroups': {
      'squaring': true,
      'multiplication': true,
    },
    'selectedTasks': {
      '1-digit-squaring': false,
      '2-digit-squaring': true,
      '3-digit-squaring': true,
      '4-digit-squaring': true,
      '5-digit-squaring': false,
      '6-digit-squaring': false,

      '1x1-multiplication': false,
      '2x1-multiplication': false,
      '3x1-multiplication': true,
      '4x1-multiplication': true,
      '5x1-multiplication': false,
      '6x1-multiplication': false,

      '2x2-multiplication': false,
      '2x3-multiplication': false,
      '3x3-multiplication': false,
    },
    'jumpAfterSolve': true,
    'rainbows': 0,
    'problemsSolved': 0,
    'visitedSettings': false,
    'problemsSeen': 0,
  };
  // @formatter:on

  List<SettingsItem> _items;

  // CLASS LOGIC
  final SettingsStorage storage;

  Settings.defaultValues({storage})
      : this.fromMap(DEFAULT_VALUES, storage: storage);

  Settings.fromMap(Map<String, dynamic> map, {this.storage})
      : difficulty = new SettingsIntegerItem('difficulty', min: 1, max: 10),
        useDifficulty = new SettingsItem('useDifficulty'),
        selectedGroups = new SettingsItem('selectedGroups'),
        selectedTasks = new SettingsItem('selectedTasks'),
        jumpAfterSolve = new SettingsItem('jumpAfterSolve'),
        rainbows = new SettingsIntegerItem('rainbows'),
        problemsSolved = new SettingsIntegerItem('problemsSolved'),
        visitedSettings = new SettingsItem('visitedSettings'),
        problemsSeen = new SettingsIntegerItem('problemsSeen') {
    map['selectedGroups'] = _fromInternalMap(map['selectedGroups']);
    map['selectedTasks'] = _fromInternalMap(map['selectedTasks']);
    _items = [
      difficulty,
      useDifficulty,
      selectedGroups,
      selectedTasks,
      jumpAfterSolve,
      rainbows,
      problemsSolved,
      visitedSettings,
      problemsSeen
    ];
    _items.forEach((item) {
      item.setWithoutSave(map[item.name]);
      item.onChanged = _save;
    });
  }


  static Map<K, V> _fromInternalMap<K, V>(var internalMap) {
    return new Map<K, V>.from(internalMap as Map<K, dynamic>);
  }

  Map<String, dynamic> toMap() {
    return new Map.fromIterables(_items.map((item) => item.name), _items);
  }

  void _save() {
    storage?.save(this)?.catchError((e) {
      print('Saving settings failed: ' + e.toString());
    });
  }

  void resetProgress() {
    <SettingsItem>[rainbows, problemsSolved, problemsSeen, visitedSettings]
        .forEach((item) => item.reset());
    _save();
  }

  void resetSettings() {
    <SettingsItem>[difficulty, useDifficulty, selectedGroups, selectedTasks, jumpAfterSolve]
        .forEach((item) => item.reset());
    _save();
  }
}

class SettingsItem<T> {
  final Predicate<T> validator;
  final String name;
  T _value;
  Function onChanged;

  SettingsItem(this.name, {this.validator});

  get val {
    return _value;
  }

  set val(T newValue) {
    setWithoutSave(newValue);
    assert (onChanged != null);
    onChanged();
  }

  void setWithoutSave(T newValue) {
    if (this.validator != null && !validator(newValue)) throw new Exception('Illegal value');
    _value = newValue;
  }

  void reset() {
    _value = Settings.DEFAULT_VALUES[name];
  }
}

class SettingsIntegerItem extends SettingsItem<int> {
  final int min;
  final int max;

  SettingsIntegerItem(String name, {int min, int max})
      : this.min = min,
        this.max = max,
        super(name, validator: min == null || max == null ? null : (d) => d >= min && d <= max);
}
