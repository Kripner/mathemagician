import 'package:flutter/material.dart';
import 'package:mathemagician/checkbox_with_label.dart';
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
        appBar: new AppBar(),
        body: new SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
          child: new Column(
            children: <Widget>[
              new Text('Difficulty'),
              _buildDifficultySlider(settings, useDifficulty),
              new Divider(color: Colors.grey, height: 50.0),
              _buildDifficultyCheckBox(settings),
              _buildTasksSelector(settings, !useDifficulty),
              new Divider(color: Colors.grey, height: 50.0),
              _buildJumpAfterSolvedCheckbox(settings),
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
      headerBuilder: (BuildContext context, bool isExpanded) => new CheckboxWithLabel(
            value: settings.selectedGroups.val[group.id],
            onChanged: enabled
                ? (bool value) => setState(() {
                      settings.selectedGroups.val[group.id] = value;
                    })
                : null,
            label:
                new Text(group.niceName, style: enabled ? null : new TextStyle(color: Theme.of(context).disabledColor)),
          ),
      body: new Column(
        children: group.tasks
            .map((TaskContainer task) => _buildTaskCheckbox(settings, task, enabled))
            .toList(growable: false),
      ),
    );
  }

  Widget _buildTaskCheckbox(Settings settings, TaskContainer task, bool enabled) {
    return new CheckboxWithLabel(
      value: settings.selectedTasks.val[task.id],
      onChanged: enabled
          ? (bool value) => setState(() {
                settings.selectedTasks.val[task.id] = value;
              })
          : null,
      label:
          task.niceName.createExpression(style: enabled ? null : new TextStyle(color: Theme.of(context).disabledColor)),
    );
  }

  Widget _buildJumpAfterSolvedCheckbox(Settings settings) {
    return new CheckboxWithLabel(
      value: settings.jumpAfterSolve.val,
      onChanged: (bool value) {
        setState(() {
          settings.jumpAfterSolve.val = value;
        });
      },
      label: new Text('Jump to next problem after solving the previous?'),
    );
  }
}
