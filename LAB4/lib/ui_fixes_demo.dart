import 'package:flutter/material.dart';

class UiFixesDemo extends StatefulWidget {
  const UiFixesDemo({super.key});

  @override
  State<UiFixesDemo> createState() => _UiFixesDemoState();
}

class _UiFixesDemoState extends State<UiFixesDemo> {
  int _count = 0;
  DateTime? _selectedDate;

  final List<String> movies = ['Movie A', 'Movie B', 'Movie C', 'Movie D'];

  // DatePicker
  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 5 – Debug & Fix Common UI Errors '),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Correct ListView inside Column using Expanded',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),
            // List view
            SizedBox(
              height: 250,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.movie),
                          title: Text(movies[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Text('Count: $_count', textAlign: TextAlign.center),

            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  _count++;
                });
              },
              child: const Text('Increase'),
            ),

            const SizedBox(height: 20),

            // DatePicker
            ElevatedButton(
              onPressed: _pickDate,
              child: const Text('Select Date'),
            ),

            const SizedBox(height: 8),

            Text(
              _selectedDate == null
                  ? 'No date selected'
                  : 'Selected: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
