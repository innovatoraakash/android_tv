import 'package:flutter/material.dart';

class OverlayText extends StatelessWidget {
  OverlayText({Key key, this.text}) : super(key: key);

  String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, shadows: [
        Shadow(
            color: Colors.black.withOpacity(0.6),
            offset: const Offset(5, 5),
            blurRadius: 15),
      ]),
    );
  }
}
