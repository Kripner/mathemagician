import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mathemagician/infinite_widget_list.dart';
import 'package:mathemagician/problem.dart';
import 'package:mathemagician/settings.dart';
import 'package:mathemagician/tasks/task.dart';
import 'package:mathemagician/tasks/task_data_supplier.dart';

class Training extends StatefulWidget {
  final int tabBarLength = 1000;
  final Settings settings;

  Training(this.settings);

  @override
  _TrainingState createState() => new _TrainingState();
}

class _TrainingState extends State<Training> with TickerProviderStateMixin {
  InfiniteWidgetList<Problem> _problems;
  TabController _currentTabController;
  AnimationController _forwardArrowAnimation;

  @override
  void initState() {
    super.initState();
    _problems = new InfiniteWidgetList(
      widget.tabBarLength,
      (index) => randomTaskData(widget.settings),
      (index, data) => new Problem(widget.settings, data, handleSolved, index),
    );
    _currentTabController = new TabController(vsync: this, length: widget.tabBarLength);
    _forwardArrowAnimation = new AnimationController(vsync: this, duration: new Duration(milliseconds: 750));
  }

  void handleSolved(int index) {
    print('Animating to ${index + 1}');
    if (widget.settings.jumpAfterSolve.val) {
      new Future.delayed(new Duration(seconds: 1), () {
        _currentTabController.animateTo(index + 1);
//        _checkForwardArrow();
      });
    }
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
    _currentTabController.dispose();
    super.dispose();
  }

  void _showSettings() async {
    await Navigator.pushNamed(context, 'settings');
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
      body: new Stack(
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
    );
  }

//  @override
//  Widget build(BuildContext context) {
//    Widget problemsView = new TabBarView(
//      controller: _currentTabController,
//      children: _problems,
//    );
//    if (_currentTabController.index < _problems.realLength - 1) {
//      print('ahaa');
//      problemsView = new Stack(
//        children: <Widget>[
//          new IconButton(
//            icon: new Icon(Icons.arrow_forward),
//            onPressed: () => _currentTabController.animateTo(_problems.realLength),
//          ),
//          problemsView,
//        ],
//      );
//    }
//    _currentTabController.addListener(() {
//      print('listener');
//      // TODO: might register more (redundant) listeners
//      if (_currentTabController.indexIsChanging) {
//        setState(() {});
//        print('changing');
//      }
//    });
//    return new Scaffold(
//      appBar: new AppBar(
//        actions: <Widget>[new FlatButton(onPressed: _showSettings, child: new Icon(Icons.settings))],
//      ),
//      body: problemsView,
//    );
//  }
}
