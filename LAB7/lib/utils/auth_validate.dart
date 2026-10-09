String? validateName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Full name is required';
  }
  return null;
}

String? validateEmail(String? value) {
  final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  if (value == null || value.trim().isEmpty) {
    return 'Email is required';
  }
  if (!emailPattern.hasMatch(value.trim())) {
    return 'Enter a valid email';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Password is required';
  }
  if (value.length < 8) {
    return 'Password must have at least 8 characters';
  }
  if (!RegExp(r'[0-9]').hasMatch(value)) {
    return 'Password must contain at least 1 digit';
  }
  return null;
}

String? validateConfirmPassword(String? value, String password) {
  if (value == null || value.isEmpty) {
    return 'Please confirm your password';
  }
  if (value != password) {
    return 'Passwords do not match';
  }
  return null;
}
