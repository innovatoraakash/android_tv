class VideoModel {
  VideoModel(
      {this.file_link,
      this.haveImage,
      this.image_link,
      this.end_on,
      this.start_from,
      this.day_count,
      this.name,
      this.id,
      this.time_to_play_image});
  int id;
  String name;
  String file_link;
  bool haveImage = false;
  int time_to_play_image;
  String image_link;
  DateTime start_from;
  DateTime end_on;
  int day_count;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'file_link': file_link,
      'have_image': haveImage,
      'image_link': image_link,
      'start_from': start_from.toString(),
      'end_on': end_on.toString(),
      'day_count': day_count,
      'time_to_play_image': time_to_play_image
    };
  }

  @override
  String toString() {
    return 'VideoModel{ file_link: $file_link, have_Image: $haveImage, image_link: $image_link, start_from: $start_from, end_on: $end_on,day_count:$day_count}';
  }

  VideoModel toModel(var database) {
    return VideoModel(
        id: database['_id'],
        name: database['name'],
        file_link: database['file_link'],
        haveImage: database['have_image'] == 1 ? true : false,
        image_link: database['image_link'],
        start_from: DateTime.parse(database['start_from']),
        end_on: DateTime.parse(database['end_on']),
        day_count: database['day_count'],
        time_to_play_image: database['time_to_play_image']);
  }
}
