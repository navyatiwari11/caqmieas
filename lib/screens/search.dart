import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  final List<String> popularLocations = [
    'Punjipathra',
    'New Delhi',
    'Mumbai',
    'Bangalore',
  ]; // Example dynamic list of popular locations

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x660D1134),
      appBar: AppBar(
        backgroundColor: Color(0x660D1134),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter the location',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Icon(Icons.map, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Popular Locations Header
            Text(
              'Popular locations',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // List of Locations
            Expanded(
              child: ListView.builder(
                itemCount: popularLocations.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          popularLocations[index],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        onTap: () {
                          // Handle location tap, e.g., show a dialog or return the selected location
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Selected location: ${popularLocations[index]}',
                              ),
                            ),
                          );
                        },
                      ),
                      Divider(color: Colors.grey),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
