import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mathemagician/infinite_widget_list.dart';
import 'package:mathemagician/problem.dart';
import 'package:mathemagician/rainbows_counter.dart';
import 'package:mathemagician/settings.dart';
import 'package:mathemagician/settings_storage.dart';
import 'package:mathemagician/settings_view.dart';
import 'package:mathemagician/tasks/task_data.dart';
import 'package:mathemagician/tasks/task_data_supplier.dart';
import 'package:mathemagician/user_suggestion.dart';
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
  bool _shouldShowSettingsTooltip = false;

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
    _progressAnimation.value = _calculateProgress();

    widget.settings.problemsSeen.val++;
    _currentTabController.addListener(() {
      _shouldShowSettingsTooltip = false;
      _checkForwardArrow();
      if (_currentTabController.index == _problems.realLength - 1) {
        widget.settings.problemsSeen.val++;
        _checkSettingsTooltip();
        print('problem ${widget.settings.problemsSeen.val}\n');
      }
    });
    _progressAnimation.addListener(() => setState(() {}));
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
    double progressValue = _calculateProgress();
    print(progressValue);
    _progressAnimation.animateTo(progressValue == 0.0 ? 1.0 : progressValue).then((_) {
      if (widget.settings.problemsSolved.val % Training.PROBLEMS_BATCH_SIZE == 0) {
        setState(() {
          widget.settings.rainbows.val++;
        });
        new Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            _progressAnimation.value = 0.0;
          });
        });
      }
    }).catchError((e) => print(e));
  }

  _calculateProgress() =>
      (widget.settings.problemsSolved.val % Training.PROBLEMS_BATCH_SIZE) / Training.PROBLEMS_BATCH_SIZE;

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
    double iconSize = 100.0;
    return new Scaffold(
      appBar: new AppBar(
        actions: <Widget>[
          new IconButton(
            onPressed: _showSettings,
            icon: new UserSuggestionOptional(
              child: new Icon(Icons.settings),
              text: 'You can control which types of problems are shown',
              showText: _shouldShowSettingsTooltip,
            ),
          ),
        ],
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
      padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new Flexible(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  height: 8.0,
                  child: new LinearProgressIndicator(
                    value: _progressAnimation.value,
                  ),
                ),

              ],
            ),
          ),
          new Padding(
            child: new Hero(
              child: new RainbowCounter(rainbowsCount: widget.settings.rainbows.val),
              tag: 'rainbow-counter',
            ),
            padding: const EdgeInsets.only(left: 15.0),
          )
        ],
      ),
    );
  }

  void _checkSettingsTooltip() {
    if (widget.settings.problemsSeen.val == 3) {
      setState(() {
        _shouldShowSettingsTooltip = true;
        print('showing settings tooltip');
      });
    } else {
      setState(() {
        _shouldShowSettingsTooltip = false;
      });
    }
  }
}
