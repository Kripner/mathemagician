import 'dart:math';

import 'package:mathemagician/math_expression.dart';
import 'package:mathemagician/tasks/task_data.dart';
import 'package:mathemagician/utils.dart';

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

    _firstNumber = generateNumber(firstDigits, allowPowers: false);
    _secondNumber = generateNumber(secondDigits, allowPowers: false);
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
