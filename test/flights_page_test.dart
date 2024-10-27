import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_flutter_app/flights_page.dart';
import 'package:my_flutter_app/api_service.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  final apiService = MockApiService();

  Widget createFlightsPage() {
    return MaterialApp(
      home: FlightsPage(),
    );
  }

  group('FlightsPage Widget Tests', () {
    testWidgets('Displays loading indicator while fetching data', (WidgetTester tester) async {
      when(apiService.fetchFlights(any, any)).thenAnswer((_) async => []);

      await tester.pumpWidget(createFlightsPage());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Displays flight data', (WidgetTester tester) async {
      when(apiService.fetchFlights(any, any)).thenAnswer((_) async => [
            {'flight': {'iata': 'XY123'}, 'arrival': {'airport': 'DXB'}, 'departure': {'airport': 'LAX'}}
          ]);

      await tester.pumpWidget(createFlightsPage());
      await tester.pumpAndSettle();

      expect(find.text('Flight: XY123'), findsOneWidget);
      expect(find.text('To: DXB'), findsOneWidget);
      expect(find.text('From: LAX'), findsOneWidget);
    });
  });
}
