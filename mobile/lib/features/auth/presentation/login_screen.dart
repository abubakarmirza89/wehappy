import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/session/session_store.dart';
import '../../../core/theme/app_theme.dart';
import '../../hearteli/presentation/components.dart';
import '../../../core/validation/validators.dart';
import '../../../core/validation/form_feedback.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
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
  bool _verificationPending = false;

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
    if (_busy || !_formKey.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
      _verificationPending = false;
    });
    try {
      await _auth.login(email: _email.text.trim(), password: _password.text);
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => AppShell(
            sessionStore: widget.sessionStore,
            apiClient: widget.apiClient,
          ),
        ),
        (_) => false,
      );
    } catch (error) {
      if (mounted) setState(() {
        _verificationPending = error is ApiException && error.code == 'email_verification_pending';
        _error = _verificationPending
            ? 'Verify your email before signing in. Check your inbox or resend the link.'
            : formRequestError(error, invalid: 'The email or password did not match. Check both and try again.');
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resendVerification() async {
    if (_busy) return;
    if (Validators.email(_email.text) != null) {
      setState(() => _error = 'Enter your account email address first.');
      return;
    }
    setState(() => _busy = true);
    try {
      await widget.apiClient.post('/api/resend-verification/', body: {'email': _email.text.trim()});
      if (mounted) setState(() => _error = 'If verification is pending, a new link will be sent.');
    } catch (e) {
      if (mounted) setState(() => _error = formRequestError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _forgotPassword(BuildContext context) async {
    final sent = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _ResetPasswordDialog(apiClient: widget.apiClient),
    );
    if (sent == true && context.mounted) {
      showCalmMessage(context, 'If an account exists, a reset link was sent.');
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
                      onPressed: _busy ? null : _resendVerification,
                      child: const Text('Resend verification email'),
                    ),
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


class _ResetPasswordDialog extends StatefulWidget {
  const _ResetPasswordDialog({required this.apiClient});
  final ApiClient apiClient;

  @override
  State<_ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<_ResetPasswordDialog> {
  final email = TextEditingController();
  final focus = FocusNode();
  bool busy = false;
  String? fieldError, requestError;

  Future<void> submit() async {
    if (busy) return;
    final validation = Validators.email(email.text);
    if (validation != null) {
      setState(() => fieldError = validation);
      focusInvalidField(focus);
      return;
    }
    setState(() {
      busy = true;
      fieldError = requestError = null;
    });
    try {
      await widget.apiClient.post('/api/forgot-password/', body: {'email': email.text.trim()});
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (mounted) setState(() => requestError = formRequestError(error));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  void dispose() {
    email.dispose();
    focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !busy,
    child: AlertDialog(
      scrollable: true,
      title: const Text('Reset password'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('We will send a reset link if this address has an account.'),
          const SizedBox(height: 14),
          TextField(
            controller: email, focusNode: focus, readOnly: busy,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: 'Email address', error: inlineFieldError(fieldError)),
            onChanged: (_) => setState(() { fieldError = requestError = null; }),
            onSubmitted: (_) => submit(),
          ),
          if (requestError != null)
            Semantics(liveRegion: true, child: StatusPanel(message: requestError!)),
        ],
      ),
      actions: [
        TextButton(onPressed: busy ? null : () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(onPressed: busy ? null : submit, child: Text(busy ? 'Checking…' : 'Send link')),
      ],
    ),
  );
}
