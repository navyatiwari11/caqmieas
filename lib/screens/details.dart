import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[50],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to the Help screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title
            Text(
              'Parameter Details',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // Parameter List
            Expanded(
              child: ListView(
                children: [
                  parameterItem('AQI', 'Air Quality Index, an indicator of air pollution.'),
                  parameterItem('Temperature', 'The ambient temperature in degrees Celsius.'),
                  parameterItem('Humidity', 'The amount of moisture in the air, in percentage.'),
                  parameterItem('PM 2.5', 'Particulate matter smaller than 2.5 microns.'),
                  parameterItem('PM 10', 'Particulate matter smaller than 10 microns.'),
                  parameterItem('Carbon Dioxide', 'A naturally occurring greenhouse gas.'),
                  parameterItem('Ammonia', 'A gas with a pungent odor, commonly released from agriculture.'),
                  parameterItem('Carbon Monoxide', 'A colorless, odorless toxic gas from incomplete combustion.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for each parameter
  Widget parameterItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
          Divider(color: Colors.grey),
        ],
      ),
    );
  }
}
