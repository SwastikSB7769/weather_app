import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/services/weather_services.dart';
import 'package:weather_app/widget/weather_data_tile.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<StatefulWidget> createState() => WeatherPageState();
}

class WeatherPageState extends State<WeatherPage> {
  final TextEditingController _controller = TextEditingController();
  String _bgImg = 'assets/images/clear.jpg';
  String _iconImg = 'assets/icons/clear.png';
  String _cityName = '';
  String _temperature = '';
  String _tempMax = '';
  String _tempMin = '';
  String _sunrise = '';
  String _sunset = '';
  String _main = '';
  String _pressure = '';
  String _humidity = '';
  String _visibility = '';
  String _windSpeed = '';

  getData(String cityName) async {
    final weatherService = WeatherService();
    var weatherData;
    if (cityName == '') {
      weatherData = await weatherService.fetchWeather();
    } else {
      weatherData = await weatherService.getWeather(cityName);
    }
    debugPrint(weatherData.toString());
    setState(() {
      _cityName = weatherData['name'];
      _temperature = weatherData['main']['temp'].toStringAsFixed(1);
      _main = weatherData['weather'][0]['main'];
      _tempMax = weatherData['main']['temp_max'].toStringAsFixed(1);
      _tempMin = weatherData['main']['temp_min'].toStringAsFixed(1);
      _sunrise = DateFormat('hh:mm a').format(
          DateTime.fromMillisecondsSinceEpoch(
              weatherData['sys']['sunrise'] * 1000));
      _sunset = DateFormat('hh:mm a').format(
          DateTime.fromMillisecondsSinceEpoch(
              weatherData['sys']['sunset'] * 1000));
      _pressure = weatherData['main']['pressure'].toString();
      _humidity = weatherData['main']['humidity'].toString();
      _visibility = weatherData['visibility'].toString();
      _windSpeed = weatherData['wind']['speed'].toString();
      if (_main == 'Clear') {
        _bgImg = 'assets/images/clear.jpg';
        _iconImg = 'assets/icons/clear.png';
      } else if (_main == 'Clouds') {
        _bgImg = 'assets/images/clouds.jpg';
        _iconImg = 'assets/icons/clouds.png';
      } else if (_main == 'Rain') {
        _bgImg = 'assets/images/rain.jpg';
        _iconImg = 'assets/icons/rain.png';
      } else if (_main == 'Fog') {
        _bgImg = 'assets/images/fog.jpg';
        _iconImg = 'assets/icons/haze.png';
      } else if (_main == 'Thunderstorm') {
        _bgImg = 'assets/images/thunderstorm.jpg';
        _iconImg = 'assets/icons/thunderstorm.png';
      } else {
        _bgImg = 'assets/images/haze.jpg';
        _iconImg = 'assets/icons/haze.png';
      }
    });
  }

  Future<bool> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
      getData(' ');
    }
    getData(' ');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            _bgImg,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  TextField(
                    controller: _controller,
                    onChanged: (value) {
                      getData(value);
                    },
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white24,
                      hintText: 'Enter City Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.location_on),
                    Text(
                      _cityName,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    )
                  ]),
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    '$_temperature°C',
                    style: TextStyle(
                        inherit: true,
                        fontSize: 60.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                        shadows: [
                          Shadow(
                              // bottomLeft
                              offset: Offset(-1.5, -1.5),
                              color: Colors.black12),
                          Shadow(
                              // bottomRight
                              offset: Offset(1.5, -1.5),
                              color: Colors.black12),
                          Shadow(
                              // topRight
                              offset: Offset(1.5, 1.5),
                              color: Colors.black12),
                          Shadow(
                              // topLeft
                              offset: Offset(-1.5, 1.5),
                              color: Colors.black12),
                        ]),
                  ),
                  // Text('30.9°C',
                  // style: TextStyle(
                  //   color: Colors.white60,
                  //   fontSize: 90,
                  //   fontWeight: FontWeight.bold,
                  // ),
                  // ),
                  Row(
                    children: [
                      Text(
                        "$_main ",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                            shadows: [
                              Shadow(
                                  // bottomLeft
                                  offset: Offset(-1, -1),
                                  color: Colors.black12),
                              Shadow(
                                  // bottomRight
                                  offset: Offset(1, -1),
                                  color: Colors.black12),
                              Shadow(
                                  // topRight
                                  offset: Offset(1, 1),
                                  color: Colors.black12),
                              Shadow(
                                  // topLeft
                                  offset: Offset(-1, 1),
                                  color: Colors.black12),
                            ]),
                      ),
                      Image.asset(
                        _iconImg,
                        height: 50,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_upward,
                        color: Colors.white70,
                      ),
                      Text(
                        '$_tempMax°C  ',
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white70,
                            fontStyle: FontStyle.italic,
                            shadows: [
                              Shadow(
                                  // bottomLeft
                                  offset: Offset(-1, -1),
                                  color: Colors.black12),
                              Shadow(
                                  // bottomRight
                                  offset: Offset(1, -1),
                                  color: Colors.black12),
                              Shadow(
                                  // topRight
                                  offset: Offset(1, 1),
                                  color: Colors.black12),
                              Shadow(
                                  // topLeft
                                  offset: Offset(-1, 1),
                                  color: Colors.black12),
                            ]),
                      ),
                      Icon(Icons.arrow_downward, color: Colors.white70),
                      Text(
                        '$_tempMin°C',
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white70,
                            fontStyle: FontStyle.italic,
                            shadows: [
                              Shadow(
                                  // bottomLeft
                                  offset: Offset(-1, -1),
                                  color: Colors.black12),
                              Shadow(
                                  // bottomRight
                                  offset: Offset(1, -1),
                                  color: Colors.black12),
                              Shadow(
                                  // topRight
                                  offset: Offset(1, 1),
                                  color: Colors.black12),
                              Shadow(
                                  // topLeft
                                  offset: Offset(-1, 1),
                                  color: Colors.black12),
                            ]),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Card(
                    color: Colors.transparent,
                    elevation: 5,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          WeatherDataTile(
                              index1: "Sunrise",
                              index2: "Sunset",
                              value1: _sunrise,
                              value2: _sunset),
                          SizedBox(
                            height: 15,
                          ),
                          WeatherDataTile(
                              index1: "Humidity",
                              index2: "Visibility",
                              value1: _humidity,
                              value2: _visibility),
                          SizedBox(
                            height: 15,
                          ),
                          WeatherDataTile(
                              index1: "Precipitation",
                              index2: "Wind Speed",
                              value1: _pressure,
                              value2: _windSpeed),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
