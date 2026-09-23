class Settings {
  Settings._internal();
  static final Settings _instance = Settings._internal();

  factory Settings() {
    return _instance;
  }

  String theme = 'light';
  String language = 'English';
}

Future<void> exercise5() async {
  print('===== exercise 5: ======');
  final a = Settings();
  final b = Settings();

  print('Settings A: ${a.theme}, ${a.language}');
  a.theme = 'dark';
  b.language = 'vietnamese';
  print('Settings B: ${b.theme}, ${b.language}');

  print('identical(a, b): ${identical(a, b)}');
}