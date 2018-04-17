import 'package:flutter/material.dart';
import 'package:mathemagician/utils.dart';

class CheckboxWithLabel extends StatelessWidget {
  final bool value;
  final Consumer<bool> onChanged;
  final Widget label;

  const CheckboxWithLabel({this.value, this.onChanged, this.label});

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        new Expanded(
          child: label,
        ),
      ],
    );
  }
}
