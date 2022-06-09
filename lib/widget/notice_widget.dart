

import 'package:video_example/constants/constants.dart';
import 'package:video_example/cubit/cubit/notice_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:video_example/model/marquee_model.dart';
import 'package:video_example/model/notice_slider/notice_model.dart';
import 'dart:async';
import 'package:video_example/database/database.dart';

int index = 0;
PageController pageController;
final dbHelper = VideoDatabaseHelper.instance;
List<NoticeModel> notice_data = [];

List<MarqueeModel> pageBody = [];

class NoticeWIdget extends StatefulWidget {
  const NoticeWIdget({Key key}) : super(key: key);

  @override
  State<NoticeWIdget> createState() => _NoticeWIdgetState();
}

class _NoticeWIdgetState extends State<NoticeWIdget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   

   //fetch data from database
    FetchDatabase();
   
    

    // Timer.periodic(Duration(seconds: (notice_data[index].content.length ~/ 5)),
    //     (timer) {
    //   if (index < notice_data.length - 1) {
    //     setState(() {
    //       index++;
    //     });
    //   } else
    //     (index = 0);
    //   print("into timer${index}");
    //   setState(() {
    //     pageController.animateToPage(index,
    //         duration: Duration(seconds: 1), curve: Curves.easeIn);
    //   });
    // });

    
  }

  FetchDatabase() async {
    final allRows = await dbHelper.queryAllRows(notice_table).whenComplete(() {
      
    });
    print('database${allRows}');
    for (var row in allRows) {
      notice_data.add(NoticeModel().toModel(row));
    }

     //generate list of marque for notice
    ListGenerator();

    CheckTargetedTime();
  }

  void CheckTargetedTime() {
    Timer.periodic(Duration(minutes: 1), (timer) {
      for (var noticeData in notice_data) {
        if (noticeData.targeted_time != null) {
          var difference_time =
              noticeData.targeted_time.difference(DateTime.now()).inMinutes;
          if (difference_time == -16) {
            print("inside mesh");
            MarqueeModel targeted_marquee = MarqueeModel(
                marquee: marquee(noticeData), title: noticeData.title);

            setState(() {
              pageBody = [];
              pageBody.add(targeted_marquee);
            });

            Timer(Duration(seconds: 30), () {
              pageBody = [];
              ListGenerator();
              setState(() {});
            });
          }
        }
      }
    });
  }

  void ListGenerator() {
    final dateNow = DateTime.now();

    for (NoticeModel noticeData in notice_data) {
      if (dateNow.isAfter(noticeData.start_from) &&
          dateNow.isBefore(noticeData.end_on)) {
        print("here in");
        pageBody.add(MarqueeModel(
            marquee: Marquee(
              style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.022),
              text: noticeData.content != ""
                  ? noticeData.content
                  : "Nepal Telecome",
              numberOfRounds: 1,
              pauseAfterRound: Duration(seconds: 10),
              velocity: 20,
              onDone: () {
                print("newskoindex ");
              },
            ),
            title: noticeData.title));
      }
    }
  }

  Widget marquee(NoticeModel noticeData) {
    return Marquee(
      text: noticeData.content != "" ? noticeData.content : "Nepal Telecome",
      numberOfRounds: 1,
      pauseAfterRound: Duration(seconds: 10),
      velocity: 20,
      onDone: () {
        print("newskoindex ");
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Center(
        child: Row(
          children: [
            Container(
                height: size.height * 0.05,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Center(child: pageBody.isNotEmpty? Text(pageBody[index].title,style:TextStyle(fontSize: size.height*0.033) ,):Container()),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 169, 182, 200))),
                )),
            Expanded(
              child: Container(
                  height: size.height * 0.048,
                  color: Color.fromRGBO(33, 150, 243, 1).withOpacity(0.3),
                  child: BlocBuilder<NoticeCubit, NoticeState>(
                    builder: (context, state) {
                      return
                          // ScrollingText();
                          PageView.builder(
                        itemCount: pageBody.length,
                        itemBuilder: (context, _index) {
                          return pageBody[_index].marquee;
                        },
                        controller: pageController,
                        onPageChanged: (int _index) {
                          setState(() {
                            index = _index;
                          });
                        },
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
