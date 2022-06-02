import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_example/model/video_data.dart';
import 'package:video_example/widget/video_player_widget.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class FilePlayerWidget extends StatefulWidget {
  @override
  _FilePlayerWidgetState createState() => _FilePlayerWidgetState();
}

int index = 0;

class _FilePlayerWidgetState extends State<FilePlayerWidget> {
  // String file_link= "/storage/emulated/0/DCIM/Camera/20220525_193948.mp4";
  File file = File(file_links[index].file_link);
  VideoPlayerController controller;
  Duration position;
  bool isEnd = false;

  @override
  void initState() {
    super.initState();
    playVideo();
  }

  void playVideo() {
    if (file.existsSync()) {
      controller = VideoPlayerController.file(file)
        ..addListener(() {
          Timer.run(() {
            position = controller.value.position;
          });

          final _duration = controller.value.duration;

          _duration?.compareTo(position) == 0 ||
                  _duration?.compareTo(position) == -1
              ? this.setState(() {
                  isEnd = true;
                  PlayNext();
                })
              : this.setState(() {
                  isEnd = false;
                });
        })
        ..setLooping(false)
        ..initialize().then((_) => controller.play());
    }
  }

  void PlayNext() {
    setState(() {
      file = File(file_links[index + 1].file_link);
      playVideo();
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: VideoPlayerWidget(controller: controller),
      );
}
