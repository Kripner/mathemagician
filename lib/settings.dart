import 'package:mathemagician/settings_storage.dart';
import 'package:mathemagician/utils.dart';

class Settings {
  // VISIBLE SETTINGS
  final SettingsIntegerItem difficulty;
  final SettingsItem<bool> useDifficulty;

  final SettingsItem<Map<String, bool>> selectedGroups;
  final SettingsItem<Map<String, bool>> selectedTasks;

  final SettingsItem<bool> jumpAfterSolve;

  // INVISIBLE SETTINGS
  final SettingsIntegerItem batchesSolved;

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
    'batchesSolved': 0,
  };
  // @formatter:on

  // CLASS LOGIC
  final SettingsStorage storage;

  Settings.defaultValues({storage})
      : this.fromMap(DEFAULT_VALUES, storage: storage);

  Settings.fromMap(Map<String, dynamic> map, {this.storage})
      : difficulty = new SettingsIntegerItem(map['difficulty'], min: 1, max: 10),
        useDifficulty = new SettingsItem(map['useDifficulty']),
        selectedGroups = new SettingsItem(_castInternalMap(map['selectedGroups'])),
        selectedTasks = new SettingsItem(_castInternalMap(map['selectedTasks'])),
        jumpAfterSolve = new SettingsItem(map['jumpAfterSolve']),
        batchesSolved = new SettingsIntegerItem(map['batchesSolved']) {
    // _onChanged method not available in the initialization list
    difficulty.onChanged = useDifficulty.onChanged = selectedGroups.onChanged = selectedTasks.onChanged =
        jumpAfterSolve.onChanged = batchesSolved.onChanged = _onChanged;
  }


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

  void _onChanged() {
    storage?.save(this);
  }

  static Map<K, V> _castInternalMap<K, V>(var internalMap) {
    return new Map<K, V>.from(internalMap as Map<K, dynamic>);
  }
}

class SettingsItem<T> {
  T _value;
  final Predicate<T> validator;
  Function onChanged;

  SettingsItem(this._value, {this.validator});

  get val {
    return _value;
  }

  set val(T newValue) {
    if (this.validator != null && !validator(newValue)) throw new Exception('Illegal value');
    _value = newValue;
    assert (onChanged != null);
    onChanged();
  }
}

class SettingsIntegerItem extends SettingsItem<int> {
  final int min;
  final int max;

  SettingsIntegerItem(int value, {int min, int max})
      : this.min = min,
        this.max = max,
        super(value, validator: min == null || max == null ? null : (d) => d >= min && d <= max);
}
