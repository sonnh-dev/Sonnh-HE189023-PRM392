import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/task.dart';
import 'task_detail_screen.dart';
import 'task_provider.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) => Selector<TaskProvider, Task?>(
    selector: (_, provider) => provider.find(id),
    builder: (context, task, _) {
      if (task == null) return const SizedBox.shrink();
      final provider = context.read<TaskProvider>();
      return ListTile(
        leading: Checkbox(
          value: task.completed,
          onChanged: (_) => provider.update(task.toggle()),
        ),
        title: Text(task.title),
        onTap: () => Navigator.push<void>(
          context,
          MaterialPageRoute(builder: (_) => TaskDetailScreen(task: task)),
        ),
        trailing: IconButton(
          tooltip: 'Delete task',
          onPressed: () => provider.delete(task.id),
          icon: const Icon(Icons.delete_outline),
        ),
      );
    },
  );
}
