import 'dart:io';
import 'package:video_example/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_example/cubit/cubit/image_cubit.dart';
import 'package:video_example/model/video/video_data.dart';
import 'package:video_example/widget/video_player_widget.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

bool isended = false;

class FilePlayerWidget extends StatefulWidget {
  @override
  _FilePlayerWidgetState createState() => _FilePlayerWidgetState();
}

class _FilePlayerWidgetState extends State<FilePlayerWidget> {
  File file = File(file_links[index].file_link);
  String asset = file_links[index].file_link;
  VideoPlayerController controller;
  Duration position;
  bool isEnd = true;

  @override
  void initState() {
    super.initState();

    playVideo();
  }

  void playVideo() {
    // if (file.existsSync()) {
    isEnd = true;
    controller = VideoPlayerController.file(file)
      ..initialize().then((value) {
        setState(() {
          controller.play();
        });

        controller.addListener(() {
          //custom Listner

          // checking the duration and position every time
          // Video Completed//

          print(
              "controller value ${controller.value.position} ${controller.value.duration}");
          if (controller.value.duration == controller.value.position && isEnd) {
            setState(() {
              isEnd = false;
            });
            if (file_links[index].haveImage == true) {
              print("inside if");
              context.read<ImageCubit>().togleImageView();
              Future.delayed(Duration(seconds: 10), () {
                context.read<ImageCubit>().togleImageView();
              }).whenComplete(() {
                print("inside complete");
                controller.dispose();

                PlayNext();
              });
            } else {
              print("inside else");
              controller.dispose();

              PlayNext();
            }
          }
        });
      })
      ..setLooping(false);
    // }
    // else {
    // PlayNext();
    // }
  }

  void PlayNext() {
    setState(() {
      index++;

      if (file_links.length > index) {
        // this.asset = file_links[index].file_link;
        this.file = File(file_links[index].file_link);
        playVideo();
      } else {
        index = 0;
        // this.asset = file_links[index].file_link;
        this.file = File(file_links[index].file_link);
        playVideo();
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: VideoPlayerWidget(controller: controller),
      );
}
