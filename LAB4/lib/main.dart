import 'package:flutter/material.dart';

import 'core_widgets_demo.dart';
import 'input_controls_demo.dart';
import 'layout_demo.dart';
import 'scaffold_demo.dart';
import 'ui_fixes_demo.dart';

void main() => runApp(const Lab4App());

class Lab4App extends StatefulWidget {
  const Lab4App({super.key});

  @override
  State<Lab4App> createState() => Lab4AppState();
}

class Lab4AppState extends State<Lab4App> {
  bool _isDarkMode = false; // theme

  void _changeTheme(bool value) {
    setState(() => _isDarkMode = value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LAB4 - Flutter UI Fundamentals',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: LabMenu(onThemeChanged: _changeTheme),
    );
  }
}

//Menu
class LabMenu extends StatelessWidget {
  const LabMenu({super.key, required this.onThemeChanged});

  final ValueChanged<bool> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      const CoreWidgetsDemo(),
      const InputControlsDemo(),
      const LayoutDemo(),
      ScaffoldDemo(onThemeChanged: onThemeChanged),
      const UiFixesDemo(),
    ];
    const titles = [
      'Exercise 1 - Core Widgets Demo',
      'Exercise 2 - Input Controls Demo',
      'Exercise 3 - Layout Demo',
      'Exercise 4 - App Structure & Theme',
      'Exercise 5 - Common UI Fixes',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('LAB4 - Flutter UI Fundamentals')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: titles.length,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            title: Text(titles[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (_) => screens[index]),
              );
            },
          ),
        ),
      ),
    );
  }
}
