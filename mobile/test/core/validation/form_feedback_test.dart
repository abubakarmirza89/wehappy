import 'package:flutter_test/flutter_test.dart';

import '../../../lib/core/network/api_client.dart';
import '../../../lib/core/validation/form_feedback.dart';

void main() {
  test('maps invalid input without exposing server text', () {
    expect(
      formRequestError(
        const ApiException('technical detail', 400),
        invalid: 'Check your invite code.',
      ),
      'Check your invite code.',
    );
  });

  test('separates network and server failures', () {
    final network = formRequestError(StateError('internal network failure'));
    final server = formRequestError(const ApiException('internal server failure', 500));
    expect(network, contains('internet connection'));
    expect(server, contains('service'));
    expect(network, isNot(contains('internal')));
    expect(server, isNot(contains('internal')));
  });
}
