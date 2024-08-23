import 'package:agrobot/API/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

class SeedScreen extends StatefulWidget {
  const SeedScreen({Key? key}) : super(key: key);

  @override
  State<SeedScreen> createState() => _SeedScreenState();
}

class _SeedScreenState extends State<SeedScreen> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);

  Weather? _weather;

  @override
  void initState() {
    super.initState();
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

  @override
@override
Widget build(BuildContext context) {
  String areaName = _weather?.areaName ?? "";
  return Scaffold(
    body: Column(
      children: [
        Text(areaName),
        Expanded(
          child: _buildUI(),
        ),
      ],
    ),
  );
}
  Widget _buildUI() {
    if (_weather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
          Container(
          width: MediaQuery.of(context).size.width, // Set width to full screen width
          height: MediaQuery.of(context).size.height * 0.5, // Set height to 50% of screen height
          child: _locationHeader(),
        ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
            ),
          ],
        ),
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

}
