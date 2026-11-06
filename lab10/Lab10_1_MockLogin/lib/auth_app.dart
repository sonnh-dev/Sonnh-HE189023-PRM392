import 'package:flutter/material.dart';

import 'auth_models.dart';

class AuthApp extends StatelessWidget {
  const AuthApp({
    super.key,
    required this.title,
    required this.description,
    this.onPasswordLogin,
    this.onGoogleLogin,
    this.restore,
    this.signOut,
    this.afterLogin,
    this.emailLogin = false,
    this.demoIdentity,
    this.demoPassword,
    this.googlePreview = false,
  });

  final String title;
  final String description;
  final Future<AuthProfile> Function(String, String)? onPasswordLogin;
  final Future<AuthProfile> Function()? onGoogleLogin;
  final Future<AuthProfile?> Function()? restore;
  final Future<void> Function(AuthProfile)? signOut;
  final Future<bool> Function(AuthProfile)? afterLogin;
  final bool emailLogin;
  final String? demoIdentity;
  final String? demoPassword;
  final bool googlePreview;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: _AuthScreen(config: this),
    );
  }
}

class _AuthScreen extends StatefulWidget {
  const _AuthScreen({required this.config});
  final AuthApp config;

  @override
  State<_AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<_AuthScreen> {
  final _form = GlobalKey<FormState>();
  final _identity = TextEditingController();
  final _password = TextEditingController();
  AuthProfile? _profile;
  bool _restoring = false;
  bool _restored = false;
  bool _busy = false;
  bool _obscure = true;
  String? _error;
  String? _notification;

  AuthApp get config => widget.config;

  @override
  void initState() {
    super.initState();
    if (config.restore != null) {
      _restoring = true;
      _restore();
    }
  }

  Future<void> _restore() async {
    try {
      final profile = await config.restore!();
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _restored = profile != null;
      });
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'Session could not be restored. Sign in again.',
        );
      }
    } finally {
      if (mounted) setState(() => _restoring = false);
    }
  }

  Future<void> _login(Future<AuthProfile> Function() action) async {
    if (_busy) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _busy = true;
      _error = null;
      _notification = null;
    });
    try {
      final profile = await action();
      if (!mounted) return;
      _password.clear();
      setState(() {
        _profile = profile;
        _restored = false;
      });
      final afterLogin = config.afterLogin;
      if (afterLogin != null) {
        try {
          final sent = await afterLogin(profile);
          if (mounted) {
            setState(
              () => _notification = sent
                  ? 'Login notification sent.'
                  : 'Notifications are disabled on this device.',
            );
          }
        } catch (_) {
          if (mounted) {
            setState(() => _notification = 'Could not send the notification.');
          }
        }
      }
    } on AuthFailure catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) setState(() => _error = 'Unable to sign in. Try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _logout() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await config.signOut?.call(_profile!);
      if (!mounted) return;
      setState(() {
        _profile = null;
        _restored = false;
        _notification = null;
      });
    } catch (_) {
      if (mounted) setState(() => _error = 'Could not sign out. Try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _openPreview() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Google profile demo')),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const ProfileCard(
                profile: AuthProfile(
                  name: 'Alex Nguyen',
                  email: 'alex@example.com',
                  provider: 'Google Sign-In demo',
                ),
                status: 'Sample profile',
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Back to sign-in'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _identity.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = _profile;
    return Scaffold(
      appBar: AppBar(title: Text(config.title)),
      body: SafeArea(
        child: _restoring
            ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Checking your session'),
                  ],
                ),
              )
            : Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: profile == null ? _loginForm() : _home(profile),
                  ),
                ),
              ),
      ),
    );
  }

  List<Widget> _loginForm() {
    final passwordLogin = config.onPasswordLogin;
    final googleLogin = config.onGoogleLogin;
    return [
      const Icon(Icons.lock_outline, size: 44),
      const SizedBox(height: 20),
      const Text(
        'Sign in',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      Text(config.description),
      const SizedBox(height: 24),
      if (passwordLogin != null)
        Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                controller: _identity,
                enabled: !_busy,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                keyboardType: config.emailLogin
                    ? TextInputType.emailAddress
                    : TextInputType.text,
                decoration: InputDecoration(
                  labelText: config.emailLogin ? 'Email' : 'Username',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                validator: (value) {
                  final input = value?.trim() ?? '';
                  if (input.isEmpty) return 'Enter your account name.';
                  if (config.emailLogin &&
                      !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(input)) {
                    return 'Enter a valid email.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _password,
                enabled: !_busy,
                obscureText: _obscure,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.key_outlined),
                  suffixIcon: IconButton(
                    tooltip: _obscure ? 'Show password' : 'Hide password',
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter your password.'
                    : null,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _busy
                      ? null
                      : () {
                          if (_form.currentState!.validate()) {
                            _login(
                              () => passwordLogin(
                                _identity.text.trim(),
                                _password.text,
                              ),
                            );
                          }
                        },
                  child: const Text('Sign in'),
                ),
              ),
              if (config.demoIdentity != null)
                TextButton(
                  onPressed: _busy
                      ? null
                      : () {
                          _identity.text = config.demoIdentity!;
                          _password.text = config.demoPassword!;
                          setState(() => _error = null);
                        },
                  child: const Text('Use test account'),
                ),
            ],
          ),
        ),
      if (googleLogin != null) ...[
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _busy ? null : () => _login(googleLogin),
          icon: const Icon(Icons.account_circle_outlined),
          label: const Text('Sign in with Google'),
        ),
      ],
      if (config.googlePreview) ...[
        const SizedBox(height: 12),
        const Text('Google Sign-In requires Firebase configuration.'),
        TextButton(
          onPressed: _busy ? null : _openPreview,
          child: const Text('Preview demo profile'),
        ),
      ],
      if (_busy) const LinearProgressIndicator(),
      if (_error != null) _errorText(),
    ];
  }

  List<Widget> _home(AuthProfile profile) => [
    ProfileCard(
      profile: profile,
      status: _restored ? 'Session restored' : 'Signed in',
    ),
    if (_notification != null)
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(_notification!),
      ),
    if (_error != null) _errorText(),
    const SizedBox(height: 16),
    OutlinedButton.icon(
      onPressed: _busy ? null : _logout,
      icon: const Icon(Icons.logout),
      label: const Text('Sign out'),
    ),
  ];

  Widget _errorText() => Padding(
    padding: const EdgeInsets.only(top: 12),
    child: Text(
      _error!,
      style: TextStyle(color: Theme.of(context).colorScheme.error),
    ),
  );
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.profile, required this.status});

  final AuthProfile profile;
  final String status;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: colors.primaryContainer,
              child: const Icon(Icons.person_outline),
            ),
            const SizedBox(height: 16),
            Text(
              profile.name,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(profile.email),
            if (profile.username != null) Text('@${profile.username}'),
            const SizedBox(height: 16),
            Text(profile.provider),
            const SizedBox(height: 6),
            Text(
              status,
              style: TextStyle(
                color: colors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
