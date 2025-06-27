import 'package:flutter/material.dart';
import '../services/api_service.dart'; 
import '../models/reading_model.dart';  

class ReadingsPage extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Air Quality Readings for Device_001'),
      ),
      body: FutureBuilder<List<Reading>>(
        // Fetch data for device_001
        future: apiService.fetchReadingsByDevice('device_001'),
        builder: (context, snapshot) {
          // Check if the data is still loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } 
          // Check if an error occurred
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } 
          // If no data is available
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No readings available for device_001'));
          } 
          // If data is available
          else {
            final readings = snapshot.data!;
            return ListView.builder(
              itemCount: readings.length,
              itemBuilder: (context, index) {
                final reading = readings[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Device: ${reading.deviceId}'),
                    subtitle: Text(
                      'PM2.5: ${reading.readings['PM2_5']?? 'N/A'}\n'
                      'PM10: ${reading.readings['PM10']?? 'N/A'}\n'
                      'CO2: ${reading.readings['CO2ppm']?? 'N/A'} ppm\n'
                      'CO: ${reading.readings['COppm']?? 'N/A'} ppm\n'
                      'NH3: ${reading.readings['NH3ppm']?? 'N/A'} ppm\n'
                      'Temperature: ${reading.readings['Temperature']?? 'N/A'} °C\n'
                      'Humidity: ${reading.readings['Humidity']?? 'N/A'} %\n'
                      'Timestamp: ${reading.timestamp}',
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}