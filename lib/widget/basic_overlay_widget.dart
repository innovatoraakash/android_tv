import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:marquee/marquee.dart';

class BasicOverlayWidget extends StatelessWidget {
  final VideoPlayerController controller;

  const BasicOverlayWidget({
    Key key,
    @required this.controller,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () =>
          controller.value.isPlaying ? controller.pause() : controller.play(),
      child: Stack(
        children: <Widget>[
          buildPlay(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
                child: Container(
              height: size.height * 0.1,
              color: Colors.blue.withOpacity(0.3),
              child: Marquee(
                text: 'There once was a boy who told this story about a boy: "',
                startPadding: 10,
              ),
            )),
          ),
          Positioned(           
            child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Image.asset("assets/ntc.webp"),
              OverlayText(text: "Temperature : 30c",),
              Padding(
                padding: const EdgeInsets.only(right: 10 ),
                child: OverlayText(text: "Date : 30 baisakh 2078",),
              ),

            ],),
                      // Image.asset("assets/ntc.webp"),
            height: size.height * 0.2,
            top: size.height * 0.02,
            left: 0,right: 0,
          
          ),
          // Positioned(
          //   child: OverlayText(text: "Temperature : 30c",),
          //   height: size.height * 0.08,
          //   top: size.height * 0.02,
          //   left: size.width * 0.4,
          // ),
          // Positioned(
          //   child: OverlayText(text: "Date : 30 baisakh 2078",),
          //   height: size.height * 0.08,
          //   top: size.height * 0.02,
          //   right: size.width * 0.02,
          // )
        ],
      ),
    );
  }

  Widget buildIndicator() => VideoProgressIndicator(
        controller,
        allowScrubbing: true,
      );

  Widget buildPlay() => controller.value.isPlaying
      ? Container()
      : Container(
          alignment: Alignment.center,
          color: Colors.black26,
          child: Icon(Icons.play_arrow, color: Colors.white, size: 80),
        );
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
