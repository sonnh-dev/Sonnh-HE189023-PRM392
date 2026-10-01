class User {
  int id;
  String name;
  String? email;

  User({required this.id, required this.name, this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? "Khách",
      email: json['email'],
    );
  }

  void showProfile() {
    print("ID: $id | Tên: $name | Email: ${email ?? "Chưa cập nhật"}");
  }
}

void ex16Runner() {
  Map<String, dynamic> rawData1 = {
    "id": 1,
    "name": "Son",
    "email": "Sonnhhe189023@fpt.edu.vn",
  };
  Map<String, dynamic> rawData2 = {"id": 2, "name": null, "email": null};

  User user1 = User.fromJson(rawData1);
  User user2 = User.fromJson(rawData2);
  print('========== EX1.6 ==========');
  user1.showProfile();
  user2.showProfile();
}
