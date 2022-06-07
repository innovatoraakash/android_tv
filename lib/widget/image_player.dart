import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:video_example/constants/constants.dart';
import 'package:video_example/model/video/video_data.dart';

class ImagePlayer extends StatelessWidget {
  const ImagePlayer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      child: file_links[index].haveImage? Image.asset(file_links[index].image_link,fit: BoxFit.cover,):Container(),
    );
  }
}
