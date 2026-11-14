import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/session/session_store.dart';
import '../../../core/validation/validators.dart';
import '../../../core/validation/form_feedback.dart';
import '../../hearteli/presentation/components.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/utils/toast.dart';
import '../data/auth_repository.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({
    super.key,
    required this.sessionStore,
    required this.apiClient,
  });

  final SessionStore sessionStore;
  final ApiClient apiClient;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;

  Future<void> _signup() async {
    if (_busy || !_formKey.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await AuthRepository(widget.apiClient, widget.sessionStore).signup(
        name: _name.text.trim(),
        email: _email.text.trim(),
        password: _password.text,
        phone: _phone.text.trim(),
      );
      if (mounted) {
        AppToast.success(context, 'Account created. Check your email to verify before signing in.');
        Navigator.pop(context);
      }
    } catch (error) {
      if (mounted) setState(() => _error = formRequestError(error, invalid: 'Check your email and password. If you already have an account, sign in instead.'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const BrandLogo(height: 60),
            const SizedBox(height: 20),
            const PageIntro(
              title: 'Start with Hearteli',
              subtitle: 'Your check-ins are private by default.',
            ),
            const SizedBox(height: 24),
            AppTextField(
              controller: _name,
              label: 'Name',
              validator: (value) => Validators.minLength(value, label: 'Name'),
            ),
            const SizedBox(height: 14),
            AppTextField(
              controller: _email,
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
            const SizedBox(height: 14),
            AppTextField(
              controller: _phone,
              label: 'Phone number',
              keyboardType: TextInputType.phone,
              validator: Validators.phone,
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
              Text(_error!, style: const TextStyle(color: Colors.redAccent)),
            ],
            const SizedBox(height: 24),
            AppButton(label: 'Create account', onPressed: _signup, busy: _busy),
          ],
        ),
      ),
    );
  }
}
