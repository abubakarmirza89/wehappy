import 'package:flutter/material.dart';

import '../network/api_client.dart';

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
