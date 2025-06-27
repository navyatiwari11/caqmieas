import 'package:flutter/material.dart';
import '../screens/manage_location.dart';
import '../screens/help.dart';
import '../screens/settings.dart';
import '../screens/privacy_policy.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        children: [
          // Menu Section (occupies part of the screen)
          Container(
            width: MediaQuery.of(context).size.width * 0.75, // 75% of the screen width
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40), // Adjust for status bar
                  Text(
                    'MENU',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(thickness: 1, color: Colors.black),
                  SizedBox(height: 16),
                  ListTile(
                    leading: Icon(Icons.help),
                    title: Text('Help'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HelpScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.description),
                    title: Text('Privacy policy'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Transparent background for the rest of the screen
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context); // Close the menu when tapping outside
              },
              child: Container(
                color: Color(0x660D1134), // Semi-transparent overlay
              ),
            ),
          ),
        ],
      ),
    );
  }
}
