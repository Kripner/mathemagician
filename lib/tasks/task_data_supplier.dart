import 'dart:math';

import 'package:mathemagician/settings.dart';
import 'package:mathemagician/tasks/square_task.dart';
import 'package:mathemagician/tasks/task.dart';

typedef D DataSupplier<D extends TaskData>();

class TaskContainer {
  final DataSupplier _supplier;
  final String _id;
  final int _difficulty;

  TaskContainer(this._supplier, this._id, this._difficulty);
}

List<TaskContainer> tasks = [
  new TaskContainer(() => new SquareTaskData.random(1), '1-digit-squaring', 1),
  new TaskContainer(() => new SquareTaskData.random(2), '2-digit-squaring', 2),
  new TaskContainer(() => new SquareTaskData.random(3), '3-digit-squaring', 3),
  new TaskContainer(() => new SquareTaskData.random(4), '4-digit-squaring', 4),
  new TaskContainer(() => new SquareTaskData.random(4), '5-digit-squaring', 5),
  new TaskContainer(() => new SquareTaskData.random(4), '6-digit-squaring', 6),
];

TaskData randomTaskData(Settings settings) {
  Iterable<TaskContainer> activeTasks;
  if (settings.useDifficulty.val) {
    activeTasks = tasks.where((taskContainer) => taskContainer._difficulty == settings.difficulty.val);
  } else {
    activeTasks = tasks.where((taskContainer) => settings.selected.val[taskContainer._id]);
  }
  return activeTasks.toList(growable: false)[new Random().nextInt(activeTasks.length)]._supplier();
}
