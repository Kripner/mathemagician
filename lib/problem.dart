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
  FocusNode _inputFocusNode;


  @override
  void initState() {
    super.initState();
    _inputFocusNode = new FocusNode();
  }


  @override
  void dispose() {
    _inputFocusNode.dispose();
    super.dispose();
  }

  void _showAnswer() {
    setState(() {
      widget._taskData.answerShowed = true;
    });
  }

  void _setFailureInfo() {
    setState(() {
      widget._taskData.status = TaskStatus.FAILURE;
    });
  }

  void _setSuccessInfo() {
    setState(() {
      widget._taskData.status = TaskStatus.SUCCESS;
    });
  }

  void _numberSubmitted(String value) {
    if (value.isEmpty) return;
    int answer = int.parse(value, onError: doNothing);
    bool isCorrect = widget._taskData.isCorrect(answer);

    if (isCorrect) {
      _setSuccessInfo();
      _showAnswer();
      print('Correct!');
      widget._onSolve(widget._index);
    } else {
      _setFailureInfo();
      print('Incorrect');
    }
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(_inputFocusNode);
    TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle taskStyle = textTheme.headline;

    return new Padding(
      padding: new EdgeInsets.all(10.0),
      child: new Column(
        children: <Widget>[
          new Flexible(
              child: new Center(
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Flexible(
                  child: widget._taskData.buildExpression().createExpression(style: taskStyle),
                ),
                new Padding(
                  padding: new EdgeInsets.symmetric(horizontal: 5.0),
                  child: new Text('=', style: taskStyle),
                ),
                new Flexible(
                  child: new Stack(
                    children: <Widget>[
                      new Opacity(
                          opacity: widget._taskData.answerShowed ? 1.0 : 0.0,
                          child: new Text(widget._taskData.getAnswer().toString(), style: taskStyle)),
                      new Opacity(
                        opacity: widget._taskData.answerShowed ? 0.0 : 1.0,
                        child: new TextField(
                          autocorrect: false,
                          keyboardType: TextInputType.number,
                          onSubmitted: _numberSubmitted,
//                          autofocus: true,
                          style: taskStyle,
                          focusNode: _inputFocusNode,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
          _buildUserInfo(),
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
          mainAxisAlignment: MainAxisAlignment.center,
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
