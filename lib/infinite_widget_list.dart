import 'dart:collection';

import 'package:flutter/material.dart';

typedef D WidgetDataBuilder<D>(int index);
typedef T ListWidgetBuilder<T extends Widget, D>(int index, D data);

class InfiniteWidgetList<T extends Widget> extends ListBase<T> {
  final WidgetDataBuilder _dataBuilder;
  final ListWidgetBuilder _widgetBuilder;
  final List _data;

  @override
  int length;

  get _realLength => _data.length;

  InfiniteWidgetList(this.length, this._dataBuilder, this._widgetBuilder) : _data = [_dataBuilder(0)];

  @override
  T operator [](int index) {
    print('Widget number $index requested');

    if (index > _realLength)
      throw new Exception('Index too large - querying for other than the next widget is not supported');
    if (index == _realLength)
      _data.add(_dataBuilder(_realLength));

    return _widgetBuilder(index, _data[index]);
  }

  @override
  void operator []=(int index, T value) {
    throw new Exception('Not supported');
  }
}
