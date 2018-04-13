import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mathemagician/settings.dart';
import 'package:mathemagician/tasks/task.dart';
import 'package:mathemagician/text_with_superscript.dart';

class SquareTaskData extends TaskData {
  final int number;

  SquareTaskData.newRandom(Settings settings)
      : number = _generateNumber(settings),
        super.newRandom(settings);

  static int _generateNumber(Settings settings) {
    final int min = pow(10, settings.difficulty.val - 1);
    final int max = pow(10, settings.difficulty.val);

    return min + new Random().nextInt(max - min + 1);
  }

  @override
  int getAnswer() {
    return pow(number, 2);
  }

  @override
  Task createTask() {
    return new SquareTask(this);
  }
}

class SquareTask extends Task {
  SquareTask(SquareTaskData data) : super(data);

  Widget buildQuestion(BuildContext context) {
    SquareTaskData data = super.data as SquareTaskData;
    return new TextWithSuperscript(data.number.toString(), '2');
  }
}
