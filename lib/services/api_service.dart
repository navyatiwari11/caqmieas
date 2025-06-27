import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/reading_model.dart';  // Adjust the import as needed

class ApiService {
  // Replace this with the actual IP and port of your local backend server
  final String baseUrl ="http://192.168.253.170:3000";

  // Fetch all readings from the backend
  Future<List<Reading>> fetchAllReadings() async {
    final response = await http.get(Uri.parse('$baseUrl/data/device_001'));
    // Check if the response status is OK (200)
    if (response.statusCode == 200) {
      // Decode the JSON response
      List<dynamic> data = json.decode(response.body);
      // Convert JSON data to List of Reading objects
      return data.map((json) => Reading.fromJson(json)).toList();
    } else {
      // Throw an error if the request failed
      throw Exception('Failed to load readings');
    }
  }

  // Fetch readings for a specific device using its deviceId
  Future<List<Reading>> fetchReadingsByDevice(String deviceId) async {
    final response = await http.get(Uri.parse('$baseUrl/data/$deviceId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Reading.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load readings for device: $deviceId');
    }
  }

  // Fetch unique device IDs from the backend
  Future<List<String>> fetchDeviceIds() async {
    final response = await http.get(Uri.parse('$baseUrl/devices')); // Fetch from /devices endpoint
    if (response.statusCode == 200) {
      return List<String>.from(json.decode(response.body)); // Parse response as List<String>
    } else {
      throw Exception('Failed to load device IDs');
    }
  }
}