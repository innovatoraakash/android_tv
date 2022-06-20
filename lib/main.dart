import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:video_example/constants/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:video_example/cubit/cubit/image_cubit.dart';
import 'package:video_example/database/realtime_database.dart';
import 'package:video_example/database/temp_database.dart';
import 'package:video_example/model/items/ItemModel.dart';
import 'package:video_example/model/notice_slider/notice_data.dart';
import 'package:video_example/model/video/video_data.dart';
import 'package:video_example/screens/image_player.dart';
import 'package:video_example/service/api_service.dart';
import 'package:video_example/service/file_downloader.dart';
import 'package:video_example/service/permission_handler.dart';
import '/cubit/cubit/notice_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/widget/basic_overlay_widget.dart';
import 'screens/file_player.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:firebase_core/firebase_core.dart';

bool L_shape_add = false;
String testset;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp firebaseApp = await Firebase.initializeApp();

  // Plugin must be initialized before using
  await FlutterDownloader.initialize(
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => NoticeCubit(),
        child: BlocProvider(
          create: (context) => ImageCubit(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Video Player',
            theme: ThemeData(
              primaryColor: Colors.blueAccent,
              scaffoldBackgroundColor: Colors.black,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              colorScheme: ColorScheme.dark(),
            ),
            home: MainPage(),
          ),
        ),
      );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;
  void initState() {
    super.initState();
    setState(() {
      testset = firefire();
    });

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    PermissionHandle();
    fetchInitialData();
    //uncoment below database call at the 1st run to add model data in databse
    // _insert();
    // _insertNotice();
  }

  fetchInitialData() async {
    print("hello");
    var items = await ItemRepo().getItems().whenComplete(() => null);
    items.forEach((element) async {
      print('items:${element.id}');
      final id = await dbHelper.insert(element.toMap(), item_table);
      print('inserted row id: $id');
    });

    //  for(var item in items){

    //  }
  }

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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          FilePlayerWidget(),
          BlocBuilder<ImageCubit, bool>(
            builder: (context, state) {
              return Visibility(
                child: ImagePlayer(),
                visible: state,
              );
            },
          ),
          BasicOverlayWidget(),
          Center(child: Text(testset ?? "hello"))

          // Download(),
          // TestDatabase()
        ],
      ),
    );
  }
}




