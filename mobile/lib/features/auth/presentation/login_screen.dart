import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/session/session_store.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/validation/validators.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/utils/toast.dart';
import 'signup_screen.dart';
import '../../home/presentation/app_shell.dart';
import '../data/auth_repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.sessionStore, required this.apiClient});

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
    setState(() { _busy = true; _error = null; });
    try {
      await _auth.login(email: _email.text.trim(), password: _password.text);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => AppShell(sessionStore: widget.sessionStore, apiClient: widget.apiClient)));
    } on ApiException catch (error) {
      setState(() => _error = error.message);
      if (mounted) AppToast.error(context, error.message);
    } catch (_) {
      setState(() => _error = 'Unable to connect. Check the API URL and try again.');
      if (mounted) AppToast.error(context, 'Unable to connect. Check the API URL and try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
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
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('😊', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 18),
                  Text('Welcome back', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, color: AppColors.ink)),
                  const SizedBox(height: 8),
                  const Text('A calmer day starts with one honest check-in.'),
                  const SizedBox(height: 32),
                  AppTextField(controller: _email, label: 'Email', keyboardType: TextInputType.emailAddress, validator: Validators.email),
                  const SizedBox(height: 14),
                  AppTextField(controller: _password, label: 'Password', obscureText: true, validator: Validators.password),
                  if (_error != null) ...[const SizedBox(height: 14), Text(_error!, style: const TextStyle(color: Colors.redAccent))],
                  const SizedBox(height: 22),
                  AppButton(label: 'Sign in', onPressed: _login, busy: _busy),
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
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
