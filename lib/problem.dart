import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mathemagician/settings.dart';
import 'package:mathemagician/tasks/tasks_supplier.dart';
import 'package:mathemagician/utils.dart';
import 'package:mathemagician/tasks/task.dart';

class Problem extends StatefulWidget {
  final String failureMessage = 'Not quite right';
  final String successMessage = 'Good job!';

  final Settings settings;
  final Consumer<int> onSolve;
  final int index;
  final TaskManager _taskManager;
  Task _task;

  Problem(this.settings, this.onSolve, this.index, {Key key})
      : _taskManager = randomTask(settings),
        super(key: key) {
    _task = _taskManager.supplier(settings);
  }

  @override
  _ProblemState createState() => new _ProblemState();
}

class _ProblemState extends State<Problem> {
  TextEditingController _inputController;
  Widget _userInfoWidget = new Text('');

  @override
  void initState() {
    super.initState();
  }

  void _showAnswer() {
    widget._task.showAnswer();
  }

  void setFailureInfo() {
    setState(() {
      _userInfoWidget = new Row(
        children: <Widget>[
          new Text(widget.failureMessage),
          new IconButton(icon: new Icon(Icons.lightbulb_outline), onPressed: _showAnswer)
        ],
      );
    });
  }

  void setSuccessInfo() {
    setState(() {
      _userInfoWidget = new Text(widget.successMessage);
    });
  }

  void numberSubmitted(String value) {
    if (value.isEmpty) return;
    int answer = int.parse(value, onError: doNothing);
    bool isCorrect = widget._task.checkAnswer(answer);

    if (isCorrect) {
      setSuccessInfo();
      print('Correct!');
    } else {
      setFailureInfo();
      print('Incorrect');
    }
    PageStorage.of(context).writeState(context, _userInfoWidget, identifier: widget.index);
//    widget.onSolve(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    Widget userInfoWidget = PageStorage.of(context).readState(context, identifier: widget.index);
    return new Padding(
      padding: new EdgeInsets.all(10.0),
      child: new Column(
        children: <Widget>[
          new Flexible(
            child: widget._task,
          ),
          userInfoWidget ?? new Text(''),
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
}
