import 'package:flutter/material.dart';
import 'package:mathemagician/math_expression.dart';
import 'package:mathemagician/settings.dart';

enum TaskStatus { CLEAN, FAILURE, SUCCESS }

abstract class TaskData {
  bool answerShowed = false;
  TaskStatus status = TaskStatus.CLEAN;

  int getAnswer();

  bool isCorrect(int answer) {
    return answer == getAnswer();
  }

  MathExpression buildExpression() {
    return null;
  }
}