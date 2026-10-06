import 'package:flutter/material.dart';

class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}

class _InputControlsDemoState extends State<InputControlsDemo> {
  double _volume = 50;
  bool _activeMovie = false;
  String _selectedGenre = "Action";
  DateTime? _selectedDate;

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
        title: const Text(
          'Exercise 2 – Input Widgets: Slider, Switch, RadioListTile, DatePicker ',
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Slider.
            Text(
              'Rating (Slider)',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _volume,
              min: 0,
              max: 100,
              divisions: 100,
              label: '${_volume.round()}',
              onChanged: (value) => setState(() => _volume = value),
            ),
            Text('Current value: $_volume'),
            const SizedBox(height: 12),
            // Switch.
            Text(
              'Active (Switch)',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: Text('Is movie active?'),
              value: _activeMovie,
              onChanged: (value) {
                setState(() {
                  _activeMovie = value;
                });
              },
            ),
            const SizedBox(height: 12),
            //Radio
            Text(
              'Genre (RadioListTile)',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            RadioListTile<String>(
              visualDensity: const VisualDensity(vertical: -2),
              title: Text('Action'),
              value: 'Action',
              groupValue: _selectedGenre,
              onChanged: (value) {
                setState(() {
                  _selectedGenre = value!;
                });
              },
            ),
            RadioListTile<String>(
              visualDensity: const VisualDensity(vertical: -2),
              title: Text('Comedy'),
              value: 'Comedy',
              groupValue: _selectedGenre,
              onChanged: (value) {
                setState(() {
                  _selectedGenre = value!;
                });
              },
            ),
            Text('Selected genre: $_selectedGenre'),
            const SizedBox(height: 16),

            // Date picker
            ElevatedButton.icon(
              onPressed: _pickDate,
              label: const Text('Open date picker'),
            ),
            Text(
              'Selected date: ${_selectedDate != null ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}' : 'None'}',
            ),
          ],
        ),
      ),
    );
  }
}
