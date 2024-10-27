import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey = 'ad577247338bd0db9d2d3e56900bf995'; // Replace with your actual API key

  Future<List<dynamic>> fetchFlights(String? departure, String? arrival) async {
    String url = 'http://api.aviationstack.com/v1/flights?access_key=$apiKey';

    // Add filtering for specific airports if provided
    if (departure != null) {
      url += '&dep_iata=$departure';
    }
    if (arrival != null) {
      url += '&arr_iata=$arrival';
    }

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'] as List<dynamic>;
      } else {
        throw Exception('Failed to load flights: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching flights: $error');
    }
  }
}
