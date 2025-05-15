import 'dart:convert';

class Weather{
  final String cityName;
  final double temperature;
  final String mainCondition;
  //adding extra info for the weather
  final double humidity;
  final double feelTemperature;
  final double windDeg;
  final double windSpeed;
  final double tempMin;
  final double tempMax;
  final int time;

    Weather({
      required this.cityName,
      required this.temperature,
      required this.mainCondition,
      //adding extra info for the weather
      required this.humidity,
      required this.feelTemperature,
      required this.windSpeed,
      required this.tempMin,
      required this.tempMax,
      required this.time,
      required this.windDeg,
    });
    factory Weather.fromjson(Map<String,dynamic> json){
      print("WEAHER IS: " + jsonEncode(json));
      return Weather(
          cityName:json['name'],
          temperature: json['main']['temp'].toDouble(),
          mainCondition:json['weather'][0]['main'],
           //adding extra info for the weather
          humidity: json['main']['humidity'].toDouble(),
          feelTemperature: json['main']['feels_like'].toDouble(),
          tempMax: json['main']['temp_min'],
          tempMin: json['main']['temp_max'],
          windSpeed:json['wind']['speed'].toDouble(),
          windDeg: json['wind']['deg'].toDouble(),
          time: json['timezone']);
  }

}