void exercise2() {
  print('============ Exercise 2 =============');
  //==============================================
  //================== List ======================
  List<int> nums = [10, 20, 36, 40, 50, 67];
  print("Original List: $nums");
  print('Number index 1 is: ${nums[0]}');
  nums.add(100);
  nums.remove(40);
  print("List after add 100 and remove 40: $nums");

  //======= Arithmetic and logical operators. ======
  int a = 36; int b = 12;
  print('Arithmetic and logical operators');
  print('$a + $b = ${a + b}');
  print('$a - $b = ${a - b}');
  print('$a == $b: ${a == b}');
  print('a > b AND b > 0: ${a > b && b > 0}');

  String result = a > b ? 'a is greater' : 'b is greater';
  print(result);

  //======================== Set. ==========================
  Set<String> department = {'FE', 'BE', 'BA', 'Tester', 'PM'};
  print('Set of department: $department');
  department.add('Security');
  department.remove('PM');
  print('Update department: $department');
  //Set key-value.
  Map<String, int> ages = {
    'A': 18,
    'B': 19,
    'C': 20,
  };
  print('Ages: $ages');
  print("A ages is: ${ages['A']}");
  ages['D'] = 22;
  print("New update Ages: $ages");
  print('');

  //====== End of Exercise 2 ================
}