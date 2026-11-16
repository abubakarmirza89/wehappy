import 'package:flutter/material.dart';

import '../network/api_client.dart';
import 'validators.dart';

String formRequestError(Object error, {String? invalid, String? missing}) {
  if (error is! ApiException) {
    return 'Could not connect. Check your internet connection and try again.';
  }
  return switch (error.statusCode) {
    400 || 409 || 422 => invalid ?? 'Check the information you entered and try again.',
    401 || 403 => invalid ?? 'Sign in again and try again.',
    404 || 410 => missing ?? invalid ?? 'This is no longer available. Refresh and try again.',
    429 => 'Too many attempts. Wait a moment and try again.',
    _ => 'The service could not complete your request. Please try again.',
  };
}

Widget? inlineFieldError(String? message) => message == null
    ? null
    : Semantics(liveRegion: true, child: Text(message));

void focusInvalidField(FocusNode focus) {
  focus.requestFocus();
  final field = focus.context;
  if (field != null) Scrollable.ensureVisible(field);
}

String? emailFieldError(String value) {
  if (value.trim().isEmpty) return 'Enter an email address.';
  if (Validators.email(value) != null) {
    return 'Enter an email address like name@example.com.';
  }
  return null;
}

class EmailInviteDialog extends StatefulWidget {
  const EmailInviteDialog({super.key, required this.onInvite});

  final Future<bool> Function(String email) onInvite;

  @override
  State<EmailInviteDialog> createState() => _EmailInviteDialogState();
}

class _EmailInviteDialogState extends State<EmailInviteDialog> {
  final controller = TextEditingController();
  final focus = FocusNode();
  String? error;
  bool busy = false;

  @override
  void dispose() {
    controller.dispose();
    focus.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (busy) return;
    final email = controller.text.trim();
    final invalid = emailFieldError(email);
    setState(() {
      error = invalid;
      busy = invalid == null;
    });
    if (invalid != null) {
      focusInvalidField(focus);
      return;
    }
    try {
      final invited = await widget.onInvite(email);
      if (!mounted) return;
      if (invited) {
        Navigator.pop(context, true);
        return;
      }
      setState(() => error = 'No invitation was sent. Check the email and whether this person is already a member.');
      focusInvalidField(focus);
    } catch (exception) {
      if (!mounted) return;
      setState(() => error = formRequestError(exception,
          invalid: 'Check the email address and try again.'));
      focusInvalidField(focus);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    scrollable: true,
    title: const Text('Invite member'),
    content: TextField(
      controller: controller,
      focusNode: focus,
      readOnly: busy,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => submit(),
      onChanged: (_) {
        if (error != null) setState(() => error = null);
      },
      decoration: InputDecoration(
        labelText: 'Existing member email (required)',
        error: inlineFieldError(error),
        errorMaxLines: 4,
      ),
    ),
    actions: [
      TextButton(
        onPressed: busy ? null : () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: busy ? null : submit,
        child: Text(busy ? 'Inviting…' : 'Invite'),
      ),
    ],
  );
}
