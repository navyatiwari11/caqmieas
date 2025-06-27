import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class RealtimeReadingsPage extends StatefulWidget {
  @override
  _RealtimeReadingsPageState createState() => _RealtimeReadingsPageState();
}

class _RealtimeReadingsPageState extends State<RealtimeReadingsPage> {
  late IO.Socket socket;
  Map<String, dynamic>? latestReading;

  @override
  void initState() {
    super.initState();
    connectToSocket();
  }

  void connectToSocket() {
    // Connect to the WebSocket server
    socket = IO.io('http://192.168.17.156:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    // Listen for connection events
    socket.onConnect((_) {
      print('Connected to WebSocket server');
    });

    // Listen for new readings
    socket.on('newReading', (data) {
      print('New Reading Received: $data');
      setState(() {
        latestReading = data;
      });
    });

    // Listen for disconnection
    socket.onDisconnect((_) {
      print('Disconnected from WebSocket server');
    });
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Real-Time Readings'),
      ),
      body: latestReading == null
          ? Center(child: Text('No data yet'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Device: ${latestReading!['device_id']}'),
                  Text('PM2.5: ${latestReading!['readings']['PM2_5']}'),
                  Text('PM10: ${latestReading!['readings']['PM10']}'),
                  Text('Temperature: ${latestReading!['readings']['Temperature']}°C'),
                  Text('Timestamp: ${latestReading!['timestamp']}'),
                ],
              ),
            ),
    );
  }
}