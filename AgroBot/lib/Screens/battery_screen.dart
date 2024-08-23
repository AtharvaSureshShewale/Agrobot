import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class BatteryScreen extends StatefulWidget {
  final int batteryLevel;
  const BatteryScreen({super.key, required this.batteryLevel});

  @override
  State<BatteryScreen> createState() => _BatteryScreenState();
}

class _BatteryScreenState extends State<BatteryScreen> {
  int b=0;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late Battery battery;
  int level = 100;
  BatteryState batteryState = BatteryState.full;
  late Timer timer;
  late StreamSubscription streamSubscription;

  @override
  void initState() {
    b = widget.batteryLevel;
    super.initState();
    battery = Battery();
    initializeNotifications();
    requestNotificationPermissions();
    getBatteryPercentage();
    getBatteryState();
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      getBatteryPercentage();
    });
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  void initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
         AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'battery_channel',
      'Battery Notification',
      'Shows battery low notification',
      importance: Importance.max,
      playSound: true, // Enable sound for this channel
    );

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Set custom sound
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'battery_channel',
      'Battery Notification',
      'Shows battery low notification',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('assets/Sound/notification.mp3'), // Specify the custom sound file
    );

    // ignore: unused_local_variable
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
  }

  Future<void> requestNotificationPermissions() async {
    final status = await Permission.notification.request();
    if (status.isDenied) {
      // Handle the case if the user has denied permissions
    }
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'battery_channel',
      'Battery Notification',
      'Shows battery low notification',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Battery Low',
      'Please charge the robot!',
      platformChannelSpecifics,
      payload: 'battery_low',
    );
  }

  void getBatteryPercentage() async {
    int batteryLevel = b; // Manually set to 20 for testing
    setState(() {
      level = batteryLevel;
      if (level < 30) {
        showNotification();
      }
    });
  }

  void getBatteryState() {
    streamSubscription = battery.onBatteryStateChanged.listen((state) {
      setState(() {
        batteryState = state;
      });
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    super.dispose();
    streamSubscription.cancel();
    timer.cancel();
  }

  Widget buildBattery(BatteryState state) {
    Color batteryColor = Colors.green;
    IconData batteryIcon = Icons.battery_full;

    if (level < 30) {
      batteryColor = Colors.red;
      batteryIcon = Icons.battery_alert;
    } else if (level < 80) {
      batteryColor = Colors.yellow;
      batteryIcon = Icons.battery_std;
    } else if (state == BatteryState.charging) {
      batteryColor = Colors.blue;
      batteryIcon = Icons.battery_charging_full;
    }

    return SizedBox(
      width: 200,
      height: 200,
      child: Icon(
        batteryIcon,
        size: 200,
        color: batteryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Robot Battery',
                style: TextStyle(fontSize: 50),
              ),
              buildBattery(batteryState),
              Text(
                '$level %',
                style: const TextStyle(color: Colors.black, fontSize: 25),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
