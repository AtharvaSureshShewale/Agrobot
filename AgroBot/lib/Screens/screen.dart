import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';



class Sample extends StatefulWidget {
  const Sample({super.key});

  @override
  State<Sample> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Sample> {
  List<BluetoothDevice> devicesList = [];

  @override
  void initState() {
    super.initState();
    startBluetoothScan();
  }

  void startBluetoothScan() async {
    // Start scanning
    await FlutterBluePlus.startScan(timeout: Duration(seconds: 4));

    // Listen to scanned devices
    FlutterBluePlus.scanResults.listen((List<ScanResult> scanResults) {
      // Update the devices list
      setState(() {
        devicesList.clear(); // Clear the previous list
        for (ScanResult scanResult in scanResults) {
          devicesList.add(scanResult.device);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BLE Devices'),
      ),
      body: ListView.builder(
        itemCount: devicesList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(devicesList[index].advName),
            subtitle: Text(devicesList[index].remoteId.toString()),
            // You can add more information if needed
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    super.dispose();
  }
}
