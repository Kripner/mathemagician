import 'package:flutter/material.dart';
import 'package:mathemagician/checkbox_with_label.dart';
import 'package:mathemagician/settings.dart';
import 'package:mathemagician/tasks/task_data_supplier.dart';
import 'package:mathemagician/utils.dart';

class SettingsView extends StatefulWidget {
  final Settings settings;

  SettingsView(this.settings);

  @override
  _SettingsViewState createState() => new _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  Map<TasksGroup, bool> _groupsExpanded;

  @override
  void initState() {
    super.initState();
    _groupsExpanded = new Map.fromIterable(tasksGroups, value: (_) => false);
    widget.settings.visitedSettings.val = true;
  }

  @override
  Widget build(BuildContext context) {
    Settings settings = widget.settings;
    bool useDifficulty = settings.useDifficulty.val;
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text('Settings'),
      ),
      body: new SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
        child: new Column(
          children: <Widget>[
            new Text('Difficulty: ' + settings.difficulty.val.toString()),
            _buildDifficultySlider(settings, useDifficulty),
            new Divider(color: Colors.grey, height: 50.0),
            _buildDifficultyCheckBox(settings),
            _buildTasksSelector(settings, !useDifficulty),
            new Divider(color: Colors.grey, height: 50.0),
            _buildJumpAfterSolvedCheckbox(settings),
            new Divider(color: Colors.grey, height: 50.0),
            _buildResetProgressButton(settings),
          ],
        ),
      ),
    );
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

  Widget _buildResetProgressButton(Settings settings) {
    return new Row(
      children: <Widget>[
        new OutlineButton(
          onPressed: settings.problemsSolved.val == 0 ? null : _resetProgress,
          child: new Text('Reset my progress'),
        ),
      ],
    );
  }

  void _resetProgress() async {
    bool reset = await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
            title: new Text("Reset progress"),
            content: new Text(
                "Do your really want to reset your progress?\nThis action can't be taken back and you will lose all your rainbows."),
            actions: <Widget>[
              new OutlineButton(
                child: new Text('Cancel'),
                onPressed: () => Navigator.pop(context, false),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: new OutlineButton(
                  child: new Text('Reset my progress'),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ),
            ],
            contentPadding: const EdgeInsets.all(20.0),
          ),
    );
    if (reset != null && reset) {
      widget.settings.resetProgress();
      scaffoldKey.currentState.showSnackBar(new SnackBar(
            content: new Text('Your progress has been reseted'),
          ));
    }
  }
}
