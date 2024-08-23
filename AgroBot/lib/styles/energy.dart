import 'package:flutter/material.dart';
import 'package:agrobot/Screens/battery_screen.dart';
import 'package:agrobot/styles/button1.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Energy extends StatefulWidget {
  final int batteryLevel;

  const Energy({super.key, required this.batteryLevel});

  @override
  State<Energy> createState() => _EnergyState();
}

class _EnergyState extends State<Energy> {
    late int batteryLevel;

   @override
  void initState() {
    batteryLevel = widget.batteryLevel;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: buttonPrimary(minimumSize: const Size(120, 120)),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => BatteryScreen(batteryLevel:widget.batteryLevel)));
      },
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(FontAwesomeIcons.batteryQuarter, size: 40),
          Text('Battery', style: TextStyle(fontSize: 20, fontFamily: 'UbuntuCondensed')),
        ],
      ),
    );
  }
}
