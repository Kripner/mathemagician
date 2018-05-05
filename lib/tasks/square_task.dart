import 'dart:math';

import 'package:mathemagician/math_expression.dart';
import 'package:mathemagician/tasks/task.dart';

class SquareTaskData extends TaskData {
  final int number;

  SquareTaskData.random(int numOfDigits) : number = _generateNumber(numOfDigits);

  static int _generateNumber(numOfDigits) {
    final int min = pow(10, numOfDigits - 1);
    final int max = pow(10, numOfDigits);
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

  @override
  MathExpression buildExpression() {
    SquareTaskData data = super.data as SquareTaskData;
    return new MathExpression(data.number.toString() + '\u00B2');
  }
}
