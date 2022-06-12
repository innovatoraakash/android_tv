import 'video_model.dart';

List<VideoModel> VideoData = [
  VideoModel(
      file_link: "/storage/emulated/0/DCIM/Camera/20220220_140031.mp4",
      haveImage: true,
      image_link: "assets/ntc.webp",
      start_from: DateTime(2022, 5, 2, 12, 5),
      end_on: DateTime(2022, 7, 2, 12, 5),
      day_count: 5),
      
      
  VideoModel(
      file_link: "/storage/emulated/0/DCIM/Camera/20220525_193948.mp4",
      haveImage: false,
      start_from: DateTime(2022, 5, 2, 12, 5),
      end_on: DateTime(2022, 7, 2, 12, 5),
      day_count: 10),
  VideoModel(
      file_link: "/storage/emulated/0/Video/Awesome.mp4",
      haveImage: true,
      image_link: "assets/ntc.webp",
      start_from: DateTime(2022, 5, 2, 12, 5),
      end_on: DateTime(2022, 7, 2, 12, 5),day_count: 11),
  VideoModel(
      file_link: "/storage/emulated/0/DCIM/Camera/20220223_184635.mp4",
      haveImage: false,
      start_from: DateTime(2022, 5, 2, 12, 5),
      end_on: DateTime(2022, 7, 2, 12, 5),day_count: 100),

  // VideoModel(file_link: "assets/video.mp4",haveImage:false),
  // VideoModel(file_link: "assets/video.mp4",haveImage:true,image_link: "assets/ntc.webp"),
  // VideoModel("storage/emulated/0"),
];
