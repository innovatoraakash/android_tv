import 'dart:isolate';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';





class Download extends StatefulWidget {
  Download({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Download> {
  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    _downloadListener();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

   _downloadListener() {
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      if (status.toString() == "DownloadTaskStatus(3)" && progress == 100 && id != null) {
          String query = "SELECT * FROM task WHERE task_id='" + id + "'";
          var tasks = FlutterDownloader.loadTasksWithRawQuery(query: query);
          //if the task exists, open it
          if (tasks != null) FlutterDownloader.open(taskId: id);
      }
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  void _download() async {
    String _localPath =
        (await findLocalPath()) + Platform.pathSeparator + 'Example_Downloads';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    String _url =
        "https://www.colonialkc.org/wp-content/uploads/2015/07/Placeholder.png";
    final download = await FlutterDownloader.enqueue(
      url: _url,
      savedDir: _localPath,
      showNotification: true,
      openFileFromNotification: true,
    );
  }

  Future<String> findLocalPath() async {
    final directory =
        // (MyGlobals.platform == "android")
        // ?
        await getExternalStorageDirectory();
    // : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _download,
        child: Icon(Icons.file_download),
      ),
    );
  }
}