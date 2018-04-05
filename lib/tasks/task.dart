import 'package:flutter/material.dart';
import 'package:mathemagician/settings.dart';

abstract class Task extends StatefulWidget {
  // confused? See https://stackoverflow.com/questions/46057353/controlling-state-from-outside-of-a-statefulwidget
//  static State<StatefulWidget> of<T extends StatefulWidget, S extends State<T>>(BuildContext context) => context.ancestorStateOfType(const TypeMatcher<S>());

  final Settings settings;

//  final double questionFontSize = 50.0;

  Task(this.settings);

  bool checkAnswer(int answer);

  int getAnswer();

  void showAnswer();

}

abstract class TaskState<T extends Task> extends State<T> {
  bool _showAnswer = false;

  void showAnswer() {
    setState(() {
      _showAnswer = true;
    });
  }

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
                new Opacity(opacity: _showAnswer ? 1.0 : 0.0, child: new Text(widget.getAnswer().toString())),
                new Opacity(opacity: _showAnswer ? 0.0 : 1.0, child: new Text('?')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
