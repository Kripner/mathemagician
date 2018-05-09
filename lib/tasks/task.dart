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

  Task createTask();
}

abstract class Task extends StatelessWidget {
  final TaskData data;

  Task(this.data);

  MathExpression buildExpression() {
    return null;
  }

  Widget buildQuestion(BuildContext context, {TextStyle style}) {
    MathExpression expression = buildExpression();
    if (expression == null)
      throw new Exception('If buildQuestion() is not overriden, buildExpression() musn\'t return null');
    return expression.createExpression(style: style);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle taskStyle = textTheme.headline;
    return new Center(
      child: new Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Flexible(
            child: buildQuestion(context, style: taskStyle),
          ),
          new Text(' = ', style: taskStyle),
          new Flexible(
            child: new Stack(
              children: <Widget>[
                new Opacity(opacity: data.answerShowed ? 1.0 : 0.0, child: new Text(data.getAnswer().toString(), style: taskStyle)),
                new Opacity(opacity: data.answerShowed ? 0.0 : 1.0, child: new Text('_______', style: taskStyle)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
