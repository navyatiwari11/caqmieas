import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/data_provider.dart';
import '../services/api_service.dart';
import '../models/reading_model.dart';
import '../screens/menu.dart';
import '../screens/stations.dart';
import '../screens/notifications.dart';
import '../screens/view_insights_screen.dart';
import '../services/socket_service.dart';

class MorningScreen extends StatefulWidget {
  @override
  _MorningScreenState createState() => _MorningScreenState();
}

class _MorningScreenState extends State<MorningScreen> {
  String selectedStation = "device_001"; // Default station
  String aqiStatus = 'Moderate';
  Color buttonColor = Color(0xCCFCDA73);

  double? _liveAQI;
  double? _livePM25;
  double? _livePM10;
  double? _liveTemperature;
  double? _liveHumidity;
  double? _liveCO2ppm;
  double? _liveNH3ppm;
  double? _liveCOppm;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<SensorDataProvider>(context, listen: false);
      provider.connectToServer();
      provider.fetchData();
    });
    SocketService().connect((data) {
    final readings = data['readings'];
    if (readings == null) return;
    setState(() {
      _liveAQI = readings['AQI']?.toDouble();
      _livePM25 = readings['PM2_5']?.toDouble();
      _livePM10 = readings['PM10']?.toDouble();
      _liveTemperature = readings['Temperature']?.toDouble();
      _liveHumidity = readings['Humidity']?.toDouble();
      _liveCO2ppm = readings['CO2ppm']?.toDouble();
      _liveNH3ppm = readings['NH3ppm']?.toDouble();
      _liveCOppm = readings['COppm']?.toDouble();

      final provider = Provider.of<SensorDataProvider>(context, listen: false);
      provider.sensorData['device_001'] = {
        'AQI': _liveAQI,
        'Temperature': _liveTemperature,
        'Humidity': _liveHumidity,
        'PM2_5': _livePM25,
        'PM10': _livePM10,
        'CO2ppm': _liveCO2ppm,
        'NH3ppm': _liveNH3ppm,
        'COppm': _liveCOppm,
      };
    });
  });
  }

  void _updateAQIStatus(dynamic aqiValue) {
    int aqi = _liveAQI?.round() ?? 0;
    if (aqi >= 0 && aqi <= 50) {
      aqiStatus = 'Good';
      buttonColor = Colors.green;
    } else if (aqi >= 51 && aqi <= 100) {
      aqiStatus = 'Moderate';
      buttonColor = Color(0xCCFCDA73);
    } else if (aqi >= 101 && aqi <= 150) {
      aqiStatus = 'Poor';
      buttonColor = Colors.orange;
    } else if (aqi >= 151 && aqi <= 200) {
      aqiStatus = 'Unhealthy';
      buttonColor = Colors.red;
    } else if (aqi >= 201 && aqi <= 300) {
      aqiStatus = 'Severe';
      buttonColor = Colors.purple;
    } else if (aqi >= 301) {
      aqiStatus = 'Hazardous';
      buttonColor = Colors.brown;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SensorDataProvider>(context);
    final sensorData = provider.sensorData;
    final latestReading = sensorData[selectedStation] ?? {};
    final aqiValue = latestReading['AQI'] ?? 0;

    _updateAQIStatus(aqiValue);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MenuScreen()),
            );
          },
        ),
        title: GestureDetector(
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StationsScreen(
                  availableStations: ["device_001", "device_002", "All"],
                ),
              ),
            );
            if (result != null && result is String) {
              setState(() {
                selectedStation = result;
              });
            }
          },
          child: Text(
            selectedStation,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsScreen()),
              );
            },
          ),
        ],
      ),
      body: sensorData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/morning_background.jpg'),
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Center(
                          child: Container(
                            height: 250,
                            width: 250,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.4),
                              border: Border.all(
                                color: Colors.white,
                                width: 1.0,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'AQI',
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${aqiValue ?? 'N/A'}',
                                  style: GoogleFonts.inter(
                                    fontSize: 70,
                                    fontWeight: FontWeight.w100,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'μg/m³',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: buttonColor,
                                  ),
                                  child: Text(
                                    aqiStatus,
                                    style: GoogleFonts.outfit(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Main Pollutant: ${_getMainPollutant(latestReading)}',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            decorationColor: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 1.0, bottom: 12.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewInsightsScreen(
                                      stationId: 'device_001'),
                                ),
                              );
                            },
                            child: Text(
                              'View Insights',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        Divider(color: Colors.white70, thickness: 0.8),

                        //Scrollable Content
                        Expanded(
                          child: ListView(
                            children: [
                              // 🔹 Temperature and Humidity Info Cards moved inside scroll
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _infoCard(
                                    'Temperature',
                                    '${latestReading['Temperature'] ?? 'N/A'} °C',
                                    Icons.thermostat,
                                  ),
                                  _infoCard(
                                    'Humidity',
                                    '${latestReading['Humidity'] ?? 'N/A'} %',
                                    Icons.water_drop,
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),

                              // 🔹 Pollutant + scale rows
                              _pollutantRow(
                                context,
                                'Particulate Matter 2.5: ${latestReading['PM2_5'] ?? 'N/A'} μg/m³',
                              ),
                              _pollutantRow(
                                context,
                                'Particulate Matter 10: ${latestReading['PM10'] ?? 'N/A'} μg/m³',
                              ),
                              _pollutantRow(
                                context,
                                'Carbon Dioxide (CO₂): ${latestReading['CO2ppm'] ?? 'N/A'} ppm',
                              ),
                              _pollutantRow(
                                context,
                                'Ammonia (NH₃): ${latestReading['NH3ppm'] ?? 'N/A'} ppm',
                              ),
                              _pollutantRow(
                                context,
                                'Carbon Monoxide (CO): ${latestReading['COppm'] ?? 'N/A'} ppm',
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  String _getMainPollutant(Map<String, dynamic> reading) {
    final pollutants = {
      'PM2.5': reading['PM2_5'] ?? 0.0,
      'PM10': reading['PM10'] ?? 0.0,
      'CO₂': reading['CO2ppm'] ?? 0.0,
      'NH₃': reading['NH3ppm'] ?? 0.0,
      'CO': reading['COppm'] ?? 0.0,
    };

    String mainPollutant = 'N/A';
    double maxVal = -1;

    pollutants.forEach((key, value) {
      if (value is num && value > maxVal) {
        maxVal = value.toDouble();
        mainPollutant = key;
      }
    });

    return '$mainPollutant';
  }

  Widget _infoCard(String title, String value, IconData icon) {
    return Container(
      height: 120,
      width: 150,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

    Widget _pollutantRow(BuildContext context, String label) {
    final fieldMap = {
      'Particulate Matter 2.5': 'PM2_5',
      'Particulate Matter 10': 'PM10',
      'Carbon Dioxide (CO₂)': 'CO2ppm',
      'Ammonia (NH₃)': 'NH3ppm',
      'Carbon Monoxide (CO)': 'COppm',
    };

    final pollutantName = label.split(':').first.trim();
    final pollutantKey = fieldMap[pollutantName] ?? '';

    final valueMatch = RegExp(r'([\d.]+)').firstMatch(label);
    final value = valueMatch != null ? double.tryParse(valueMatch.group(1)!) ?? 0.0 : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ],  
      
    );
  }
}
