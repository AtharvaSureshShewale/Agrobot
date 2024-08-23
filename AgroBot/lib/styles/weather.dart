import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:agrobot/Screens/weather_screen.dart';
import 'package:agrobot/styles/button1.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Weather extends StatefulWidget {
  final BluetoothConnection? connection;

  const Weather({super.key, this.connection});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  // Function to send message to Bluetooth device
  void sendMessageToDevice(String msg) {
    // Replace 'your_message' with the actual message you want to send
    String message = msg;

    if (widget.connection != null) {
      widget.connection!.output.add(utf8.encode(message));
      widget.connection!.output.allSent.then((_) {
        // Message sent successfully
        debugPrint('Message sent: $message');
      }).catchError((error) {
        // Error occurred while sending message
        debugPrint('Error sending message: $error');
      });
    } else {
      // Connection is null, handle accordingly
      debugPrint('Bluetooth connection is not available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: buttonPrimary(minimumSize: const Size(120, 120)),
      onPressed: () {
        sendMessageToDevice("Weather Data"); // Call function to send message when button is pressed
        Navigator.push(context, MaterialPageRoute(builder: (context) => const WeatherScreen()));
      },
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(FontAwesomeIcons.cloudSunRain, size: 40),
          Text('Weather', style: TextStyle(fontSize: 20, fontFamily: 'UbuntuCondensed')),
        ],
      ),
    );
  }
}
