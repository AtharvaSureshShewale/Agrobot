import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceListScreen extends StatefulWidget {
  const DeviceListScreen({Key? key}) : super(key: key);

  @override
  State<DeviceListScreen> createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  List<BluetoothDevice> devices = [];
  BluetoothConnection? connection;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _initBluetooth();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    super.dispose();
  }

  Future<void> _initBluetooth() async {
    final bool? isBluetoothEnabled = await FlutterBluetoothSerial.instance.isEnabled;
    if (isBluetoothEnabled!) {
      // Prompt the user to enable Bluetooth
      await FlutterBluetoothSerial.instance.requestEnable();
    }
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    // Request Bluetooth and location permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.location,
    ].request();

    // Check if permissions are granted
    if (statuses[Permission.bluetooth] != PermissionStatus.granted ||
        statuses[Permission.location] != PermissionStatus.granted) {
      debugPrint("Permission Not Granted");
      return;
    }

    // Permissions are granted, start scanning for devices
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
    }, onError: (dynamic error) {
      debugPrint("Error during device discovery: $error");
    });
  }

  void _connectToDevice(BluetoothDevice device) async {
    try {
      BluetoothConnection connection = await BluetoothConnection.toAddress(device.address);
      setState(() {
        this.connection = connection;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NextScreen(connection: connection)),
      );
    } catch (e) {
      debugPrint('Error connecting to device: $e');
      // Handle connection error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device List'),
      ),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(devices[index].name ?? 'Unknown'),
            onTap: () {
              _connectToDevice(devices[index]);
            },
          );
        },
      ),
    );
  }
}

class NextScreen extends StatelessWidget {
  final BluetoothConnection connection;

  const NextScreen({Key? key, required this.connection}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Implement your next screen here
    return Container(); // Placeholder
  }
}
