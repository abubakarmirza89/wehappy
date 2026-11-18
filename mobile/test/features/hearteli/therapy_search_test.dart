import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../lib/core/network/api_client.dart';
import '../../../lib/features/hearteli/presentation/therapy_screen.dart';

class _MarketplaceApi extends Fake implements ApiClient {
  Map<String, dynamic>? searchQuery;

  @override
  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    searchQuery = query;
    return {
      'sponsored': [],
      'organic': [
        {
          'id': 1,
          'name': 'Therapist One',
          'verified': true,
          'offerings': [
            {'fee': '100', 'billing_currency': 'USD'},
          ],
        },
        {
          'id': 2,
          'name': 'Therapist Two',
          'verified': true,
          'offerings': [
            {'fee': '120', 'billing_currency': 'USD'},
          ],
        },
      ],
      'count': 2,
      'next_after': null,
      'market': '',
      'market_count': 2,
      'fee_currency': 'USD',
      'markets': [
        {'code': 'US', 'name': 'United States'},
      ],
      'currencies': ['USD'],
      'specialties': ['Anxiety'],
      'durations': [60],
      'missing_fee_rates': false,
    };
  }
}

void main() {
  testWidgets('Find a therapist opens with all markets and filters collapsed', (
    tester,
  ) async {
    final previousErrorHandler = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.exceptionAsString().contains(
        'ListTile background color or ink splashes may be invisible.',
      )) {
        return;
      }
      previousErrorHandler?.call(details);
    };
    addTearDown(() => FlutterError.onError = previousErrorHandler);

    final api = _MarketplaceApi();
    await tester.pumpWidget(MaterialApp(home: TherapyScreen(apiClient: api)));
    await tester.pumpAndSettle();

    expect(api.searchQuery?['market'], '');
    expect(api.searchQuery?.containsKey('q'), isFalse);
    expect(find.textContaining('Therapist One'), findsOneWidget);
    expect(find.textContaining('Therapist Two'), findsOneWidget);
    expect(find.text('Filters'), findsOneWidget);
    expect(find.text('Market'), findsNothing);
    expect(find.text('Search by name'), findsNothing);

    await tester.tap(find.text('Filters'));
    await tester.pumpAndSettle();
    expect(find.text('Market'), findsOneWidget);
    expect(find.text('Search by name'), findsOneWidget);
  });
}
