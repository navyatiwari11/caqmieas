import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? _socket;

  void connect(Function(Map<String, dynamic>) onDataReceived) {
    _socket = IO.io(
      'https://caqmieas-backend-650355947331.asia-south1.run.app',
      IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build(),
    );

    _socket?.onConnect((_) {
      print('Socket connected');
    });

    _socket?.on('sensorData', (data) {
      if (data is Map<String, dynamic>) {
        onDataReceived(data);
      }
    });

    _socket?.onDisconnect((_) => print('Socket disconnected'));

    _socket?.connect();
  }

  void dispose() {
    _socket?.disconnect();
    _socket?.destroy();
  }
}
