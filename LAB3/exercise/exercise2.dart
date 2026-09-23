import 'dart:convert';

class User {
  String name;
  String email;

  User(this.name, this.email);


  User.fromJson(Map<String, dynamic> json) :
      name = json['name'],
      email = json['email'];

  @override
  String toString() {
    return 'User(name: $name, email: $email)';
  }
}

class UserRepository {

  Future<List<User>> getUsers() async {
    const jsonData = '''
    [
      {
        "name": "Hoang Son",
        "email": "sonhhhe189023@fpt.com.vn"
      },
      {
        "name": "Blah Blur",
        "email": "BB@gmail.com"
      },
      {
        "name": "Charlotte",
        "email": "Charlotte999@gmail.com"
      }
    ]
    ''';

    final List<dynamic> data = jsonDecode(jsonData);
    return data.map((json) => User.fromJson(json)).toList();
  }
}

Future<void> exercise2() async {
  final repository = UserRepository();
  final users = await repository.getUsers();

  print('===== exercise 2: ======');
  for (final user in users) {
    print(user);
  }
}