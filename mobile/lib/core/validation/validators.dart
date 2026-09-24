class Validators {
  const Validators._();

  static String? required(String? value, {String label = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$label is required.';
    return null;
  }

  static String? email(String? value) {
    final requiredError = required(value, label: 'Email');
    if (requiredError != null) return requiredError;
    final email = value!.trim();
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) return 'Enter a valid email address.';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required.';
    if (value.length < 8) return 'Password must be at least 8 characters.';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Add at least one uppercase letter.';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Add at least one number.';
    return null;
  }

  static String? phone(String? value) {
    final requiredError = required(value, label: 'Phone number');
    if (requiredError != null) return requiredError;
    if (!RegExp(r'^\+?[0-9 ()-]{7,20}$').hasMatch(value!.trim())) return 'Enter a valid phone number.';
    return null;
  }

  static String? minLength(String? value, {required String label, int length = 2}) {
    final requiredError = required(value, label: label);
    if (requiredError != null) return requiredError;
    if (value!.trim().length < length) return '$label must be at least $length characters.';
    return null;
  }
}
