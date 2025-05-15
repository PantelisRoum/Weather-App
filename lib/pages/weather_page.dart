import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/weather_model.dart';
import '../service/weather_service.dart';
import 'package:intl/intl.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('5489942cf3e3d92475eaad679d2c8b32');
  Weather? _weather;
  String? _errorMessage;
  void _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });



      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return "assets/sunny.json";
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return "assets/clouds.json";
      case 'rain':
      case 'drizzle':
        return "assets/rainny.json";
      case 'thunderstorm':
        return "assets/thunder.json";
      case 'clear':
        return "assets/summy.json";
      case 'snow':
        return "assets/snow.json";
      default:
        return "assets/summy.json";
    }
  }

  int convertMSToBeaufort(double speedInMS) {
    if (speedInMS < 0.5) {
      return 0;
    } else if (speedInMS < 1.5) {
      return 1;
    } else if (speedInMS < 3.3) {
      return 2;
    } else if (speedInMS < 5.5) {
      return 3;
    } else if (speedInMS < 7.9) {
      return 4;
    } else if (speedInMS < 10.7) {
      return 5;
    } else if (speedInMS < 13.8) {
      return 6;
    } else if (speedInMS < 17.1) {
      return 7;
    } else if (speedInMS < 20.7) {
      return 8;
    } else if (speedInMS < 24.4) {
      return 9;
    } else if (speedInMS < 28.4) {
      return 10;
    } else if (speedInMS < 32.6) {
      return 11;
    } else {
      return 12;
    }
  }
  // we are converting the deg into North,East,South,West etc.
  String getCompassDirection(double degrees) {
    if (degrees < 0 || degrees > 360) {
      throw ArgumentError("Degrees must be between 0 and 360");
    }

    if (degrees >= 337.5 || degrees < 22.5) {
      return "N";
    } else if (degrees >= 22.5 && degrees < 67.5) {
      return "NE";
    } else if (degrees >= 67.5 && degrees < 112.5) {
      return "E";
    } else if (degrees >= 112.5 && degrees < 157.5) {
      return "SE";
    } else if (degrees >= 157.5 && degrees < 202.5) {
      return "S";
    } else if (degrees >= 202.5 && degrees < 247.5) {
      return "SW";
    } else if (degrees >= 247.5 && degrees < 292.5) {
      return "W";
    } else if (degrees >= 292.5 && degrees < 337.5) {
      return "NW";
    } else {
      return "N";  // Fallback, though logically we shouldn't reach here
    }
  }

  // Get the current formatted time
 /* String getCurrentTime() {
    final now = DateTime.now();
    final formatter = DateFormat('dd-MM-yyyy HH:mm');
    return formatter.format(now);  */

  String getCurrentTime(int timezoneOffset) {
    final now = DateTime.now().toUtc().add(Duration(seconds: timezoneOffset));
    final formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(now);
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Widget buildWeatherInfo(String icon, String value, String label) {
    return Column(
      children: [
        Lottie.asset(icon, height: 35, width: 35),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade200, Colors.white],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              if (_weather != null) ...[
                Text(
                  getCurrentTime(_weather!.time),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  _weather!.cityName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Lottie.asset(
                  getWeatherAnimation(_weather!.mainCondition),
                  width: 150,
                  height: 150,
                ),
                SizedBox(height: 20),
                Text(
                  '${_weather!.temperature.round()}℃',
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  _weather!.mainCondition,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 10),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  runSpacing: 10,
                  children: [
                    buildWeatherInfo(
                      'assets/humidity.json',
                      '${_weather!.humidity.round()}',
                      'Humidity',
                    ),
                    buildWeatherInfo(
                      'assets/wind.json',
                      '${convertMSToBeaufort(_weather!.windSpeed)} Bft',
                      'Wind',
                    ),
                    buildWeatherInfo(
                      'assets/feels_like.json', // Add your own icon here
                      '${_weather!.feelTemperature.round()}℃',
                      'Feels Like',
                    ),
                    buildWeatherInfo(
                      'assets/wind_flag.json',
                      getCompassDirection(_weather!.windDeg),
                      'Wind Direction',
                    ),
                    buildWeatherInfo(
                      'assets/max_temp.json',
                      '${_weather!.tempMax.round()}℃',
                      'Maximum Temperature',
                    ),
                    buildWeatherInfo(
                      'assets/min_temp.json',
                      '${_weather!.tempMin.round()}℃',
                      'Minimum Temperature',
                    ),
                  ],
                ),
              ] else if (_errorMessage == null)
                CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}


















  /*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade200, Colors.white],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_weather != null)
                Column(
                  children: [
                    Text(
                      getCurrentTime(_weather!.time),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              Text(
                _weather?.cityName ?? "Loading city...",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              if (_weather != null)
                Lottie.asset(
                  getWeatherAnimation(_weather!.mainCondition),
                  width: 150,
                  height: 150,
                )
              else
                CircularProgressIndicator(),
              SizedBox(height: 20),
              if (_weather != null)
                Text(
                  '${_weather!.temperature.round()}℃',
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              SizedBox(height: 10),
              Text(
                _weather?.mainCondition ?? "",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 10),
              if (_weather != null)
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  runSpacing: 10,
                  children: [
                    buildWeatherInfo(
                      'assets/humidity.json',
                      '${_weather!.humidity.round()}%',
                      'Humidity',
                    ),
                    buildWeatherInfo(
                      'assets/wind.json',
                      '${convertMSToBeaufort(_weather!.windSpeed)} Bft',
                      'Wind',
                    ),
                    buildWeatherInfo(
                      'assets/feels_like.json', // Add your own icon here
                      '${_weather!.feelTemperature.round()}℃',
                      'Feels Like',
                    ),
                    buildWeatherInfo(
                      'assets/wind_flag.json',
                      getCompassDirection(_weather!.windDeg),
                      'Wind Direction',
                    ),
                    buildWeatherInfo(
                      'assets/max_temp.json',
                      '${_weather!.tempMax.round()}℃',
                      'Maximum Temperature',
                    ),
                    buildWeatherInfo(
                      'assets/min_temp.json',
                      '${_weather!.tempMin.round()}℃',
                      'Minimum Temperature',
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
*/































