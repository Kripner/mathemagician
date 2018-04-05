import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mathemagician/settings.dart';
import 'package:mathemagician/tasks/task.dart';
import 'package:mathemagician/text_with_superscript.dart';

// might cause problems
SquareTaskState currentState;

class SquareTask extends Task {
  final int _number;

  SquareTask(Settings settings)
      : _number = _generateNumber(settings),
        super(settings);

  static int _generateNumber(Settings settings) {
    final int min = pow(10, settings.difficulty.val - 1);
    final int max = pow(10, settings.difficulty.val);

    return min + new Random().nextInt(max - min + 1);
  }

  @override
  State<StatefulWidget> createState() => currentState = new SquareTaskState();

  @override
  bool checkAnswer(int answer) {
    return answer == getAnswer();
  }

  @override
  int getAnswer() {
    return pow(_number, 2);
  }

  @override
  void showAnswer() {
    print('Show Answer 2');
    currentState.showAnswer();
  }
}

class SquareTaskState extends TaskState<SquareTask> {
  Widget buildQuestion(BuildContext context) {
    return new TextWithSuperscript(widget._number.toString(), '2');
  }
}
