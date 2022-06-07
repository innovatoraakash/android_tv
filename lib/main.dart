// import 'dart:ffi';
// import 'dart:js';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:video_example/constants/constants.dart';
import 'package:video_example/cubit/cubit/image_cubit.dart';
import 'package:video_example/widget/image_player.dart';
import '/cubit/cubit/notice_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/widget/basic_overlay_widget.dart';
import '/widget/basics/file_player_widget.dart';

bool L_shape_add = false;
void main() => runApp(MyApp(
  
));

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
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
          BasicOverlayWidget()
        ],
      ),

      // Row(
      //   children: [
      //     Visibility(child: Container(width: size.width*0.2,),visible: L_shape_add, replacement : const SizedBox.shrink(),),
      //     Column(
      //       children: [
      //         Expanded(
      //           child: Stack(
      //             children: [FilePlayerWidget(), BasicOverlayWidget()],
      //           ),
      //         ),
      //         Visibility(child: Container(height: size.height*0.2, width: size.width*0.8,),visible: L_shape_add,)
      //       ],
      //     ),
      //   ],
      // ),
    );
  }
}
