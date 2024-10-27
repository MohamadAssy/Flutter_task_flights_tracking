import 'package:flutter/material.dart';
import 'dart:async';
import 'api_service.dart';
import 'package:intl/intl.dart';

class FlightsPage extends StatefulWidget {
  @override
  _FlightsPageState createState() => _FlightsPageState();
}

class _FlightsPageState extends State<FlightsPage> {
  final ApiService apiService = ApiService();
  List<dynamic> flights = [];
  bool isLoading = true;
  Timer? autoRefreshTimer;
  bool isAutoRefreshEnabled = true;
  final List<String> airports = ['LAX', 'DBX', 'CDG'];
  String? selectedDeparture;
  String? selectedArrival;
  DateTime? lastUpdateTime;

  @override
  void initState() {
    super.initState();
    _loadFlights();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    autoRefreshTimer?.cancel();
    super.dispose();
  }

  void _startAutoRefresh() {
    if (isAutoRefreshEnabled) {
      autoRefreshTimer = Timer.periodic(Duration(seconds: 10), (timer) {
        _loadFlights();
      });
    }
  }

  void _stopAutoRefresh() {
    autoRefreshTimer?.cancel();
  }

  Future<void> _loadFlights() async {
    setState(() {
      isLoading = true;
    });

    try {
      flights = await apiService.fetchFlights(selectedDeparture, selectedArrival);
      lastUpdateTime = DateTime.now();
    } catch (e) {
      print('Error fetching flights: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green.shade600;
      case 'landed':
        return Colors.black;
      case 'delayed':
        return Colors.red.shade600;
      case 'cancelled':
        return Colors.orange.shade700;
      case 'unknown':
        return Colors.grey.shade600;
      default:
        return Colors.blue.shade600;
    }
  }

  String _formatTimestamp(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flight Tracker'),
        backgroundColor: Colors.blueGrey.shade700,
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueGrey.shade50, Colors.blueGrey.shade200],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Column(
            children: [
              // Auto-refresh toggle and last update
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Auto-Refresh',
                      style: TextStyle(color: Colors.blueGrey.shade700, fontWeight: FontWeight.bold),
                    ),
                    Switch(
                      value: isAutoRefreshEnabled,
                      onChanged: (value) {
                        setState(() {
                          isAutoRefreshEnabled = value;
                          if (isAutoRefreshEnabled) {
                            _startAutoRefresh();
                          } else {
                            _stopAutoRefresh();
                          }
                        });
                      },
                      activeColor: Colors.green.shade600,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  lastUpdateTime != null
                      ? 'Last Updated: ${_formatTimestamp(lastUpdateTime!)}'
                      : 'Loading...',
                  style: TextStyle(color: Colors.blueGrey.shade700, fontSize: 14),
                ),
              ),
              // Dropdown for filters
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDropdown('Select Departure', selectedDeparture, (value) {
                      setState(() {
                        selectedDeparture = value;
                        _loadFlights();
                      });
                    }),
                    _buildDropdown('Select Arrival', selectedArrival, (value) {
                      setState(() {
                        selectedArrival = value;
                        _loadFlights();
                      });
                    }),
                  ],
                ),
              ),
              // Flight list
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadFlights,
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: flights.length,
                          itemBuilder: (context, index) {
                            final flight = flights[index];
                            final status = flight['flight_status'] ?? 'N/A';

                            return Card(
                              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.flight,
                                      color: _getStatusColor(status),
                                      size: 36,
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Flight: ${flight['flight']['iata'] ?? 'N/A'}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueGrey.shade800,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'To: ${flight['arrival']['airport'] ?? 'N/A'}',
                                            style: TextStyle(fontSize: 16, color: Colors.blueGrey.shade600),
                                          ),
                                          Text(
                                            'From: ${flight['departure']['airport'] ?? 'N/A'}',
                                            style: TextStyle(fontSize: 16, color: Colors.blueGrey.shade600),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Status: ',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                status,
                                                style: TextStyle(
                                                  color: _getStatusColor(status),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String hint, String? selectedValue, ValueChanged<String?> onChanged) {
    return DropdownButton<String>(
      hint: Text(
        hint,
        style: TextStyle(color: Colors.blueGrey.shade700),
      ),
      value: selectedValue,
      onChanged: onChanged,
      items: airports.map((airport) {
        return DropdownMenuItem(
          value: airport,
          child: Text(airport),
        );
      }).toList(),
      dropdownColor: Colors.white,
      iconEnabledColor: Colors.blueGrey.shade700,
      style: TextStyle(color: Colors.blueGrey.shade700),
    );
  }
}
