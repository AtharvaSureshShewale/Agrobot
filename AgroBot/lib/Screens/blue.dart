import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BluetoothApp extends StatefulWidget {
  const BluetoothApp({super.key});

  @override
  State<BluetoothApp> createState() => _BluetoothAppState();
}

class _BluetoothAppState extends State<BluetoothApp> {
  List<BluetoothDevice> devices = [];
  BluetoothConnection? connection;

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  void _startScan() {
    FlutterBluetoothSerial.instance.getBondedDevices().then((List<BluetoothDevice> bondedDevices) {
      setState(() {
        devices.addAll(bondedDevices);
      });
    });

    FlutterBluetoothSerial.instance.startDiscovery().listen((BluetoothDiscoveryResult result) {
      setState(() {
        if (!devices.contains(result.device)) {
          devices.add(result.device);
        }
      });
    });
  }

  void _connectToDevice(BluetoothDevice device) async {
    try {
      BluetoothConnection connection = await BluetoothConnection.toAddress(device.address);
      setState(() {
        this.connection = connection;
      });
      if (kDebugMode) {
        print('Connected to ${device.name}');
      }
      Fluttertoast.showToast(
        msg: 'Connected to ${device.name}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error connecting to device: $e');
      }
      Fluttertoast.showToast(
        msg: 'Failed to connect to ${device.name}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void _sendMessageToConnectedDevice(String message) async {
    if (connection != null) {
      try {
        connection!.output.add(utf8.encode(message));
        await connection!.output.allSent;
        Fluttertoast.showToast(
          msg: 'Message sent to device',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
        );
      } catch (e) {
        if (kDebugMode) {
          print('Error sending message: $e');
        }
        Fluttertoast.showToast(
          msg: 'Failed to send message to device',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: 'No device connected',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Classic Example'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(devices[index].name.toString()),
                  onTap: () {
                    _connectToDevice(devices[index]);
                  },
                );
              },
            ),
          ),
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
