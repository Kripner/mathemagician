import 'dart:math';

import 'package:mathemagician/settings.dart';
import 'package:mathemagician/tasks/multiplication_task.dart';
import 'package:mathemagician/tasks/square_task.dart';
import 'package:mathemagician/tasks/task.dart';

typedef D DataSupplier<D extends TaskData>();

class TaskContainer {
  final DataSupplier _supplier;
  final String _id;
  final int _minDifficulty;
  final int _maxDifficulty;

  TaskContainer(this._supplier, this._id, this._minDifficulty, this._maxDifficulty);
}

List<TaskContainer> tasks = [
  new TaskContainer(() => new SquareTaskData.random(1), '1-digit-squaring', 1, 1),
  new TaskContainer(() => new SquareTaskData.random(2), '2-digit-squaring', 2, 3),
  new TaskContainer(() => new SquareTaskData.random(3), '3-digit-squaring', 4, 5),
  new TaskContainer(() => new SquareTaskData.random(4), '4-digit-squaring', 6, 7),
  new TaskContainer(() => new SquareTaskData.random(4), '5-digit-squaring', 8, 9),
  new TaskContainer(() => new SquareTaskData.random(4), '6-digit-squaring', 10, 10),

  new TaskContainer(() => new MultiplicationTaskData.random(1, 1), '1x1-multiplication', 1, 1),
  new TaskContainer(() => new MultiplicationTaskData.random(2, 1), '2x1-multiplication', 1, 2),
  new TaskContainer(() => new MultiplicationTaskData.random(3, 1), '3x1-multiplication', 2, 3),
  new TaskContainer(() => new MultiplicationTaskData.random(4, 1), '4x1-multiplication', 3, 4),
  new TaskContainer(() => new MultiplicationTaskData.random(5, 1), '5x1-multiplication', 5, 6),
  new TaskContainer(() => new MultiplicationTaskData.random(6, 1), '6x1-multiplication', 6, 7),

  new TaskContainer(() => new MultiplicationTaskData.random(2, 2), '2x2-multiplication', 3, 4),
  new TaskContainer(() => new MultiplicationTaskData.random(2, 3), '2x3-multiplication', 5, 6),
  new TaskContainer(() => new MultiplicationTaskData.random(3, 3), '3x3-multiplication', 6, 7),
];

TaskData randomTaskData(Settings settings) {
  Iterable<TaskContainer> activeTasks;
  if (settings.useDifficulty.val) {
    activeTasks = tasks.where((taskContainer) =>
        settings.difficulty.val >= taskContainer._minDifficulty &&
        settings.difficulty.val <= taskContainer._maxDifficulty);
  } else {
    activeTasks = tasks.where((taskContainer) => settings.selected.val[taskContainer._id]);
  }
  return activeTasks.toList(growable: false)[new Random().nextInt(activeTasks.length)]._supplier();
}
