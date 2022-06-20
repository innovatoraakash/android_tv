import 'package:flutter/material.dart';
import 'package:video_example/constants/constants.dart';
import 'package:video_example/model/notice_slider/notice_data.dart';
import 'package:video_example/model/video/Video_data.dart';
import 'database.dart';

class TestDatabase extends StatelessWidget {
  // reference to our single class that manages the database
  final dbHelper = VideoDatabaseHelper.instance;

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
              onPressed: _insert,
            ),
            ElevatedButton(
              child: Text(
                'insert notice',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: _insertNotice,
            ),
            ElevatedButton(
              child: Text(
                'query video',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: _query,
            ),
            ElevatedButton(
              child: Text(
                'query notice',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: _queryNotice,
            ),
            ElevatedButton(
              child: Text(
                'insert item',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: _update,
            ),
            ElevatedButton(
              child: Text(
                'query item',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: _updateNotice,
            ),
            ElevatedButton(
              child: Text(
                'delete video',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: _delete,
            ),
            ElevatedButton(
              child: Text(
                'delete notice',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: _deleteNotice,
            ),
            ElevatedButton(
              child: Text(
                'delete log',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: _deleteLog,
            ),
          ],
        ),
      ),
    );
  }

  // Button onPressed methods

  void _insert() async {
    for (var videodata in VideoData) {
      final id = await dbHelper.insert(videodata.toMap(), video_table);
      print('inserted row id: $id');
    }
  }

  void _insertNotice() async {
    for (var noticedata in NoticeData) {
      final id = await dbHelper.insert(noticedata.toMap(), notice_table);
      print('inserted row id: $id');
    }
  }

  void _insertItem() async {
    for (var noticedata in NoticeData) {
      final id = await dbHelper.insert(noticedata.toMap(), notice_table);
      print('inserted row id: $id');
    }
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows(video_table);
    print('query all rows:');
    allRows.forEach(print);
  }

  void _queryNotice() async {
    final allRows = await dbHelper.queryAllRows(notice_table);
    print('query all rows:');
    allRows.forEach(print);
  }

  void _update() async {
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

  void _updateNotice() async {
    final rowsAffected =
        await dbHelper.update(NoticeData[1].toMap(), notice_table);
    print('updated $rowsAffected row(s)');
  }

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount(video_table);
    final rowsDeleted = await dbHelper.delete(id, video_table);
    print('deleted $rowsDeleted row(s): row $id');
  }

  void _deleteNotice() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount(notice_table);
    final rowsDeleted = await dbHelper.delete(id, notice_table);
    print('deleted $rowsDeleted row(s): row $id');
  }

  void _deleteLog() async {
    // Assuming that the number of rows is the id for the last row.

    final rowsDeleted = await dbHelper.deleteAll(log_table);
    print('deleted $rowsDeleted row(s)');
  }
}
