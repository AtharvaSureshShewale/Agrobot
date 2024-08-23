import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class WaterScreen extends StatefulWidget {
  final double waterPercentage; // Declare waterPercentage as final
  WaterScreen({Key? key, required this.waterPercentage}) : super(key: key); // Fix super constructor invocation

  @override
  State<WaterScreen> createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {
  double waterPercentage=0.0;

  @override
  void initState() {
    super.initState();
    waterPercentage = widget.waterPercentage;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    super.dispose();
  }

  Color getColorAndPercentage(double percentage) {
    if (percentage < 0.3) {
      return Colors.red;
    } else if (percentage >= 0.3 && percentage <= 0.7) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Water Quality',
                style: TextStyle(fontSize: 50),
              ),
              const SizedBox(height: 50),
              CircularPercentIndicator(
                animation: true,
                animationDuration: 1000,
                radius: 100,
                lineWidth: 20,
                percent: waterPercentage,
                progressColor: getColorAndPercentage(waterPercentage),
                backgroundColor: getColorAndPercentage(waterPercentage)
                    .withOpacity(0.2),
                circularStrokeCap: CircularStrokeCap.round,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      IconData(0xf05a2, fontFamily: 'MaterialIcons'),
                      size: 50,
                      color: Colors.blue,
                    ),
                    Text(
                      '${(waterPercentage * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(fontSize: 40),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
