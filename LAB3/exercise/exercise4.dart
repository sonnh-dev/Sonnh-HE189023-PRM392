import 'dart:async';

Future<void> exercise4() async {
  final numberStream = Stream.fromIterable([1,2,3,4,5]);
  final squere = numberStream.map((num) => (num*num)).where((num) => num.isEven);

  print('===== exercise 4: ======');
  await for (final num in squere) {
    print(num);
  }
}