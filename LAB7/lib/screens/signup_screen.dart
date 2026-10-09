import 'package:flutter/material.dart';

import '../utils/auth_validate.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

  String _fullName = '';
  String _email = '';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Kiểm tra toàn bộ form trước khi lưu và gửi dữ liệu.
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isSubmitting = true);

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() => _isSubmitting = false);

    final message = _email.toLowerCase().startsWith('taken')
        ? 'This email is already taken'
        : 'Signup successful. Welcome, $_fullName!';
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LAB7 - Signup')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Create an account',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Enter your information below to sign up.'),
              const SizedBox(height: 24),

              TextFormField(
                enabled: !_isSubmitting,
                decoration: const InputDecoration(
                  labelText: 'Full name',
                  border: OutlineInputBorder(),
                ),
                validator: validateName,
                onSaved: (value) => _fullName = value!.trim(),
              ),
              const SizedBox(height: 16),

              TextFormField(
                enabled: !_isSubmitting,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: validateEmail,
                onSaved: (value) => _email = value!.trim(),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _passwordController,
                enabled: !_isSubmitting,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: validatePassword,
              ),
              const SizedBox(height: 16),

              TextFormField(
                enabled: !_isSubmitting,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    validateConfirmPassword(value, _passwordController.text),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          semanticsLabel: 'Checking email',
                        ),
                      )
                    : const Text('Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
