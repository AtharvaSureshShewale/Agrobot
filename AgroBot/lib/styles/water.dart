import 'package:flutter/material.dart';
import 'package:agrobot/Screens/water_screen.dart';
import 'package:agrobot/styles/button1.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Water extends StatefulWidget {
  final double waterPercentage; // Declare waterPercentage as final
  const Water({super.key, required this.waterPercentage}); // Fix super constructor invocation

  @override
  State<Water> createState() => _WaterState();
}

class _WaterState extends State<Water> {
  late double waterPercentage;

  @override
  void initState() {
    waterPercentage = widget.waterPercentage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: buttonPrimary(minimumSize: const Size(120, 120)),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => WaterScreen(waterPercentage: widget.waterPercentage)));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(FontAwesomeIcons.water, size: 40),
          Text('Water', style: TextStyle(fontSize: 20, fontFamily: 'UbuntuCondensed')),
        ],
      ),
    );
  }
}
