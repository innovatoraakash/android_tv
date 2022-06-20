// import 'package:flutter/material.dart';
// import 'package:weather/weather.dart';
// import 'package:geolocator/geolocator.dart';
// import 'geo_locator.dart';

// WeatherFactory wf = new WeatherFactory("965fad0da9c81a5685aa9ba0ef5eae72");
//   Weather w;
//   Position position;

// class FetchWeather extends StatelessWidget {
//   FetchWeather({Key key}) : super(key: key);

//  void _determinePosition() async {
//     position = await determinePosition().whenComplete(() => null);
//     determineWeather();
//   }

//   void determineWeather() async {
//     print("position---$position");
//     w = await wf.currentWeatherByLocation(
//         position.latitude, position.longitude);
//     print("weather--$w");
//     setState(() {
//       w = w;
//     });
//   }

// }
