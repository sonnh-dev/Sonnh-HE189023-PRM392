class AuthProfile {
  const AuthProfile({
    required this.name,
    required this.email,
    required this.provider,
    this.username,
  });

  final String name;
  final String email;
  final String provider;
  final String? username;
}

class AuthFailure implements Exception {
  const AuthFailure(this.message);
  final String message;
}
