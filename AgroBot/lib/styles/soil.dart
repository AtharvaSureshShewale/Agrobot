import 'package:agrobot/Screens/soil_screen.dart';
import 'package:flutter/material.dart';
import 'package:agrobot/styles/button1.dart';

class Soil extends StatefulWidget {
  final double soilMoisture; // Declare waterPercentage as final
  const Soil({super.key, required this.soilMoisture}); // Fix super constructor invocation

  @override
  State<Soil> createState() => _SoilState();
}

class _SoilState extends State<Soil> {
  double soilMoisture=0.0;

  @override
  void initState() {
    soilMoisture = widget.soilMoisture;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: buttonPrimary(minimumSize: const Size(120, 120)),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SoilScreen(soilMoisture: widget.soilMoisture)));
      },
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.landscape, size: 40),
          Text('Soil', style: TextStyle(fontSize: 20, fontFamily: 'UbuntuCondensed')),
        ],
      ),
    );
  }
}
