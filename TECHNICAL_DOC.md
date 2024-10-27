## Flight Tracking App - Technical Documentation

# Overview

The Flight Tracking App is built using Flutter to provide real-time flight data, displaying arrivals, departures, and status updates. It uses the Aviationstack API for data and includes features like auto-refresh, filtering, and error handling.

# Project Structure

lib/
├── main.dart               # Main entry point of the app
├── flights_page.dart       # UI and logic for the Flights screen
├── welcome_page.dart       # Welcome screen with navigation
├── api_service.dart        # API integration and data fetching logic
test/
└── widget_test.dart        # Widget testing for app screens

# Key Files and Functions

_main.dart: 
Initializes the app and directs users to the WelcomePage.

_welcome_page.dart: 
Contains the landing page UI and a button that navigates to the flight list.

_flights_page.dart: 
Displays the list of flights with details like flight number, origin, destination, and status, implements auto-refresh, manual refresh, and filtering options.

_api_service.dart:
Handles API requests to the Aviationstack API.
Manages query parameters for filtering data and provides error handling.

# Core Functionalities

1. UI/UX

Welcome Page: 
A simple welcome screen allowing navigation to the Flights page.

Flights Page:
ListView displays flight details (number, destination, departure time, status).
Color-coded statuses (e.g., green for "On Time", red for "Delayed").
Filtering dropdowns to display specific airports.

2. API Integration

The app integrates with Aviationstack API to fetch real-time flight data.

Endpoint Used: /flights
Filtering: Supports filtering by specific airports for departures and arrivals (e.g., LAX, DBX, CDG).
Data Update: Automatically refreshes every 10 seconds, with manual pull-to-refresh support.

Key Function in api_service.dart:

Future<List<dynamic>> fetchFlights(String? departure, String? arrival) async {
//Connects to API, applies filters, and returns data
}

3. Error Handling

API Failures: Displays an error message on the UI with a retry option if API fetch fails.
No Data: Shows a "No Data Available" message if no flights match the filters.

4. Refresh Mechanisms

Auto-Refresh: Uses a Timer to refresh flight data every 10 seconds.
Manual Refresh: Pull-to-refresh implemented on the ListView.
Toggle Button: Allows users to enable/disable auto-refresh.

5. Testing

Located in test/widget_test.dart, tests cover:
Widget rendering and basic functionality.
Simulating user interactions (e.g., toggling auto-refresh, refreshing manually).

# Libraries and Packages

Flutter Material: Provides UI components.
HTTP: Facilitates API requests to the Aviationstack API.
intl: Formats timestamps for last-update display.
Test: For writing widget and unit tests.

# Future Enhancements

Expand Airport Selection: Allow users to search and select from a broader range of airports.
UI Improvements: Implement animations or transitions to enhance user experience.
Notification System: Add notifications for flight status changes.

# Deployment

APK Generation: Run flutter build apk to generate the APK for deployment.
Publishing: Consider deploying on Google Play or using App Distribution tools for beta testing.
