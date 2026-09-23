import 'package:flutter_test/flutter_test.dart';

import 'package:myapp/core/validation/validators.dart';

void main() {
  group('Validators', () {
    test('requires a value', () {
      expect(Validators.required(''), isNotNull);
      expect(Validators.required('hello'), isNull);
    });

    test('validates email format', () {
      expect(Validators.email('wrong'), isNotNull);
      expect(Validators.email('person@example.com'), isNull);
    });

    test('requires a strong password', () {
      expect(Validators.password('short'), isNotNull);
      expect(Validators.password('StrongPass123'), isNull);
    });

    test('validates phone format', () {
      expect(Validators.phone('abc'), isNotNull);
      expect(Validators.phone('+923001234567'), isNull);
    });

    test('validates minimum text length', () {
      expect(Validators.minLength('a', label: 'Name'), isNotNull);
      expect(Validators.minLength('Ali', label: 'Name'), isNull);
    });
  });
}
