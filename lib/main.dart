import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:video_example/cubit/cubit/image_cubit.dart';
import 'package:video_example/database/temp_database.dart';
import 'package:video_example/screens/image_player.dart';
import 'package:video_example/service/file_downloader.dart';
import 'package:video_example/service/permission_handler.dart';
import '/cubit/cubit/notice_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/widget/basic_overlay_widget.dart';
import 'screens/file_player.dart';
import 'package:flutter_downloader/flutter_downloader.dart';


bool L_shape_add = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    PermissionHandle();
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

          // Download(),
          // TestDatabase()
        ],
      ),
    );
  }
}
