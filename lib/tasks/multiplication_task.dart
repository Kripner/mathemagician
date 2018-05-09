import 'dart:math';

import 'package:mathemagician/math_expression.dart';
import 'package:mathemagician/tasks/task_data.dart';

class MultiplicationTaskData extends TaskData {
  int _firstNumber;
  int _secondNumber;

  MultiplicationTaskData.random(int firstDigits, int secondDigits) {
    if (new Random().nextDouble() < 0.5) {
      // swap the digits
      firstDigits += secondDigits;
      secondDigits = firstDigits - secondDigits;
      firstDigits -= secondDigits;
    }

    _firstNumber = _generateNumber(firstDigits);
    _secondNumber = _generateNumber(secondDigits);
  }

  static int _generateNumber(numOfDigits) {
    final int min = pow(10, numOfDigits - 1);
    final int max = pow(10, numOfDigits);
    return min + new Random().nextInt(max - min + 1);
  }

  @override
  int getAnswer() {
    return _firstNumber * _secondNumber;
  }

  @override
  MathExpression buildExpression() {
    return new MathExpression('$_firstNumber x $_secondNumber');
  }
}
