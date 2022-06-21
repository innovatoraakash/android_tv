import 'dart:isolate';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_example/constants/constants.dart';
import 'package:video_example/model/items/ItemModel.dart';
import 'package:video_example/model/items/item_data.dart';
import 'package:video_example/service/database_fetch.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';


List<String> links = [];

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
    // FetchItems();
    Future.delayed(Duration(seconds: 1));
    for (ItemModel item in ItemData) {
      print("items link${item.file}");
      links.add(item.file);
    }
    initialOption();
    _downloadListener();
  }

  initialOption() async {
    // await FetchItems();
    Future.delayed(Duration(seconds: 1));
    for (ItemModel item in ItemData) {
      print("items link${item.file}");
      links.add(item.file);
    }
  }

  // FetchItems() async {
  //   final allRows = await dbHelper.queryAllRows(item_table).whenComplete(() {});
  //   print('database${allRows.length}');
  //   for (var row in allRows) {
  //     print("rows$row");
  //     ItemData.add(ItemModel().toModel(row));
  //   }
  // }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  _downloadListener() {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      if (status.toString() == "DownloadTaskStatus(3)" &&
          progress == 100 &&
          id != null) {
        String query = "SELECT * FROM task WHERE task_id='" + id + "'";
        var tasks = FlutterDownloader.loadTasksWithRawQuery(query: query);
        //if the task exists, open it
        if (tasks != null) FlutterDownloader.open(taskId: id);
      }
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  void _download() async {


    Directory downloadsDirectory =
        await DownloadsPathProvider.downloadsDirectory;
    
    String _url = 
      "https://firebasestorage.googleapis.com/v0/b/storage-3cff8.appspot.com/o/2020-05-29%2007-18-34.mp4?alt=media&token=841fffde-2b83-430c-87c3-2d2fd658fd41"
    ;

    // ItemData.forEach((element) async {
      final download = await FlutterDownloader.enqueue(
        url: _url,
        savedDir: downloadsDirectory.path,
        showNotification: true,
        openFileFromNotification: true,
        fileName: "elementname",
      );
    // });
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
          children: <Widget>[],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _download,
        child: Icon(Icons.file_download),
      ),
    );
  }
}
