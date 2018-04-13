import 'package:mathemagician/tasks/square_task.dart';
import 'package:mathemagician/utils.dart';

class Settings {
  final SettingsIntegerItem difficulty = new SettingsIntegerItem(3, min: 1, max: 10);
  final SettingsItem<bool> useDifficulty = new SettingsItem(true);
  final SettingsItem<Map<String, bool>> selected = new SettingsItem({
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
  });
}

class SettingsItem<T> {
  T _value;
  final Predicate<T> _validator;

  SettingsItem(this._value, [this._validator]);

  get val {
    return _value;
  }

  set val(T newValue) {
    if (!_validator(newValue)) throw new Exception('Illegal value');
    _value = newValue;
  }
}

class SettingsIntegerItem extends SettingsItem<int> {
  final int min;
  final int max;

  SettingsIntegerItem(int value, {int min, int max})
      : this.min = min,
        this.max = max,
        super(value, (d) => d >= min && d <= max);
}
