import 'dart:async';

Future<void> exercise3() async {
  print('===== exercise 3: ======');

  print('Step 1: Start');

  scheduleMicrotask(() => print('Step 3: microtask'));
  Future(() => print('Step 4: future'));

  print('Step 2: End of line');
  
  //Delay for loading future.
  await Future.delayed(const Duration(milliseconds: 100));
}
