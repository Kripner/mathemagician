import 'dart:math';

import 'package:mathemagician/math_expression.dart';
import 'package:mathemagician/settings.dart';
import 'package:mathemagician/tasks/multiplication_task.dart';
import 'package:mathemagician/tasks/square_task.dart';
import 'package:mathemagician/tasks/task_data.dart';

typedef D DataSupplier<D extends TaskData>();

class TaskContainer {
  final MathExpression niceName;
  final DataSupplier _supplier;
  final String id;
  final int _minDifficulty;
  final int _maxDifficulty;

  TaskContainer(this._supplier, this.id, this.niceName, this._minDifficulty, this._maxDifficulty);
}

class TasksGroup {
  final String niceName;
  final String description;
  final String id;
  final List<TaskContainer> tasks;

  TasksGroup(this.id, this.niceName, this.description, this.tasks);
}

// @formatter:off
List<TasksGroup> tasksGroups = [
  new TasksGroup('squaring', 'Squaring', 'Square numbers instantly in your head like a boss', [
    new TaskContainer(() => new SquareTaskData.random(1), '1-digit-squaring', new MathExpression('1', superscript: '2'), 1, 1),
    new TaskContainer(() => new SquareTaskData.random(2), '2-digit-squaring', new MathExpression('10', superscript: '2'), 2, 3),
    new TaskContainer(() => new SquareTaskData.random(3), '3-digit-squaring', new MathExpression('100', superscript: '2'), 4, 5),
    new TaskContainer(() => new SquareTaskData.random(4), '4-digit-squaring', new MathExpression('1000', superscript: '2'), 6, 7),
    new TaskContainer(() => new SquareTaskData.random(4), '5-digit-squaring', new MathExpression('10000', superscript: '2'), 8, 9),
    new TaskContainer(() => new SquareTaskData.random(4), '6-digit-squaring', new MathExpression('100000', superscript: '2'), 10, 10),
  ]),
  new TasksGroup('multiplication', 'Multiplication', 'Multiplying numbers is considered sexy, latest study shows', [
    new TaskContainer(() => new MultiplicationTaskData.random(1, 1), '1x1-multiplication', new MathExpression('1x1'), 1, 1),
    new TaskContainer(() => new MultiplicationTaskData.random(2, 1), '2x1-multiplication', new MathExpression('1x10'), 1, 2),
    new TaskContainer(() => new MultiplicationTaskData.random(3, 1), '3x1-multiplication', new MathExpression('1x100'), 2, 3),
    new TaskContainer(() => new MultiplicationTaskData.random(4, 1), '4x1-multiplication', new MathExpression('1x1000'), 3, 4),
    new TaskContainer(() => new MultiplicationTaskData.random(5, 1), '5x1-multiplication', new MathExpression('1x10000'), 5, 6),
    new TaskContainer(() => new MultiplicationTaskData.random(6, 1), '6x1-multiplication', new MathExpression('1x100000'), 6, 7),
    new TaskContainer(() => new MultiplicationTaskData.random(2, 2), '2x2-multiplication', new MathExpression('10x10'), 3, 4),
    new TaskContainer(() => new MultiplicationTaskData.random(2, 3), '2x3-multiplication', new MathExpression('10x100'), 5, 6),
    new TaskContainer(() => new MultiplicationTaskData.random(3, 3), '3x3-multiplication', new MathExpression('100x100'), 6, 7),
  ]),
];
// @formatter:on

TaskData randomTaskData(Settings settings) {
  Iterable<TaskContainer> activeTasks;
  if (settings.useDifficulty.val) {
    activeTasks = tasksGroups.map((TasksGroup g) => g.tasks)
        .expand((g) => g) // flatten (join all tasks together)
        .where((taskContainer) =>
    settings.difficulty.val >= taskContainer._minDifficulty &&
        settings.difficulty.val <= taskContainer._maxDifficulty);
  } else {
    activeTasks = tasksGroups.where((TasksGroup g) => settings.selectedGroups.val[g.id])
        .map((TasksGroup g) => g.tasks)
        .expand((g) => g) // flatten (join all tasks together)
        .where((taskContainer) => settings.selectedTasks.val[taskContainer.id]);
  }
  return activeTasks.toList(growable: false)[new Random().nextInt(activeTasks.length)]._supplier();
}