import 'package:flutter/material.dart';
import 'package:video_example/constants/constants.dart';
import 'package:video_example/model/notice_slider/notice_data.dart';
import 'package:video_example/model/video/Video_data.dart';
import 'database.dart';

class TestDatabase extends StatelessWidget {
  // reference to our single class that manages the database
  final dbHelper = VideoDatabaseHelper.instance;


   void insert() async {
    for (var videodata in VideoData) {
      final id = await dbHelper.insert(videodata.toMap(), video_table);
      print('inserted row id: $id');
    }
  }

  void insertNotice() async {
    for (var noticedata in NoticeData) {
      final id = await dbHelper.insert(noticedata.toMap(), notice_table);
      print('inserted row id: $id');
    }
  }

  void insertItem() async {
    for (var noticedata in NoticeData) {
      final id = await dbHelper.insert(noticedata.toMap(), notice_table);
      print('inserted row id: $id');
    }
  }

  void query() async {
    final allRows = await dbHelper.queryAllRows(video_table);
    print('query all rows:');
    allRows.forEach(print);
  }

  void queryNotice() async {
    final allRows = await dbHelper.queryAllRows(notice_table);
    print('query all rows:');
    allRows.forEach(print);
  }

  void update() async {
    // row to update
    // Map<String, dynamic> row = {
    //   DatabaseHelper.columnId   : 1,
    //   DatabaseHelper.columnName : 'Mary',
    //   DatabaseHelper.columnAge  : 32
    // };
    final rowsAffected =
        await dbHelper.update(VideoData[1].toMap(), video_table);
    print('updated $rowsAffected row(s)');
  }

  void updateNotice() async {
    final rowsAffected =
        await dbHelper.update(NoticeData[1].toMap(), notice_table);
    print('updated $rowsAffected row(s)');
  }

   delete({int id=1,String table_name}) async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount(table_name);
    final rowsDeleted = await dbHelper.delete(id, table_name);
    print('deleted $rowsDeleted row(s): row $id');
  }

  

   deleteLog() async {
    // Assuming that the number of rows is the id for the last row.

    final rowsDeleted = await dbHelper.deleteAll(log_table);
    print('deleted $rowsDeleted row(s)');
  }
  // homepage layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NTC'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text(
                'insert video',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: insert,
            ),
            ElevatedButton(
              child: Text(
                'insert notice',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: insertNotice,
            ),
            ElevatedButton(
              child: Text(
                'query video',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: query,
            ),
            ElevatedButton(
              child: Text(
                'query notice',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: queryNotice,
            ),
            ElevatedButton(
              child: Text(
                'insert item',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: update,
            ),
            ElevatedButton(
              child: Text(
                'query item',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: updateNotice,
            ),
            ElevatedButton(
              child: Text(
                'delete video',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: delete(table_name: video_table),
            ),
            ElevatedButton(
              child: Text(
                'delete notice',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: delete( table_name:notice_table),
            ),
            ElevatedButton(
              child: Text(
                'delete log',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: deleteLog(),
            ),
          ],
        ),
      ),
    );
  }

  // Button onPressed methods


}
