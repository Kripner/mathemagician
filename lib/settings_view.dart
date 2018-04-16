import 'package:flutter/material.dart';
import 'package:mathemagician/settings.dart';
import 'package:mathemagician/tasks/task_data_supplier.dart';

class SettingsView extends StatefulWidget {
  final Settings settings;

  SettingsView(this.settings);

  @override
  _SettingsViewState createState() => new _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  Map<TasksGroup, bool> _groupsExpanded;

  @override
  void initState() {
    super.initState();
    _groupsExpanded = new Map.fromIterable(tasksGroups, value: (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    Settings settings = widget.settings;
    bool useDifficulty = settings.useDifficulty.val;
    return new Scaffold(
        appBar: new AppBar(
          actions: <Widget>[
            new FlatButton(
              onPressed: null,
              child: new Icon(Icons.done),
            )
          ],
        ),
        body: new SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0),
          child: new Column(
            children: <Widget>[
              new Text('Difficulty'),
              _buildDifficultySlider(settings, useDifficulty),
              new Divider(
                color: Colors.grey,
                height: 50.0,
              ),
              _buildDifficultyCheckBox(settings),
              _buildTasksSelector(settings, !useDifficulty),
            ],
          ),
        ));
  }

  Widget _buildDifficultySlider(Settings settings, bool enabled) {
    return new Slider(
      label: settings.difficulty.val.toString(),
      value: settings.difficulty.val.toDouble(),
      min: settings.difficulty.min.toDouble(),
      max: settings.difficulty.max.toDouble(),
      divisions: settings.difficulty.max - settings.difficulty.min,
      onChanged: enabled ? (newVal) => setState(() => settings.difficulty.val = newVal.toInt()) : null,
    );
  }

  Widget _buildDifficultyCheckBox(Settings settings) {
    return new Row(
      children: <Widget>[
        new Checkbox(
          value: !settings.useDifficulty.val,
          onChanged: (bool value) {
            setState(() {
              settings.useDifficulty.val = !value;
            });
          },
        ),
        new Expanded(
          child: new Text('Select problems individually instead?'),
        ),
      ],
    );
  }

  Widget _buildTasksSelector(Settings settings, bool enabled) {
    return new ExpansionPanelList(
      children: tasksGroups.map((TasksGroup g) => _buildTasksGroup(settings, g, enabled)).toList(growable: false),
      expansionCallback: (int panelIndex, bool isExpanded) => setState(() {
            _groupsExpanded[tasksGroups[panelIndex]] = !isExpanded;
          }),
    );
  }

  ExpansionPanel _buildTasksGroup(Settings settings, TasksGroup group, bool enabled) {
    return new ExpansionPanel(
      isExpanded: _groupsExpanded[group],
      headerBuilder: (BuildContext context, bool isExpanded) => new Center(
            child: new Row(
              children: <Widget>[
                new Checkbox(
                  value: settings.selectedGroups.val[group.id],
                  onChanged: enabled
                      ? (bool value) => setState(() {
                            settings.selectedGroups.val[group.id] = value;
                          })
                      : null,
                ),
                new Text(group.niceName, style: enabled ? null : new TextStyle(color: Theme.of(context).disabledColor))
              ],
            ),
          ),
      body: new Column(
        children: group.tasks.map((TaskContainer task) => _buildTask(settings, task, enabled)).toList(growable: false),
      ),
    );
  }

  Widget _buildTask(Settings settings, TaskContainer task, bool enabled) {
    return new Row(
      children: <Widget>[
        new Checkbox(
          value: settings.selectedTasks.val[task.id],
          onChanged: enabled
              ? (bool value) => setState(() {
                    settings.selectedTasks.val[task.id] = value;
                  })
              : null,
        ),
        task.niceName.createExpression(style: enabled ? null : new TextStyle(color: Theme.of(context).disabledColor)),
      ],
    );
  }
}
