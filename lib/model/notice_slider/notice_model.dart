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

 Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content':content,
      'targeted_time':targeted_time.toString(),
      'start_from': start_from.toString(),
      'end_on': end_on.toString()
    };
  }

   NoticeModel toModel(var database) {
        return NoticeModel(
        title: database['title'],
        content: database['content'],
        targeted_time: (database['targeted_time'])!=null? (DateTime.tryParse(database['targeted_time'])):null,
        start_from: DateTime.parse(database['start_from']) ,
        end_on: DateTime.parse(database['end_on']));
  }

      
}
