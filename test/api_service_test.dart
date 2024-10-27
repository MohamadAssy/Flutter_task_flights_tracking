import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../lib/api_service.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  final apiService = MockApiService();

  group('ApiService Tests', () {
    test('Fetch flights returns data successfully', () async {
      when(apiService.fetchFlights('LAX', 'DBX')).thenAnswer((_) async => [
            {'flight': {'iata': 'XY123'}, 'arrival': {'airport': 'DXB'}, 'departure': {'airport': 'LAX'}}
          ]);

      final flights = await apiService.fetchFlights('LAX', 'DBX');
      expect(flights.isNotEmpty, true);
      expect(flights[0]['flight']['iata'], 'XY123');
    });

    test('Fetch flights handles errors gracefully', () async {
      when(apiService.fetchFlights('LAX', 'DBX')).thenThrow(Exception('API error'));

      expect(() async => await apiService.fetchFlights('LAX', 'DBX'), throwsException);
    });
  });
}
