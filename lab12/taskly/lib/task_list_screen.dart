import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'models/task.dart';
import 'task_provider.dart';
import 'task_tile.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _title = TextEditingController();

  void _add() {
    if (_title.text.trim().isEmpty) return;
    context.read<TaskProvider>().add(_title.text);
    _title.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taskly'),
        leading: const Padding(
          padding: EdgeInsets.all(12),
          child: Image(image: tasklyIcon),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _title,
                      decoration: const InputDecoration(
                        labelText: 'New task',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _add(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(onPressed: _add, child: const Text('Add')),
                ],
              ),
            ),
            Expanded(
              child: Selector<TaskProvider, List<Task>>(
                selector: (_, provider) => provider.tasks,
                shouldRebuild: (before, after) => !listEquals(
                  before.map((task) => task.id).toList(),
                  after.map((task) => task.id).toList(),
                ),
                builder: (context, tasks, _) {
                  if (tasks.isEmpty) {
                    return const Center(child: Text('No tasks yet. Add one!'));
                  }
                  return ListView.builder(
                    itemCount: tasks.length,
                    findChildIndexCallback: (key) {
                      final index = tasks.indexWhere(
                        (task) => ValueKey(task.id) == key,
                      );
                      return index == -1 ? null : index;
                    },
                    itemBuilder: (_, index) {
                      final id = tasks[index].id;
                      return TaskTile(key: ValueKey(id), id: id);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const tasklyIcon = AssetImage('assets/taskly_icon.png');
