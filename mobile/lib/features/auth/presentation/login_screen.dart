import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/session/session_store.dart';
import '../../../core/theme/app_theme.dart';
import '../../hearteli/presentation/components.dart';
import '../../../core/validation/validators.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/utils/toast.dart';
import 'signup_screen.dart';
import '../../home/presentation/app_shell.dart';
import '../data/auth_repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.sessionStore,
    required this.apiClient,
  });

  final SessionStore sessionStore;
  final ApiClient apiClient;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  late final AuthRepository _auth;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _auth = AuthRepository(widget.apiClient, widget.sessionStore);
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await _auth.login(email: _email.text.trim(), password: _password.text);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => AppShell(
            sessionStore: widget.sessionStore,
            apiClient: widget.apiClient,
          ),
        ),
      );
    } on ApiException catch (error) {
      setState(() => _error = error.message);
      if (mounted) AppToast.error(context, error.message);
    } catch (_) {
      setState(
        () => _error = 'Unable to connect. Check the API URL and try again.',
      );
      if (mounted)
        AppToast.error(
          context,
          'Unable to connect. Check the API URL and try again.',
        );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _forgotPassword(BuildContext context) async {
    final email = TextEditingController(text: _email.text.trim());
    await showDialog(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('Reset password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'We will send a reset link if this address has an account.',
            ),
            const SizedBox(height: 14),
            TextField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email address'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await widget.apiClient.post(
                  '/api/forgot-password/',
                  body: {'email': email.text.trim()},
                );
                if (dialog.mounted) Navigator.pop(dialog);
                if (context.mounted)
                  showCalmMessage(
                    context,
                    'If an account exists, a reset link was sent.',
                  );
              } catch (e) {
                if (dialog.mounted) showCalmMessage(dialog, '$e');
              }
            },
            child: const Text('Send link'),
          ),
        ],
      ),
    );
    email.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BrandLogo(height: 72),
                    const SizedBox(height: 18),
                    Text(
                      'Welcome back',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Know when to be there. Your space is private by default.',
                    ),
                    const SizedBox(height: 32),
                    AppTextField(
                      controller: _email,
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      controller: _password,
                      label: 'Password',
                      obscureText: true,
                      validator: Validators.password,
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 14),
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ],
                    const SizedBox(height: 22),
                    AppButton(label: 'Sign in', onPressed: _login, busy: _busy),
                    TextButton(
                      onPressed: () => _forgotPassword(context),
                      child: const Text('Forgot password?'),
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SignupScreen(
                              sessionStore: widget.sessionStore,
                              apiClient: widget.apiClient,
                            ),
                          ),
                        ),
                        child: const Text('Create a new account'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
