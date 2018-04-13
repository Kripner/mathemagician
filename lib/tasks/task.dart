import 'package:flutter/material.dart';
import 'package:mathemagician/settings.dart';

enum TaskStatus { CLEAN, FAILURE, SUCCESS }

abstract class TaskData {
  bool answerShowed = false;
  TaskStatus status = TaskStatus.CLEAN;

  TaskData.newRandom(Settings settings);

  int getAnswer();

  bool isCorrect(int answer) {
    return answer == getAnswer();
  }

  Task createTask();
}

abstract class Task extends StatelessWidget {
  final TaskData data;

  Task(this.data);

  Widget buildQuestion(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Row(
//        mainAxisAlignment: MainAxisAlignment.center,
//        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Flexible(
            child: buildQuestion(context),
          ),
          new Text(' = '),
          new Flexible(
            child: new Stack(
              children: <Widget>[
                new Opacity(opacity: data.answerShowed ? 1.0 : 0.0, child: new Text(data.getAnswer().toString())),
                new Opacity(opacity: data.answerShowed ? 0.0 : 1.0, child: new Text('?')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
