class Reading {
  final String deviceId;
  final DateTime timestamp;
  final Map<String, dynamic> readings;

  Reading({required this.deviceId, required this.timestamp, required this.readings});

  // Factory constructor to create a Reading instance from JSON data
  factory Reading.fromJson(Map<String, dynamic> json) {
    return Reading(
      deviceId: json['device_id'],  // Extract device ID from JSON
      timestamp: DateTime.parse(json['timestamp']),  // Convert timestamp string to DateTime
      readings: Map<String, dynamic>.from(json['readings']),  // Extract readings data
    );
  }
}