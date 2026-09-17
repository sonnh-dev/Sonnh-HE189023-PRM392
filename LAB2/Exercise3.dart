void exercise3() {
  print('============ Exercise 3 =============');
  //task 1
  int score = 80;
  if (score >= 80) {
    print('Grade: Excellent');
  } else if (score >= 60) {
    print('Grade: Pass');
  } else {
    print('Grade: Fail');
  }
  //task 2
  int day = 4;
  switch (day) {
    case 1:
      print('Day: Monday');
      break;
    case 2:
      print('Day: Tuesday');
      break;
    case 3:
      print('Day: Wednesday');
      break;
    case 4:
      print('Day: Thursday');
      break;
    case 5:
      print('Day: Friday');
      break;
    case 6:
      print('Day: Saturday');
      break;
    case 7:
      print('Day: Sunday');
      break;
    default:
      print('Invalid day');
  }
  //task 3
  List<String> fruits  = ['Banana', 'Apple', 'Kiwi', 'strawberry', 'pineapple'];
  print('For loop:');
  for (int i = 0; i < fruits.length; i++) {
    print('$i: ${fruits[i]}');
  }
  print('For-in loop:');
  for (String fruit in fruits) {
    print(fruit);
  }
  print('forEach loop:');
  fruits.forEach((fruit) => print(fruit));

  print('Call a function.');
  int sum = addNumbers(10, 20);
  print('10 + 20 = $sum');
  print('Call a function using arrow syntax.');
  print('5 x 5 = ${square(5)}');
  print('');
}
int addNumbers(int x, int y) {
  return x + y;
}
int square(int number) => number * number;