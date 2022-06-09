class VideoModel {
  VideoModel(
      {this.file_link,
      this.haveImage,
      this.image_link,
      this.end_on,
      this.start_from});
  String file_link;
  bool haveImage = false;
  String image_link;
  DateTime start_from;
  DateTime end_on;

  Map<String, dynamic> toMap() {
    return {
      'file_link': file_link,
      'have_image': haveImage,
      'image_link': image_link,
      'start_from': start_from.toString(),
      'end_on': end_on.toString()
    };
  }

  @override
  String toString() {
    return 'VideoModel{ file_link: $file_link, have_Image: $haveImage, image_link: $image_link, start_from: $start_from, end_on: $end_on}';
  }

  VideoModel toModel(var database) {
        return VideoModel(
        file_link: database['file_link'],
        haveImage: database['have_image']==1?true:false,
        image_link: database['image_link'],
        start_from: DateTime.parse(database['start_from']) ,
        end_on: DateTime.parse(database['end_on']));
  }
    

  // return List.generate(maps.length, (i) {
  //   return Recipe(
  //     id: maps[i]['id'],
  //     name: maps[i]['name'],
  //     // Same for the other properties
  //   );
  // });
}
