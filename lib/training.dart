import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mathemagician/infinite_widget_list.dart';
import 'package:mathemagician/problem.dart';
import 'package:mathemagician/settings.dart';
import 'package:mathemagician/settings_storage.dart';
import 'package:mathemagician/settings_view.dart';
import 'package:mathemagician/tasks/task.dart';
import 'package:mathemagician/tasks/task_data_supplier.dart';
import 'package:mathemagician/utils.dart';

class Training extends StatefulWidget {
  static const int TAB_BAR_LENGTH = 1000;
  static const int PROBLEMS_BATCH_SIZE = 5;

  final Settings settings;

  Training(this.settings);

  @override
  _TrainingState createState() => new _TrainingState();
}

class _TrainingState extends State<Training> with TickerProviderStateMixin {
  InfiniteWidgetList<Problem> _problems;
  TabController _currentTabController;
  AnimationController _forwardArrowAnimation;
  AnimationController _progressAnimation;

  @override
  void initState() {
    super.initState();
    _problems = new InfiniteWidgetList(
      Training.TAB_BAR_LENGTH,
      (index) => randomTaskData(widget.settings),
      (index, data) => new Problem(widget.settings, data, handleSolved, index),
    );
    _currentTabController = new TabController(vsync: this, length: Training.TAB_BAR_LENGTH);
    _forwardArrowAnimation = new AnimationController(vsync: this, duration: new Duration(milliseconds: 750));
    _progressAnimation = new AnimationController(vsync: this, duration: new Duration(milliseconds: 500));
  }

  void handleSolved(int index) {
    print('Animating to ${index + 1}');
    _handleProgress();
    if (widget.settings.jumpAfterSolve.val) {
      new Future.delayed(new Duration(seconds: 1), () {
        _currentTabController.animateTo(index + 1);
//        _checkForwardArrow();
      });
    }
  }

  void _handleProgress() {
    widget.settings.problemsSolved.val++;
    double progressValue =
        (widget.settings.problemsSolved.val % (Training.PROBLEMS_BATCH_SIZE + 1)) / Training.PROBLEMS_BATCH_SIZE;
    print(progressValue);
    _progressAnimation.animateTo(progressValue).then((_) {
      if (progressValue == 1) {
        setState(() {
          widget.settings.rainbows.val++;
        });
        new Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            _progressAnimation.value = 0.0;
          });
        });
      }
    });
  }

  void _checkForwardArrow() {
    if (_currentTabController.index < _problems.realLength - 2) {
      _forwardArrowAnimation.animateTo(1.0);
    } else {
      _forwardArrowAnimation.animateTo(0.0);
    }
  }

  @override
  void dispose() {
    _forwardArrowAnimation.dispose();
    _progressAnimation.dispose();
    _currentTabController.dispose();
    super.dispose();
  }

  void _showSettings() async {
    await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new SettingsView(widget.settings)),
    );
  }

  @override
  Widget build(BuildContext context) {
    _currentTabController.addListener(() {
      _checkForwardArrow();
    });

    double iconSize = 100.0;
    return new Scaffold(
      appBar: new AppBar(
        actions: <Widget>[new FlatButton(onPressed: _showSettings, child: new Icon(Icons.settings))],
      ),
      body: new Column(
        children: <Widget>[
          _buildProgressMeter(),
          new Expanded(
            child: new Stack(
              children: <Widget>[
                new TabBarView(
                  controller: _currentTabController,
                  children: _problems,
                ),
                new Positioned(
                  right: 7.0,
                  bottom: (MediaQuery.of(context).size.height - iconSize) / 2,
                  child: new FadeTransition(
                    opacity: _forwardArrowAnimation,
                    child: new IconButton(
                      iconSize: iconSize,
                      color: Colors.grey,
                      icon: new Icon(Icons.keyboard_arrow_right),
                      onPressed: () {
                        _currentTabController.animateTo(_problems.realLength);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressMeter() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new Flexible(
            child: new LinearProgressIndicator(
              value: _progressAnimation.value,
            ),
          ),
          new Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
            child: new Text(rainbow),
          ),
          new Text(
            widget.settings.rainbows.val.toString().padLeft(1),
            style: Theme.of(context).textTheme.body2.copyWith(fontSize: 25.0),
          ),
        ],
      ),
    );
  }
}
