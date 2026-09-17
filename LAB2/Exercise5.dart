Future<void> exercise5() async {
  print('==================== Exercise 5: ==========================');

  String data = await loadData();
  print(data);
  String? color;
  print('Color: ${color ?? 'Unknown'}');
  color = 'Blue';
  print('New color $color');
  print('Color length: ${color!.length}');

  // ================ STREAM ===============
  Stream<int> countStream() async* {
    for (int i = 1; i <= 5; i++) {
      await Future.delayed(Duration(seconds: 1));
      yield i;
    }
  }
  await for (int value in countStream()) {
    print('Count: $value');
  }
}

Future<String> loadData() async {
    await Future.delayed(Duration(seconds: 2));
    return 'load Data successfully';
}
