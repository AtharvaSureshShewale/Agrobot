import 'package:agrobot/API/consts.dart';
import 'package:weather/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';


class SoilScreen extends StatefulWidget {
  final double soilMoisture; // Declare waterPercentage as final
  const SoilScreen({super.key, required this.soilMoisture}); // Fix super constructor invocation

  @override
  State<SoilScreen> createState() => _SoilScreenState();
}

class _SoilScreenState extends State<SoilScreen> {
  double soilMoisture =0.0;
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);

  Weather? _weather;

  @override
  void initState() {
    super.initState();
    soilMoisture = widget.soilMoisture;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _getLocationAndWeather();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    super.dispose();
  }

  Future<void> _getLocationAndWeather() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _fetchWeather(position.latitude, position.longitude);
  }

  Future<void> _fetchWeather(double latitude, double longitude) async {
    Weather? weather = await _wf.currentWeatherByLocation(latitude, longitude);
    setState(() {
      _weather = weather;
    });
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

  Widget _buildUI() {
    if (_weather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Container(
          child: _locationHeader(),
    );
  }

  Widget _locationHeader() {
    String areaName = _weather?.areaName ?? "";

    if(areaName=='Konkan Division'){
      return const Column(
        children: [
          Text("1.Rice",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          Text("2.Coconut",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          Text("3.Cashew",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          Text("4.Mango",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          Text("5.Kokum",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
        ],
      );
    }
    else if(areaName=='Pune Division'){
      return const Column(
        children: [
          Text("1.Sugarcane",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          Text("2.Grapes",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          Text("3.Wheat",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          Text("4.Soybean",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          Text("5.Sorghum (Jowar)",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
        ],
      );
    }
    else if(areaName=='Nashik Division'){
      return const Column(
        children: [
          Text("1.Grapes",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          Text("2.Onions",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          Text("3.Tomatoes",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          Text("4.Wheat",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          Text("5.Sorghum (Jowar)",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
        ],
      );
    }
    else if(areaName=='Nagpur Division'){
      return const Column(
        children: [
          Text("1.Soybean",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          Text("2.Cotton",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          Text("3.Pigeon pea (Tur)",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          Text("4.Sorghum (Jowar)",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          Text("5.Maize",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
        ],
      );
    }
    else if(areaName=='Aurangabad Division'){
      return const Column(
        children: [
          Text("1.Grapes",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          Text("2.Pomegranate",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          Text("3.Soybean",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          Text("4.Wheat",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          Text("5.Sorghum (Jowar)",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
        ],
      );
    }
    else if(areaName=='Amravati Division'){
      return const Column(
        children: [
          Text("1.Cotton",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          Text("2.Soybean",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          Text("3.Sorghum (Jowar)",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          Text("4.Pigeon pea (Tur)",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
          Text("5.Maize",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
        ],
      );
    }
    else{
      return const Text("",
      style:  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),);
    }
  }


  @override
  Widget build(BuildContext context) {
     String areaName = _weather?.areaName ?? "";
      return Scaffold(
      body: Center(
        child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 100,),
                const Text(
                  'Moisture',
                  style: TextStyle(fontSize: 50),
                ),
                const SizedBox(height: 50),
                CircularPercentIndicator(
                  animation: true,
                  animationDuration: 1000,
                  radius: 100,
                  lineWidth: 20,
                  percent: soilMoisture,
                  progressColor: getColorAndPercentage(soilMoisture),
                  backgroundColor: getColorAndPercentage(soilMoisture)
                      .withOpacity(0.2),
                  circularStrokeCap: CircularStrokeCap.round,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        IconData(0xf05a2, fontFamily: 'MaterialIcons'),
                        size: 50,
                        color: Colors.blue,
                      ),
                      Text(
                        '${(soilMoisture * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(fontSize: 40),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50,),
                Text(areaName,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                Expanded(
                child: _buildUI(),
                ),
              ],
            ),
      ),
    );
  }
}
