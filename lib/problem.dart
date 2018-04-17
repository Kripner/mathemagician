import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mathemagician/settings.dart';
import 'package:mathemagician/tasks/task_data_supplier.dart';
import 'package:mathemagician/utils.dart';
import 'package:mathemagician/tasks/task.dart';

class Problem extends StatefulWidget {
  final String failureMessage = 'Not quite right';
  final String successMessage = 'Good job!';

  final Settings _settings;
  final Consumer<int> _onSolve;
  final TaskData _taskData;
  final int _index;

  Problem(this._settings, this._taskData, this._onSolve, this._index);

  @override
  _ProblemState createState() => new _ProblemState();
}

class _ProblemState extends State<Problem> {
  TextEditingController _inputController;

  void _showAnswer() {
    setState(() {
      widget._taskData.answerShowed = true;
    });
  }

  void setFailureInfo() {
    setState(() {
      widget._taskData.status = TaskStatus.FAILURE;
    });
  }

  void setSuccessInfo() {
    setState(() {
      widget._taskData.status = TaskStatus.SUCCESS;
    });
  }

  void numberSubmitted(String value) {
    if (value.isEmpty) return;
    int answer = int.parse(value, onError: doNothing);
    bool isCorrect = widget._taskData.isCorrect(answer);

    if (isCorrect) {
      setSuccessInfo();
      print('Correct!');
      widget._onSolve(widget._index);
    } else {
      setFailureInfo();
      print('Incorrect');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.all(10.0),
      child: new Column(
        children: <Widget>[
          new Flexible(
            child: widget._taskData.createTask(),
          ),
          _buildUserInfo(),
          new TextField(
            controller: _inputController,
            autocorrect: false,
            keyboardType: TextInputType.number,
            onSubmitted: numberSubmitted,
          )
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    switch (widget._taskData.status) {
      case TaskStatus.CLEAN:
        return new Text('');
      case TaskStatus.FAILURE:
        return new Row(
          children: <Widget>[
            new Text(widget.failureMessage),
            new IconButton(icon: new Icon(Icons.lightbulb_outline), onPressed: _showAnswer)
          ],
        );
      case TaskStatus.SUCCESS:
        return new Text(widget.successMessage);
      default:
        throw new Exception();
    }
  }
}
