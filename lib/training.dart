import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mathemagician/infinite_widget_list.dart';
import 'package:mathemagician/problem.dart';
import 'package:mathemagician/settings.dart';
import 'package:mathemagician/tasks/task_data_supplier.dart';

class Training extends StatefulWidget {
  final int tabBarLength = 100;
  final Settings settings;

  Training(this.settings);

  @override
  _TrainingState createState() => new _TrainingState();
}

class _TrainingState extends State<Training> with SingleTickerProviderStateMixin {
  InfiniteWidgetList<Problem> _problems;
  TabController _currentTabController;

  @override
  void initState() {
    super.initState();
    _problems = new InfiniteWidgetList(
      widget.tabBarLength,
      (index) => randomTaskData(widget.settings),
      (index, data) => new Problem(widget.settings, data, handleSolved, index),
    );
    _currentTabController = new TabController(vsync: this, length: widget.tabBarLength);
  }

  void handleSolved(int index) {
    print('Animating to ${index + 1}');
    if (widget.settings.jumpAfterSolve.val) {
      new Future.delayed(new Duration(seconds: 1), () {
        _currentTabController.animateTo(index + 1);
      });
    }
  }

  @override
  void dispose() {
    _currentTabController.dispose();
    super.dispose();
  }

  void _showSettings() async {
    await Navigator.pushNamed(context, 'settings');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        actions: <Widget>[new FlatButton(onPressed: _showSettings, child: new Icon(Icons.settings))],
      ),
      body: new TabBarView(
        controller: _currentTabController,
        children: _problems,
      ),
    );
  }
}
