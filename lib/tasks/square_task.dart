import 'dart:math';

import 'package:mathemagician/math_expression.dart';
import 'package:mathemagician/tasks/task_data.dart';
import 'package:mathemagician/utils.dart';

class SquareTaskData extends TaskData {
  final int number;

  SquareTaskData.random(int numOfDigits) : number = generateNumber(numOfDigits, allowPowers: false);

  @override
  int getAnswer() {
    return pow(number, 2);
  }

  @override
  MathExpression buildExpression() {
    return new MathExpression(number.toString() + '\u00B2');
  }
}