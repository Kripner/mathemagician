import 'dart:collection';

import 'package:flutter/material.dart';

typedef T ListWidgetBuilder<T extends Widget>(int index);

class InfiniteWidgetList<T extends Widget> extends ListBase<T> {
  final ListWidgetBuilder _widgetBuilder;
  final List<T> _widgets;

  @override
  int length;

  get _realLength => _widgets.length;

  InfiniteWidgetList(this.length, this._widgetBuilder) : _widgets = [_widgetBuilder(0)];

  @override
  T operator [](int index) {
    print('Widget number $index requested');

    if (index < _realLength) return _widgets[index];
    if (index > _realLength)
      throw new Exception('Index too large - querying for other than the next widget is not supported');
    print('Creating new widget');
    T newWidget = _widgetBuilder(_realLength);
    _widgets.add(newWidget);
    return newWidget;
  }

  @override
  void operator []=(int index, T value) {
    throw new Exception('Not supported');
  }
}
