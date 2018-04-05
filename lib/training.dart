import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mathemagician/infinite_widget_list.dart';
import 'package:mathemagician/problem.dart';
import 'package:mathemagician/settings.dart';

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
    _problems =
        new InfiniteWidgetList(widget.tabBarLength, (index) => new Problem(widget.settings, handleSolved, index));
    _currentTabController = new TabController(vsync: this, length: widget.tabBarLength);
  }

  void handleSolved(int index) {
    print('Animating to ${index + 1}');
    _currentTabController.animateTo(index + 1);
  }

  @override
  void dispose() {
    _currentTabController.dispose();
    super.dispose();
  }

  void _showSettings() async {
    var val = await Navigator.pushNamed(context, 'settings');
    print(val);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        actions: <Widget>[
          new FlatButton(onPressed: _showSettings, child: new Icon(Icons.settings))
        ],
      ),
      body: new TabBarView(
        controller: _currentTabController,
        children: _problems,
      ),
    );
  }
}
