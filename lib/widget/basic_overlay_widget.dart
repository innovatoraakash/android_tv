import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:video_example/constants/constants.dart';
import 'package:video_example/widget/notice_widget.dart';
import 'text_overlay_widget.dart';
import 'package:weather/weather.dart';
import 'package:nepali_utils/nepali_utils.dart' as Nepali;
import 'package:nepali_utils/nepali_utils.dart';
import 'dart:async';
import 'package:video_example/service/geo_locator.dart';

//variable decleration

WeatherFactory wf = new WeatherFactory(weather_api);

var date1 = NepaliDateFormat.MEd();
var date2 = NepaliDateFormat.MMMMEEEEd();
var date3 = NepaliDateFormat.jms();

int index = 0;
Weather w;
Position position;
String listOfContents = "";
NepaliDateTime dateTimeNow = NepaliDateTime.now();

//overlay class

class BasicOverlayWidget extends StatefulWidget {
  BasicOverlayWidget({
    Key key,
  }) : super(key: key);

  @override
  State<BasicOverlayWidget> createState() => _BasicOverlayWidgetState();
}

class _BasicOverlayWidgetState extends State<BasicOverlayWidget> {
  @override
  void initState() {
    super.initState();
    _determinePosition();
    NepaliUtils(Nepali.Language.nepali);

    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        dateTimeNow = NepaliDateTime.now();
      });

      //code to run on every 5 min
    });
  }

  void _determinePosition() async {
    try {
      position = await determinePosition().whenComplete(() => null);
    } on Exception catch (e) {
      print(e);
    }
    determineWeather();
  }

  void determineWeather() async {
    print("position---$position");
    try {
      w = await wf.currentWeatherByLocation(
          position.latitude, position.longitude);
    } on Exception catch (e) {
      print(e);
    }
    print("weather--$w");
    setState(() {
      w = w;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        NoticeWIdget(),
        // ScrollingText(),
        Positioned(
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //ntc logo
              Image.asset("assets/ntc.webp"),

              //location and temperature
              Column(
                children: [
                  OverlayText(
                    text: w != null ? w.areaName : "NTC",
                  ),
                  OverlayText(
                    text:
                        '${(w != null) ? w.tempFeelsLike.celsius.round() : 25}° C',
                  )
                ],
              ),

              //nepali date and time
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  children: [
                    OverlayText(text: date2.format(dateTimeNow)),
                    OverlayText(
                      text:
                          "${dateTimeNow.hour}:${dateTimeNow.minute}:${dateTimeNow.second}",
                    ),
                  ],
                ),
              ),
            ],
          ),
          height: size.height * 0.22,
          top: size.height * 0.02,
          left: 0,
          right: 0,
        ),
      ],
    );
  }
}
