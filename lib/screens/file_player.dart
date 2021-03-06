import 'dart:io';
import 'package:video_example/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_example/cubit/cubit/image_cubit.dart';
import 'package:video_example/database/database.dart';
import 'package:video_example/model/logs_model.dart';
// import 'package:video_example/model/video/VideoData.dart';
import 'package:video_example/model/video/video_model.dart';
import 'package:video_example/widget/video_player_widget.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';


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
      Future.delayed(Duration(seconds: 1));
    });
    print('database${allRows.length}');
    for (var row in allRows) {
      videoData.add(VideoModel().toModel(row));
    }
    playVideo();
  }

  

  Future<bool> CountQuery() async {
    var log_count =
        await dbHelper.queryRowCountWithId(log_table, videoData[index].id);

    // return log_count;

    if (log_count >= videoData[index].day_count) {
      return true;
    } else
      return false;
  }
   

  void playVideo() async {
  Directory downloadsDirectory =
        await DownloadsPathProvider.downloadsDirectory;

//  downloadsDirectory.path +"/hello.mp4"
   
    
    if (DateTime.now().isAfter(videoData[index].start_from) &&
        DateTime.now().isBefore(videoData[index].end_on)) {
      bool played_count = await CountQuery().whenComplete(() {
      });
      file = File(videoData[index].file_link);
      if (file.existsSync() && !played_count) {
        isEnd = true;

        controller = new VideoPlayerController.file(File(videoData[index].file_link))
          ..initialize().then((value) {
            setState(() {
              controller.play();
            });

            controller.addListener(() {
              //custom Listner

              // checking the duration and position every time
              // Video Completed//
              if (controller.value.duration == controller.value.position &&
                  isEnd) {
                setState(() {
                  isEnd = false;
                });
                CreateLog("video");

                //check if have trailing image
                if (videoData[index].haveImage == true) {
                  context.read<ImageCubit>().togleImageView();
                  CreateLog("image");
                  Future.delayed(
                      Duration(
                          seconds: videoData[index].time_to_play_image ?? 10),
                      () {
                    context.read<ImageCubit>().togleImageView();
                  }).whenComplete(() {
                    controller.dispose();
                    // controller.removeListener;
                    // controller.pause();
                    controller = null;
                    PlayNext();
                  });
                } else {
                  controller.dispose();
                  controller = null;
                  PlayNext();
                }
              }
            });
          })
          ..setLooping(false);
      } else {
        PlayNext();
      }
    } else {
      PlayNext();
    }
  }

  CreateLog(String _type) async {
    var logs = LogsModel(
            video_id:
                _type.toLowerCase() == "video" ? videoData[index].id : null,
            is_played: true,
            type: _type,
            played_time: DateTime.now())
        .toMap();
    await dbHelper.insert(logs, log_table);
    var log = await dbHelper.queryAllRows(log_table);
    log.forEach(print);
  }

  void PlayNext() {
    

      if (videoData.length > index) {
      index++;
        // this.asset = videoData[index].file_link;
        this.file = File(videoData[index].file_link);
        playVideo();
      } else {
        index = 0;
        // this.asset = videoData[index].file_link;
        this.file = File(videoData[index].file_link);
        playVideo();
      }
  setState(() { });
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
