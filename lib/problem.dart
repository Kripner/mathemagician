import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mathemagician/settings.dart';
import 'package:mathemagician/tasks/task_data_supplier.dart';
import 'package:mathemagician/utils.dart';
import 'package:mathemagician/tasks/task_data.dart';

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
  TextEditingController _inputController;

  @override
  void initState() {
    super.initState();
    print(widget._taskData.userInput);
    _inputController = new TextEditingController(text: widget._taskData.userInput);
    _inputFocusNode = new FocusNode();
  }

  @override
  void dispose() {
    _inputFocusNode.dispose();
    _inputController.dispose();
    super.dispose();
  }

  void _showAnswer() {
    setState(() {
      _inputFocusNode.unfocus();
      widget._taskData.answerShown = true;
      widget._taskData.status = TaskStatus.SHOWED_ANSWER;
    });
  }

  void _failure() {
    setState(() {
      widget._taskData.status = TaskStatus.FAILURE;
    });
  }

  void _success() {
    setState(() {
      _inputFocusNode.unfocus();
      widget._taskData.answerShown = true;
      widget._taskData.status = TaskStatus.SUCCESS;
    });
  }

  void _resetInfo() {
    setState(() {
      widget._taskData.status = TaskStatus.CLEAN;
    });
  }

  void _numberSubmitted(String value) {
    if (value.isEmpty) return;
    widget._taskData.lastSubmittedInput = value;
    int answer = int.parse(value, onError: doNothing);
    bool isCorrect = widget._taskData.isCorrect(answer);

    if (isCorrect) {
      _success();
      print('Correct!');
      widget._onSolve(widget._index);
    } else {
      _failure();
      print('Incorrect');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget._taskData.status == TaskStatus.CLEAN) FocusScope.of(context).requestFocus(_inputFocusNode);
    TextTheme textTheme = Theme.of(context).textTheme;

    return new Padding(
      padding: new EdgeInsets.all(10.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildUserInfo(textTheme.headline),
          new Flexible(
            flex: 2,
            child: new Center(child: _buildExpression(textTheme.display1.copyWith(fontSize: 35.0))),
          ),
          new Flexible(flex: 1, child: new Container(),),
        ],
      ),
    );
  }

  Row _buildExpression(TextStyle taskStyle) {
    return new Row(
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
            alignment: AlignmentDirectional.centerStart,
            children: <Widget>[
              new Opacity(
                  opacity: widget._taskData.answerShown ? 1.0 : 0.0,
                  child: new Text(widget._taskData.getAnswer().toString(), style: taskStyle)),
              new Opacity(
                opacity: widget._taskData.answerShown ? 0.0 : 1.0,
                child: new TextField(
                  autocorrect: false,
                  keyboardType: TextInputType.number,
                  onSubmitted: _numberSubmitted,
                  style: taskStyle,
                  focusNode: _inputFocusNode,
                  controller: _inputController,
                  onChanged: (s) {
                    _resetInfo();
                    widget._taskData.userInput = s;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

//
//  Widget _buildAnswer(TextStyle style) {
//    return new Column(
//      children: <Widget>[
//        new Text(widget._taskData.getAnswer().toString(), style: style),
//        new Text(widget._taskData.getAnswer().toString(), style: style),
//      ],
//    );
//  }

  Widget _buildUserInfo(TextStyle style) {
    switch (widget._taskData.status) {
      case TaskStatus.CLEAN:
      case TaskStatus.SHOWED_ANSWER:
        return new Text(' ');
      case TaskStatus.FAILURE:
        return new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              widget.failureMessage,
              style: style,
            ),
            new IconButton(icon: new Icon(Icons.lightbulb_outline), onPressed: _showAnswer)
          ],
        );
      case TaskStatus.SUCCESS:
        return new Text(widget.successMessage, style: style);
      default:
        throw new Exception();
    }
  }
}
