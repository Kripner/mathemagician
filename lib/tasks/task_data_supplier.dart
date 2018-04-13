import 'dart:math';

import 'package:mathemagician/settings.dart';
import 'package:mathemagician/tasks/square_task.dart';
import 'package:mathemagician/tasks/task.dart';

typedef D DataSupplier<D extends TaskData>(Settings settings);

class TaskContainer {
  final DataSupplier _supplier;
  final String id;

  TaskContainer(this._supplier, this.id);
}

List<TaskContainer> _tasks = [
  new TaskContainer((settings) => new SquareTaskData.newRandom(settings), 'squaring'),
];

TaskData randomTaskData(Settings settings) {
  List<TaskContainer> activeTasks =
      _tasks.where((taskContainer) => settings.selected.val[taskContainer.id]).toList(growable: false);
  return activeTasks[new Random().nextInt(activeTasks.length)]._supplier(settings);
}
