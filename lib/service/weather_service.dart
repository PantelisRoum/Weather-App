import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService{
     static const BASE_URL='http://api.openweathermap.org/data/2.5/weather';
     final String apiKey;
     WeatherService(this.apiKey);
     Future<Weather> getWeather(String cityName) async{
       final response =await http.get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

       if (response.statusCode==200){
         //print("Json file is: ${response.body}");
         return Weather.fromjson(jsonDecode(response.body));
       }else{
         throw Exception("Failed to load weather data ");
       }
     }
     Future<String> getCurrentCity() async{
       // permission from the user
       LocationPermission permission= await Geolocator.checkPermission();
       if (permission==LocationPermission.denied){
            permission= await Geolocator.requestPermission();
       }
       // fetch the current location
       Position position= await Geolocator.getCurrentPosition(
         desiredAccuracy: LocationAccuracy.high);
       //convert the location into a list of placemark object
       List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
       //i am exctracting the city name form the first place mark
       String ? city=placemarks[0].locality;
       return city ??"";
     }

}