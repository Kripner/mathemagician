import 'package:mathemagician/tasks/square_task.dart';
import 'package:mathemagician/utils.dart';

class Settings {
  final SettingsIntegerItem difficulty = new SettingsIntegerItem(3, min: 1, max: 6);
  final SettingsItem<Map<String, bool>> selected = new SettingsItem({
    'squares': true,
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
