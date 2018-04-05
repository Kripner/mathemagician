import 'dart:math';

import 'package:mathemagician/settings.dart';
import 'package:mathemagician/tasks/Task.dart';
import 'package:mathemagician/tasks/square_task.dart';

typedef T TaskSupplier<T extends Task>(Settings settings);

class TaskManager {
  final TaskSupplier supplier;
  final String id;
  final String friendlyName;

  TaskManager(this.supplier, this.id, this.friendlyName);
}

List<TaskManager> _managers = [
  new TaskManager((settings) => new SquareTask(settings), 'squares', 'Squares')
];

TaskManager randomTask(Settings settings) {
  List<TaskManager> activeTasks =
      _managers.where((manager) => settings.selected.val[manager.id]).toList(growable: false);
  return activeTasks[new Random().nextInt(activeTasks.length)];
}
