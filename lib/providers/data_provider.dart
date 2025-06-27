import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SensorDataProvider with ChangeNotifier {
  Map<String, dynamic> _sensorData = {};

  Map<String, dynamic> get sensorData => _sensorData;

  Future<void> fetchData() async {
    try {
      await Future.delayed(Duration(seconds: 2));
      if (_sensorData.isEmpty) {
        _sensorData = {
          "device_001": {
            "AQI": 0,
            "Temperature": 0,
            "Humidity": 0,
            "PM2_5": 0,
            "PM10": 0,
            "CO2ppm": 0,
            "NH3ppm": 0,
            "COppm": 0,
          },
        };
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void connectToServer() {
    IO.Socket socket = IO.io('http://192.168.17.156:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.on('connect', (_) {
      print('Connected to backend server');
    });

    socket.on('updateData', (data) {
      try {
        print('Raw data received: $data'); // Debug: Check raw incoming data
        final Map<String, dynamic> parsedData = data is String
            ? json.decode(data)
            : Map<String, dynamic>.from(data);

        // Transform the data to use `device_id` as the key
        final String deviceId = parsedData['device_id'];
        final readings = parsedData['readings'];

        if (deviceId != null && readings != null) {
          _sensorData[deviceId] = readings;
        }

        notifyListeners(); // Notify listeners to update the UI
        print('Updated _sensorData: $_sensorData'); // Debug: Check transformed data
      } catch (e) {
        print('Error parsing data: $e');
      }
    });


    socket.on('disconnect', (_) {
      print('Disconnected from backend server');
    });

    socket.on('connect_error', (error) {
      print('Connection Error: $error');
    });

    socket.on('error', (error) {
      print('Error: $error');
    });    
  }
}