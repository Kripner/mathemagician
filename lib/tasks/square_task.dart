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
  MathExpression buildExpression() {
    return new MathExpression(number.toString() + '\u00B2');
  }
}