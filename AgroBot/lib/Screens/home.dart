import 'dart:convert';
import 'dart:async';
import 'package:agrobot/Screens/login_screen.dart';
import 'package:agrobot/Screens/splash_screen.dart';
import 'package:agrobot/styles/energy.dart';
import 'package:agrobot/styles/crop.dart';
import 'package:agrobot/styles/soil.dart';
import 'package:agrobot/styles/water.dart';
import 'package:agrobot/styles/weather.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ResponsiveJoystickExampleApp extends StatefulWidget {
  final BluetoothConnection? connection;
  final double waterPercentage = 0.0;
  final double soilMoisture=0.0;
  final int batteryLevel=0;
  
  const ResponsiveJoystickExampleApp({super.key, this.connection});

  @override
  State<ResponsiveJoystickExampleApp> createState() => _ResponsiveJoystickExampleAppState();
}

class _ResponsiveJoystickExampleAppState extends State<ResponsiveJoystickExampleApp> {

  double soilMoisture=0.0;
  double waterPercentage=0.0;
  int batteryLevel=0;

  StreamSubscription? _subscription;

    void sendMessageToDevice(String msg) {
    String message = msg;

    if (widget.connection != null) {
      widget.connection!.output.add(utf8.encode(message));
      widget.connection!.output.allSent.then((_) {
        // Message sent successfully
        debugPrint('Message sent: $message');
        _subscribeToData(); // Call subscribe method after message is sent
      }).catchError((error) {
        // Error occurred while sending message
        debugPrint('Error sending message: $error');
      });
    } else {
      // Connection is null, handle accordingly
      debugPrint('Bluetooth connection is not available');
    }
  }

void _subscribeToData() {
  // Cancel previous subscription if exists
  _subscription?.cancel();
  _subscription = widget.connection!.input!.listen((List<int> data) {
    final receivedString = utf8.decode(data);
    if(mounted){
      setState(() {
        // Split the received string by commas
        List<String> parts = receivedString.split(',');
        
        // Extract data and parse if necessary
        String waterPercentageString = parts[1];
        double waterPercentage = double.tryParse(waterPercentageString) ?? 0.0;
        
        String soilMoistureString = parts[0];
        double soilMoisture = double.tryParse(soilMoistureString) ?? 0.0;
        
        String batteryLevelString = parts[2];
        int batteryLevel = int.tryParse(batteryLevelString) ?? 0;
        
        // Pass the parsed data to the respective classes
        if (waterPercentage >= 0.0 && waterPercentage <= 1.0) {
          Water(waterPercentage: waterPercentage);
        }
        
        if (soilMoisture >= 0.0 && soilMoisture <= 100.0) {
          Soil(soilMoisture: soilMoisture);
        }
        
        if (batteryLevel >= 0 && batteryLevel <= 100) {
          Energy(batteryLevel: batteryLevel);
        }
        
        // Update the waterPercentage state variable if needed
        this.waterPercentage = waterPercentage;
        this.soilMoisture=soilMoisture;
        this.batteryLevel=batteryLevel;
      });
    }
  });
}

    void sendMessage(String msg) {
    String message = msg;

    if (widget.connection != null) {
      widget.connection!.output.add(utf8.encode(message));
      widget.connection!.output.allSent.then((_) {
        // Message sent successfully
        debugPrint('Message sent: $message');
        _subscribeToData(); // Call subscribe method after message is sent
      }).catchError((error) {  
        // Error occurred while sending message
        debugPrint('Error sending message: $error');
      });
    } else {
      // Connection is null, handle accordingly
      debugPrint('Bluetooth connection is not available');
    }
  }

  double _x = 0;
  double _y = 0;

  // Function to scale the joystick input to 0-255
  int scaleTo255(double value) {
    // Map the value from -1 to 1 to -255 to 255
    return ((value + 1) / 2 * 255).round().clamp(0, 255);
  }

  void sendMessageToJoyStick(String message) {
    if (widget.connection != null) {
      widget.connection!.output.add(utf8.encode("$message\r\n"));
      widget.connection!.output.allSent.then((_) {
        debugPrint('Message sent: $message');
      });
    } else {
      debugPrint('Not connected to any device.');
    }
  }

  @override
  Widget build(BuildContext context) {
    sendMessageToDevice("0xV");
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFFDAFFF2),
            title: const Text(
              'AgroBot',
              style: TextStyle(
                color: Color(0xFF006D44),
                fontFamily: 'UbuntuCondensed',
                fontWeight: FontWeight.bold,
              ),
            ),
            
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) async {
                    if (kDebugMode) {
                      print("Signed Out");
                    }
                    var sharedPref = await SharedPreferences.getInstance();
                    sharedPref.setBool(SplashScreenState.keyLogin, false);
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                  }).onError((error, stackTrace) {
                    if (kDebugMode) {
                      print("Error ${error.toString()}");
                    }
                  });
                },
              ),
            ],
          ),
          body: Row(
            children: [
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.topLeft,
                        child: const Text(
                          'Functions',
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'UbuntuCondensed',
                            color: Color(0xFF006D44),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: SizedBox(
                          width: double.infinity,
                          height: constraints.maxHeight * 0.60,
                          child: Wrap(
                            spacing: 5,
                            runSpacing: 10,
                            alignment: WrapAlignment.start,
                            children: [
                              ButtonDesign(
                                text1: 'Plowing',
                                iconData: FontAwesomeIcons.tractor,
                                text2: 'Plowing Started',
                                onPressed: () {
                                  sendMessage("0xA");
                                },
                              ),
                              ButtonDesign(
                                text1: 'Seedling',
                                iconData: FontAwesomeIcons.seedling,
                                text2: 'Seedling Started',
                                onPressed: () {
                                  sendMessage("0xB");
                                },
                              ),
                              ButtonDesign(
                                text1: 'Watering',
                                iconData: FontAwesomeIcons.droplet,
                                text2: 'Watering Started',
                                onPressed: () {
                                  sendMessage("0xC");
                                },
                              ),
                              ButtonDesign(
                                text1: 'All Above',
                                iconData: FontAwesomeIcons.gears,
                                text2: 'All 3 Above',
                                onPressed: () {
                                  sendMessage("0xD");
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.05),
                      Container(
                        padding: const EdgeInsets.all(20),
                        alignment: Alignment.topLeft,
                        child: const Text(
                          'Monitoring',
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'UbuntuCondensed',
                            color: Color(0xFF006D44),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: SizedBox(
                          width: double.infinity,
                          height: constraints.maxHeight * 0.60,
                          child: Wrap(
                            spacing: 5,
                            runSpacing: 10,
                            alignment: WrapAlignment.start,
                            children: [
                              Soil(soilMoisture: soilMoisture),
                              Water(waterPercentage: waterPercentage), // Passing the connection
                              Energy(batteryLevel:batteryLevel),
                              const Weather(),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.10),
                      Container(
                        padding: const EdgeInsets.all(20),
                        alignment: Alignment.topLeft,
                        child: const Text(
                          'Analytics',
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'UbuntuCondensed',
                            color: Color(0xFF006D44),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: SizedBox(
                          width: double.infinity,
                          height: constraints.maxHeight * 0.40,
                          child: const Wrap(
                            spacing: 5,
                            runSpacing: 10,
                            alignment: WrapAlignment.start,
                            children: [
                              Crop(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SafeArea(
                      child: Stack(
                        children: [
                          Align(
                            alignment: const Alignment(0, 0.8),
                            child: Joystick(
                              mode: JoystickMode.all,
                              listener: (details) {
                                // Update the x and y values when joystick moves
                                setState(() {
                                  _x = details.x;
                                  _y = details.y;
                                });

                                // Send the x and y values to the connected device
                                sendMessageToJoyStick("X: ${scaleTo255(_x)}, Y: ${scaleTo255(_y)}");
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ButtonDesign extends StatefulWidget {
  final String text1;
  final IconData iconData;
  final String text2;
  final void Function() onPressed;

  const ButtonDesign({
    Key? key,
    required this.text1,
    required this.iconData,
    required this.text2,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<ButtonDesign> createState() => _ButtonDesignState();
}

class _ButtonDesignState extends State<ButtonDesign> {
  bool _isClicked = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(80, 120),
        backgroundColor:!_isClicked ? const Color(0xFFDAFFF2) : const Color(0xFF006D44),
      ),
      onPressed:() {
        setState(() {
          _isClicked = !_isClicked; // Toggle _isClicked state
        });
        widget.onPressed(); // Call the onPressed function provided by the parent widget
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(widget.iconData, size: 40,color:!_isClicked?const Color(0xFF006D44): const Color(0xFFDAFFF2),),
          Text(widget.text1, style: TextStyle(fontSize: 20, fontFamily: 'UbuntuCondensed',color: !_isClicked ?const Color(0xFF006D44): const Color(0xFFDAFFF2))),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ResponsiveJoystickExampleApp(),
  ));
}
