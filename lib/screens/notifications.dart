import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.blue,  // You can change this to any color
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: 10,  // Example: 10 notifications (you can fetch this dynamically)
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: Icon(Icons.notification_important, color: Color(0xFF191E4A)),
                title: Text(
                  'Notification Title #$index',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  'This is a description of the notification #$index.',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                onTap: () {
                  // Handle tap on notification item (you can navigate to detailed view if needed)
                  print('Tapped on notification #$index');
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
