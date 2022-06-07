import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:video_example/cubit/cubit/notice_cubit.dart';
import 'package:video_example/model/notice_slider/notice_data.dart';
import 'package:video_example/widget/scrolling_text.dart';
// import 'package:video_player/video_player.dart';
import 'package:marquee/marquee.dart';
import 'package:weather/weather.dart';
// import "package:marquee_text/marquee_text.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'dart:async';
import 'package:video_example/service/geo_locator.dart';
import 'package:weather/weather.dart';

WeatherFactory wf = new WeatherFactory("965fad0da9c81a5685aa9ba0ef5eae72");

var date1 = NepaliDateFormat.MEd();
var date2 = NepaliDateFormat.MMMMEEEEd();
var date3 = NepaliDateFormat.jms();

class BasicOverlayWidget extends StatefulWidget {
  BasicOverlayWidget({
    Key key,
  }) : super(key: key);

  @override
  State<BasicOverlayWidget> createState() => _BasicOverlayWidgetState();
}

class _BasicOverlayWidgetState extends State<BasicOverlayWidget> {
  Weather w;
  Position position;
  String listOfContents = "";
  List<Widget> pageBody;
  PageController pageController;
  NepaliDateTime dateTimeNow = NepaliDateTime.now();

  int index;
  @override
  void initState() {
    super.initState();
    _determinePosition();
    index = 0;
    pageBody = List<Widget>.generate(
        NoticeData.length, (int index) => Marqueeee(index));
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        dateTimeNow = NepaliDateTime.now();
      });

      //code to run on every 5 min
    });

    print("merquee ended");
    Timer.periodic(
        Duration(seconds: (NoticeData[this.index].content.length ~/ 5)),
        (timer) {
      if (index < NoticeData.length - 1) {
        setState(() {
          this.index++;
        });
      } else
        (this.index = 0);
      print("into timer${this.index}");
      setState(() {
        pageController.animateToPage(index,
            duration: Duration(seconds: 1), curve: Curves.easeIn);
      });
    });
  }

  void _determinePosition() async {
    position = await determinePosition().whenComplete(() => null);
    determineWeather();
  }

  void determineWeather() async {
    print("position---$position");
    w = await wf.currentWeatherByLocation(
        position.latitude, position.longitude);
    print("weather--$w");
    setState(() {
      w = w;
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Widget Marqueeee(int i) {
    return Marquee(
      text: NoticeData[i].content != ""
          ? NoticeData[i].content
          : "Nepal Telecome",
      startPadding: 0,
      numberOfRounds: 1,
      velocity: 20,
      onDone: () {
        print("newskoindex $i");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: 0,
          left: 50,
          right: 50,
          child: Center(
            child: Container(
                height: size.height * 0.1,
                color: Color.fromRGBO(33, 150, 243, 1).withOpacity(0.3),
                child: BlocBuilder<NoticeCubit, NoticeState>(
                  builder: (context, state) {
                    return
                        // ScrollingText();
                        PageView.builder(
                      itemBuilder: (context, _index) {
                        return pageBody[_index];
                      },
                      controller: pageController,
                      onPageChanged: (int _index) {
                        setState(() {
                          this.index = _index;
                        });
                      },
                    );
                  },
                )),
          ),
        ),
        Positioned(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset("assets/ntc.webp"),
              Column(
                children: [
                  OverlayText(
                    text: w != null ? w.areaName : "NTC",
                  ),
                  OverlayText(
                    text: '${(w != null) ? w.tempFeelsLike.celsius.round() : 25}° C',
                  )
                ],
              ),
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
          // Image.asset("assets/ntc.webp"),
          height: size.height * 0.2,
          top: size.height * 0.02,
          left: 0, right: 0,
        ),
      ],
    );
  }
}

class OverlayText extends StatelessWidget {
  OverlayText({Key key, this.text}) : super(key: key);

  String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, shadows: [
        Shadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(5, 5),
            blurRadius: 15),
      ]),
    );
  }
}
