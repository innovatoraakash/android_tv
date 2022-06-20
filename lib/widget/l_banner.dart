import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_example/main.dart';

class LBanner extends StatefulWidget {
  const LBanner({
    Key key,
    @required this.child,
    @required this.size,
  }) : super(key: key);

  final Widget child;
  final Size size;

  @override
  State<LBanner> createState() => _LBannerState();
}

class _LBannerState extends State<LBanner> {
  Timer timer;
  bool lBanner = false;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 7), (_) {
      lBanner = !lBanner;
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                width: lBanner ? (20 * widget.size.width) / 100 : 0,
                color: Colors.green,
              ),
              Expanded(child: widget.child),
            ],
          ),
        ),
        Container(
          height: lBanner ? (20 * widget.size.height) / 100 : 0,
          color: Colors.green,
        ),
      ],
    );
  }
}
