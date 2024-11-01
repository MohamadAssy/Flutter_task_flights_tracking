import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey = '6198a3e018a7a3762d33912e5692d620'; 

  Future<List<dynamic>> fetchFlights(String? departure, String? arrival) async {
    String url = 'http://api.aviationstack.com/v1/flights?access_key=$apiKey';

    // Add filtering for specific airports
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
