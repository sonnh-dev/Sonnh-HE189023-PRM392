import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/task.dart';
import 'task_provider.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({super.key, required this.task});
  final Task task;

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late final _title = TextEditingController(text: widget.task.title);
  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Task Detail')),
    body: SafeArea(
      child: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              key: const ValueKey('detailTitleField'),
              controller: _title,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  (value ?? '').trim().isEmpty ? 'Enter a task title.' : null,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                if (!_form.currentState!.validate()) return;
                final provider = context.read<TaskProvider>();
                final current = provider.find(widget.task.id);
                if (current != null) {
                  provider.update(current.rename(_title.text.trim()));
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    ),
  );
}
