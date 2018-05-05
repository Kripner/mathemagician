import 'package:flutter/material.dart';

typedef bool Predicate<T>(T value);

O doNothing<I, O>(I importantValueToBeProcessedCarefully) {
  return null; // so lazy
}

typedef void Action();

typedef void Consumer<T>(T value);

void showTextSnackBar(BuildContext context, String text) {
  Scaffold.of(context).showSnackBar(new SnackBar(
    content: new Text(text),
  ));
}