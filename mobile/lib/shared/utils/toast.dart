import 'package:flutter/material.dart';

class AppToast {
  const AppToast._();

  static void error(BuildContext context, String message) {
    _show(context, message, const Color(0xFFB42318));
  }

  static void success(BuildContext context, String message) {
    _show(context, message, const Color(0xFF287A4D));
  }

  static void _show(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), backgroundColor: color, behavior: SnackBarBehavior.floating));
  }
}
