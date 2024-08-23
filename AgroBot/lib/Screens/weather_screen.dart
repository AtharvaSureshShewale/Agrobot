import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:geocoding/geocoding.dart';
import 'package:agrobot/API/consts.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);

  Weather? _weather;
  String _location = 'Loading...';

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
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);
      setState(() {
        _location = '${placemarks.first.locality}, ${placemarks.first.administrativeArea}';
      });
      _fetchWeather(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        _location = 'Error fetching location';
      });
    }
  }

  Future<void> _fetchWeather(double latitude, double longitude) async {
    Weather? weather = await _wf.currentWeatherByLocation(latitude, longitude);
    setState(() {
      _weather = weather;
    });
    _showPopupMessage(getIrrigationRecommendation());
  }

  String getIrrigationRecommendation() {
    if (_weather != null && _weather!.weatherDescription != null) {
      String weatherDescription = _weather!.weatherDescription!.toLowerCase();

      if (weatherDescription.contains('rain')) {
        return 'Dont Irrigate crops, Rainy conditions detected.';
      } else if (weatherDescription.contains('clear') ||
          weatherDescription.contains('sunny')) {
        return "Irrigate your crops. Sunny conditions.";
      } else if (weatherDescription.contains('smoke')) {
        return 'Irrigate your crops. Smoke detected.';
      } else if (weatherDescription.contains('cloud')) {
        return 'Monitor soil moisture. Cloudy conditions.';
      }
    }

    return 'No specific irrigation recommendation at the moment.';
  }

  void _showPopupMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
        );
      },
    );
    Future.delayed(const Duration(seconds: 10), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    if (_weather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _location,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
          ),
          _dateTimeInfo(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          _weatherIcon(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          _currentTemp(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          _extraInfo(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
        ],
      ),
    );
  }

  Widget _dateTimeInfo() {
    DateTime now = _weather!.date!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          DateFormat("EEEE").format(now),
          style: const TextStyle(fontWeight: FontWeight.w700,fontSize: 35),
        ),
        Text(
          DateFormat("d.M.y").format(now),
          style: const TextStyle(fontWeight: FontWeight.w700,fontSize: 35),
        ),
      ],
    );
  }

  Widget _weatherIcon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png"),
            ),
          ),
        ),
        Text(
          _weather?.weatherDescription ?? "",
          style: const TextStyle(color: Colors.black, fontSize: 20),
        ),
      ],
    );
  }

  Widget _currentTemp() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "${_weather?.temperature?.celsius?.toStringAsFixed(0)} °C",
          style: const TextStyle(
              color: Colors.black, fontSize: 90, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _extraInfo() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)} °C",
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
          Text(
            "Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)} °C",
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
          Text(
            "Wind: ${_weather?.windSpeed?.toStringAsFixed(0)} m/s",
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
          Text(
            "Humidity: ${_weather?.humidity?.toStringAsFixed(0)} %",
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
    home:  WeatherScreen(),
  ));
}
