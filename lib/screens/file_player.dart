import 'dart:io';
import 'package:video_example/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_example/cubit/cubit/image_cubit.dart';
import 'package:video_example/database/database.dart';
// import 'package:video_example/model/video/VideoData.dart';
import 'package:video_example/model/video/video_model.dart';
import 'package:video_example/widget/video_player_widget.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

bool isended = false;
final dbHelper = VideoDatabaseHelper.instance;
List<VideoModel> videoData = [];

class FilePlayerWidget extends StatefulWidget {
  @override
  _FilePlayerWidgetState createState() => _FilePlayerWidgetState();
}

class _FilePlayerWidgetState extends State<FilePlayerWidget> {
  // String asset = videodata[index].file_link;
  File file;
  VideoPlayerController controller;
  Duration position;
  bool isEnd = true;

  @override
  void initState() {
    super.initState();

    fetchDatabase();
  }

  fetchDatabase() async {
    final allRows = await dbHelper.queryAllRows(video_table).whenComplete(() {
     
    });
    print('database${allRows.length}');
    for (var row in allRows) {
      videoData.add(VideoModel().toModel(row));
    }
    playVideo();
  }

  void playVideo() {
    file = File(videoData[index].file_link);
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

          if (controller.value.duration == controller.value.position && isEnd) {
            setState(() {
              isEnd = false;
            });
            if (videoData[index].haveImage == true) {
              context.read<ImageCubit>().togleImageView();
              Future.delayed(Duration(seconds: 10), () {
                context.read<ImageCubit>().togleImageView();
              }).whenComplete(() {
                controller.dispose();

                PlayNext();
              });
            } else {
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

      if (videoData.length > index) {
        // this.asset = videoData[index].file_link;
        this.file = File(videoData[index].file_link);
        playVideo();
      } else {
        index = 0;
        // this.asset = videoData[index].file_link;
        this.file = File(videoData[index].file_link);
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