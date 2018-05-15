import 'package:flutter/material.dart';
import 'package:mathemagician/math_expression.dart';
import 'package:mathemagician/settings.dart';

enum TaskStatus { CLEAN, FAILURE, SUCCESS, SHOWED_ANSWER }

abstract class TaskData {
  bool answerShown = false;
  TaskStatus status = TaskStatus.CLEAN;
  String userInput = '';
  String lastSubmittedInput = '';
  int difficulty;

  int getAnswer();

  bool isCorrect(int answer) {
    return answer == getAnswer();
  }

  MathExpression buildExpression();
}