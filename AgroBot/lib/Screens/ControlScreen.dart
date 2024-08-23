import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class ControlScreen extends StatelessWidget {
  final BluetoothConnection connection;

  ControlScreen(this.connection);

  void _sendMessageToConnectedDevice(String message) async {
    try {
      connection.output.add(utf8.encode(message));
      await connection.output.allSent;
      print('Message sent to device: $message');
    } catch (e) {
      print('Error sending message: $e');
      // Handle message sending error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control Screen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              _sendMessageToConnectedDevice("0xP"); // For Plowing
            },
            child: Text('Plowing'),
          ),
          ElevatedButton(
            onPressed: () {
              _sendMessageToConnectedDevice("0xS"); // For Seeding
            },
            child: Text('Seeding'),
          ),
          ElevatedButton(
            onPressed: () {
              _sendMessageToConnectedDevice("0xW"); // For Watering
            },
            child: Text('Watering'),
          ),
          ElevatedButton(
            onPressed: () {
              _sendMessageToConnectedDevice("0xA"); // For All Above
            },
            child: Text('All Above'),
          ),
          ElevatedButton(
            onPressed: () {
              _sendMessageToConnectedDevice("0xR"); // For Spraying
            },
            child: Text('Spraying'),
          ),
        ],
      ),
    );
  }
}
