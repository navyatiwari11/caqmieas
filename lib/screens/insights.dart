import 'package:flutter/material.dart';

class InsightsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insights'),
      ),
      body: Center(
        child: Text(
          'Air Quality Insights and Analytics will be displayed here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
