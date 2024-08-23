import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BluetoothScreen(),
    );
  }
}

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  BluetoothConnection? connection;

  @override
  void initState() {
    super.initState();
    connectToDevice();
  }

  Future<void> connectToDevice() async {
    List<BluetoothDevice> devices = [];
    try {
      devices = await FlutterBluetoothSerial.instance.getBondedDevices();
      // Assuming you have a bonded device and want to connect to the first one
      BluetoothDevice device = devices.first;
      BluetoothConnection newConnection = await BluetoothConnection.toAddress(device.address);
      setState(() {
        connection = newConnection;
      });
      // Start listening to data
      connection!.input!.listen((Uint8List data) {
        String message = String.fromCharCodes(data);
        // Check the content of the message and redirect accordingly
        if (message.contains("important")) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ImportantMessageScreen(message)),
          );
        } else if (message.contains("urgent")) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UrgentMessageScreen(message)),
          );
        } else {
          // Default screen for other messages
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DefaultMessageScreen(message)),
          );
        }
      });
    } catch (error) {
      print('Error connecting to device: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Demo'),
      ),
      body: Center(
        child: connection == null
            ? const Text('Device Not Connected')
            : Text('Connected to device: $connection'),
      ),
    );
  }
}

class ImportantMessageScreen extends StatelessWidget {
  final String message;

  ImportantMessageScreen(this.message);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Important Message'),
      ),
      body: Center(
        child: Text(message),
      ),
    );
  }
}

class UrgentMessageScreen extends StatelessWidget {
  final String message;

  UrgentMessageScreen(this.message);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Urgent Message'),
      ),
      body: Center(
        child: Text(message),
      ),
    );
  }
}

class DefaultMessageScreen extends StatelessWidget {
  final String message;

  DefaultMessageScreen(this.message);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Default Message'),
      ),
      body: Center(
        child: Text(message),
      ),
    );
  }
}
