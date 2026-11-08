import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'task_detail_screen.dart';
import 'task_provider.dart';

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
    final provider = context.watch<TaskProvider>();
    final tasks = provider.tasks;
    return Scaffold(
      appBar: AppBar(title: const Text('Taskly')),
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
              child: tasks.isEmpty
                  ? const Center(child: Text('No tasks yet. Add one!'))
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return ListTile(
                          key: ValueKey(task.id),
                          leading: Checkbox(
                            value: task.completed,
                            onChanged: (_) => provider.update(task.toggle()),
                          ),
                          title: Text(task.title),
                          onTap: () => Navigator.push<void>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TaskDetailScreen(task: task),
                            ),
                          ),
                          trailing: IconButton(
                            tooltip: 'Delete task',
                            onPressed: () => provider.delete(task.id),
                            icon: const Icon(Icons.delete_outline),
                          ),
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
