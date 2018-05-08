import 'dart:math';

import 'package:flutter/material.dart';

typedef bool Predicate<T>(T value);

final String rainbow = String.fromCharCode(0x1F308); // rainbow 🌈

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

double randomLikeNormal(Random random, double mean, double variance) {
  // this looks pretty much like gaussian in my experiments
  double base = (random.nextDouble() + random.nextDouble() + random.nextDouble() + random.nextDouble()) / 4;
  return (base - .5) * variance + mean;
}