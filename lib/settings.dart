import 'package:mathemagician/tasks/square_task.dart';
import 'package:mathemagician/utils.dart';

class Settings {
  // VISIBLE SETTINGS
  final SettingsIntegerItem difficulty;
  final SettingsItem<bool> useDifficulty;

  // @formatter:off
  final SettingsItem<Map<String, bool>> selectedGroups;
  final SettingsItem<Map<String, bool>> selectedTasks;
  // @formatter:on

  final SettingsItem<bool> jumpAfterSolve;

  // INVISIBLE SETTINGS
  final SettingsIntegerItem batchesSolved;

  // TODO: load default values from somewhere
  Settings.defaultValues() :
    difficulty = new SettingsIntegerItem(3, min: 1, max: 10),
    useDifficulty = new SettingsItem(true),
        selectedGroups = new SettingsItem({
          'squaring': true,
          'multiplication': true,
        }),
        selectedTasks = new SettingsItem({
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
        }),
        jumpAfterSolve = new SettingsItem(true),
        batchesSolved = new SettingsIntegerItem(0);

  Settings.fromMap(Map<String, dynamic> map)
      : difficulty = new SettingsIntegerItem(map['difficulty']),
        useDifficulty = new SettingsItem(map['useDifficulty']),
        selectedGroups = new SettingsItem(_castInternalMap(map['selectedGroups'])),
        selectedTasks = new SettingsItem(_castInternalMap(map['selectedTasks'])),
        jumpAfterSolve = new SettingsItem(map['jumpAfterSolve']),
        batchesSolved = new SettingsIntegerItem(map['batchesSolved']);


  Map<String, dynamic> toMap() {
    return {
      'difficulty': difficulty.val,
      'useDifficulty': useDifficulty.val,
      'selectedGroups': selectedGroups.val,
      'selectedTasks': selectedTasks.val,
      'jumpAfterSolve': jumpAfterSolve.val,

      'batchesSolved': batchesSolved.val,
    };
  }

  static Map<K, V> _castInternalMap<K, V>(var internalMap) {
    return new Map<K, V>.from(internalMap as Map<K, dynamic>);
  }
}

class SettingsItem<T> {
  T _value;
  final Predicate<T> _validator;

  SettingsItem(this._value, [this._validator]);

  get val {
    return _value;
  }

  set val(T newValue) {
    if (this._validator != null && !_validator(newValue)) throw new Exception('Illegal value');
    _value = newValue;
  }
}

class SettingsIntegerItem extends SettingsItem<int> {
  final int min;
  final int max;

  SettingsIntegerItem(int value, {int min, int max})
      : this.min = min,
        this.max = max,
        super(value, min == null || max == null ? null : (d) => d >= min && d <= max);
}
