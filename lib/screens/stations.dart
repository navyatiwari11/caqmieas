import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StationsScreen extends StatefulWidget {
  final List<String> availableStations;
  StationsScreen({required this.availableStations});
  @override
  _StationsScreenState createState() => _StationsScreenState();
}

class _StationsScreenState extends State<StationsScreen> {
  String? selectedStation;

  @override
  void initState() {
    super.initState();
    if (widget.availableStations.isNotEmpty) {
      selectedStation = widget.availableStations[0]; // Default to the first station
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0D1134), // Background color of the app bar
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: Color(0xFF0D1134), // Dark background color
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location Title
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    selectedStation ?? 'No station selected',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Section Title
              Text(
                'Available Stations',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                ),
              ),
              SizedBox(height: 20),
              // Stations List
              stationButton("device_001"),
              SizedBox(height: 12),
              stationButton("device_002"),
              SizedBox(height: 12),
              stationButton("All"),
              Spacer(),
              // Done Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, selectedStation);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Button background color
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Done",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF0D1134), // Button text color
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16), // Add some spacing from the bottom
            ],
          ),
        ),
      ),
    );
  }

  // Widget for station buttons
  Widget stationButton(String stationName) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedStation = stationName; // Set the selected station
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selectedStation == stationName
              ? Colors.white.withOpacity(0.2)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.white,
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              stationName,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            Icon(
              selectedStation == stationName
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}