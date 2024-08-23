import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class BluetoothController extends GetxController {
  Stream<List<ScanResult>>? _scanResults;

  Future<void> scanDevices() async {
    // Starting scan
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

    // Set scanResults stream
    _scanResults = FlutterBluePlus.scanResults;

    // Notify listeners that scan results are available
    update();
  }

  Stream<List<ScanResult>>? get scanResults => _scanResults;
}
