class LogsModel {
  int video_id;
  bool is_played;
  DateTime played_time;
  String type; // true for video and false for image

  LogsModel({this.video_id, this.is_played, this.played_time, this.type});

  Map<String, dynamic> toMap() {
    return {
      'video_id': video_id,
      'is_played': is_played,
      'played_time': played_time.toString(),
      'type': type
    };
  }

  LogsModel toModel(var database) {
    return LogsModel(
        video_id: database['video_id'],
        is_played: database['is_played'] == 1 ? true : false,
        played_time: DateTime.parse(database['played_time']),
        type: database['type']);
  }
}
