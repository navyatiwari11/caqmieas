import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = false;

  String selectedTimeZone = "GMT"; // Default time zone

  // Temperature, Time, and Date format states
  String selectedTemperatureUnit = "°C";
  String selectedTimeFormat = "24 hours format";
  String selectedDateFormat = "dd/mm/yyyy";

  // Dialog for selection
  void _showSelectionDialog(
      String title,
      List<String> options,
      String selectedOption,
      Function(String) onOptionSelected,
      ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              children: options.map((option) {
                return RadioListTile(
                  title: Text(option),
                  value: option,
                  groupValue: selectedOption,
                  onChanged: (value) {
                    onOptionSelected(value!);
                    Navigator.pop(context); // Close the dialog
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F8FF),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color(0xFFF0F8FF),
        elevation: 0,
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notifications Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.notifications, color: Colors.black),
                    SizedBox(width: 10),
                    Text('Notifications', style: TextStyle(fontSize: 16)),
                  ],
                ),
                Switch(
                  value: notificationsEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      notificationsEnabled = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),

            // Time Zone
            InkWell(
              onTap: () {
                _showSelectionDialog(
                  "Select Time Zone",
                  ["GMT", "PST", "EST", "IST"],
                  selectedTimeZone,
                      (selected) {
                    setState(() {
                      selectedTimeZone = selected;
                    });
                  },
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.black),
                      SizedBox(width: 10),
                      Text('Time zone', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Row(
                    children: [
                      Text(selectedTimeZone),
                      Icon(Icons.arrow_forward_ios, color: Colors.black, size: 16),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Units Section
            Text('Units', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 10),

            // Temperature
            InkWell(
              onTap: () {
                _showSelectionDialog(
                  "Select Temperature Unit",
                  ["°C", "°F"],
                  selectedTemperatureUnit,
                      (selected) {
                    setState(() {
                      selectedTemperatureUnit = selected;
                    });
                  },
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.thermostat, color: Colors.black),
                      SizedBox(width: 10),
                      Text('Temperature', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Row(
                    children: [
                      Text(selectedTemperatureUnit),
                      Icon(Icons.arrow_forward_ios, color: Colors.black, size: 16),
                    ],
                  ),
                ],
              ),
            ),
            Divider(),

            // Time Format
            InkWell(
              onTap: () {
                _showSelectionDialog(
                  "Select Time Format",
                  ["24 hours format", "12 hours format"],
                  selectedTimeFormat,
                      (selected) {
                    setState(() {
                      selectedTimeFormat = selected;
                    });
                  },
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time_outlined, color: Colors.black),
                      SizedBox(width: 10),
                      Text('Time format', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Row(
                    children: [
                      Text(selectedTimeFormat),
                      Icon(Icons.arrow_forward_ios, color: Colors.black, size: 16),
                    ],
                  ),
                ],
              ),
            ),
            Divider(),

            // Date Format
            InkWell(
              onTap: () {
                _showSelectionDialog(
                  "Select Date Format",
                  ["dd/mm/yyyy", "mm/dd/yyyy"],
                  selectedDateFormat,
                      (selected) {
                    setState(() {
                      selectedDateFormat = selected;
                    });
                  },
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.black),
                      SizedBox(width: 10),
                      Text('Date format', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Row(
                    children: [
                      Text(selectedDateFormat),
                      Icon(Icons.arrow_forward_ios, color: Colors.black, size: 16),
                    ],
                  ),
                ],
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
