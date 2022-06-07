class NoticeModel {
  String title;
  String content;
  DateTime start_from;
  DateTime end_on;
  DateTime targeted_time;

  NoticeModel(
      {this.title,
      this.content,
      this.start_from,
      this.end_on,
      this.targeted_time});
}
