import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mathemagician/settings.dart';
import 'package:mathemagician/tasks/task_data_supplier.dart';
import 'package:mathemagician/utils.dart';
import 'package:mathemagician/tasks/task_data.dart';

class Problem extends StatefulWidget {
  final String failureMessage = 'Not quite right';
  final String successMessage = 'Good job!';

  final TaskData taskData;
  final Settings _settings;
  final Consumer<int> _onSolve;
  final int _index;

  Problem(this._settings, this.taskData, this._onSolve, this._index);

  @override
  _ProblemState createState() => new _ProblemState();
}

class _ProblemState extends State<Problem> {
  FocusNode _inputFocusNode;
  TextEditingController _inputController;

  @override
  void initState() {
    super.initState();
    print(widget.taskData.userInput);
    _inputController = new TextEditingController(text: widget.taskData.userInput);
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
      widget.taskData.answerShown = true;
      widget.taskData.status = TaskStatus.SHOWED_ANSWER;
    });
  }

  void _failure() {
    setState(() {
      widget.taskData.status = TaskStatus.FAILURE;
    });
  }

  void _success() {
    setState(() {
      _inputFocusNode.unfocus();
      widget.taskData.answerShown = true;
      widget.taskData.status = TaskStatus.SUCCESS;
    });
  }

  void _resetInfo() {
    setState(() {
      widget.taskData.status = TaskStatus.CLEAN;
    });
  }

  void _numberSubmitted(String value) {
    if (value.isEmpty) return;
    int answer;
    try {
      answer = int.parse(value);
    } on FormatException {
      return;
    }
    widget.taskData.lastSubmittedInput = value;
    bool isCorrect = widget.taskData.isCorrect(answer);

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
    if (widget.taskData.status != TaskStatus.SUCCESS) FocusScope.of(context).requestFocus(_inputFocusNode);
    TextTheme textTheme = Theme.of(context).textTheme;

    return new Padding(
      padding: new EdgeInsets.all(10.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildUserInfo(textTheme.headline),
          new Flexible(
            flex: 1,
            child: new Container(),
          ),
          _buildLayoutTable(),
          new Flexible(
            flex: 3,
            child: new Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildLayoutTable() {
    TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle taskStyle = textTheme.display1.copyWith(fontSize: 35.0);
    return new Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        new TableRow(
          children: <Widget>[
            _buildQuestionRow(taskStyle),
            _buildAnswer(taskStyle),
          ],
        ),
        new TableRow(
          children: <Widget>[
            new Padding(
              child: new Text(
                'Difficulty ' + widget.taskData.difficulty.toString(),
                style: Theme.of(context).textTheme.body2.copyWith(fontSize: 18.0),
              ),
              padding: const EdgeInsets.fromLTRB(20.0, 7.0, 0.0, 0.0),
            ),
            new Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: _buildMistakeDisplay(textTheme.caption.copyWith(fontSize: 18.0)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuestionRow(TextStyle taskStyle) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        widget.taskData.buildExpression().createExpression(style: taskStyle),
        new Padding(
          padding: new EdgeInsets.symmetric(horizontal: 5.0),
          child: new Text('=', style: taskStyle),
        ),
      ],
    );
  }

  Widget _buildAnswer(TextStyle taskStyle) {
    return new Stack(
      alignment: AlignmentDirectional.centerStart,
      children: <Widget>[
        new Opacity(
            opacity: widget.taskData.answerShown ? 1.0 : 0.0,
            child: new Text(widget.taskData.getAnswer().toString(), style: taskStyle)),
        new Opacity(
          opacity: widget.taskData.answerShown ? 0.0 : 1.0,
          child: new TextField(
            autocorrect: false,
            keyboardType: TextInputType.number,
            onSubmitted: _numberSubmitted,
            style: taskStyle,
            focusNode: _inputFocusNode,
            controller: _inputController,
            onChanged: (s) {
              _resetInfo();
              widget.taskData.userInput = s;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMistakeDisplay(TextStyle style) {
    if (widget.taskData.status != TaskStatus.SHOWED_ANSWER || widget.taskData.lastSubmittedInput.isEmpty)
      return new Opacity(
        child: new Text('Calculating ...'),
        opacity: 0.0,
      );
    return new Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: new Text(
        widget.taskData.lastSubmittedInput,
        style: style.copyWith(color: Colors.red, decoration: TextDecoration.lineThrough, fontStyle: FontStyle.italic),
      ),
    );
  }

  Widget _buildUserInfo(TextStyle style) {
    switch (widget.taskData.status) {
      case TaskStatus.CLEAN:
      case TaskStatus.SHOWED_ANSWER:
        // because I need the text to take vertical space even when empty
        return new Opacity(opacity: 0.0, child: new Text('Mathemagics', style: style));
      case TaskStatus.FAILURE:
        return new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              widget.failureMessage,
              style: style,
            ),
            new Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: new GestureDetector(
                child: new Icon(Icons.lightbulb_outline),
                onTap: _showAnswer,
              ),
            ),
          ],
        );
      case TaskStatus.SUCCESS:
        return new Text(
          widget.successMessage,
          style: style,
          textAlign: TextAlign.center,
        );
      default:
        throw new Exception();
    }
  }
}
