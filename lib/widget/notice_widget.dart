import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_example/constants/constants.dart';
import 'package:video_example/cubit/cubit/notice_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:marquee/marquee.dart';
import 'package:async/async.dart';

import 'package:marquee_widget/marquee_widget.dart';
import 'package:video_example/model/marquee_model.dart';
import 'package:video_example/model/notice_slider/notice_data.dart';
import 'package:video_example/model/notice_slider/notice_model.dart';
import 'dart:async';
import 'package:video_example/database/database.dart';
import 'package:video_example/widget/marquee_widget.dart';

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
  ScrollController scrollController;
  int index = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //fetch data from database
    FetchDatabase();
  }

  FetchDatabase() async {
    final allRows =
        await dbHelper.queryAllRows(notice_table).whenComplete(() {});
    print('database${allRows}');
    for (var row in allRows) {
      notice_data.add(NoticeModel().toModel(row));
    }

    //generate list of marque for notice
    ListGenerator();

    CheckTargetedTime();
  }

  void CheckTargetedTime() {
    timerForNext();
    Timer.periodic(Duration(minutes: 1), (timer) {
      for (var noticeData in notice_data) {
        if (noticeData.targeted_time != null) {
          var difference_time =
              noticeData.targeted_time.difference(DateTime.now()).inMinutes;
          if (difference_time == 0) {
            print("inside mesh");
            MarqueeModel targeted_marquee = MarqueeModel(
                marquee: marquee(noticeData),
                title: noticeData.title,
                content: noticeData.content);

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

  void timerForNext() {
    Timer(
        Duration(
            seconds: (pageBody[this.index].content.length * 0.0285).floor() +
                2), () {
      // scrollController = ScrollController(initialScrollOffset: 50.0);
      if (this.index < (pageBody.length - 1)) {
        setState(() {
          this.index++;
        });
      } else {
        this.index = 0;
      }

      print("into timer${this.index}");
      setState(() {
        // pageController.jumpToPage(3);
        // pageController.animateToPage(index,
        //     duration: Duration(seconds: 1), curve: Curves.easeIn);
      });

      print("cancel timer");
      // scrollController.dispose();
      timerForNext();
    });
  }

  void ListGenerator() {
    final dateNow = DateTime.now();

    for (NoticeModel noticeData in notice_data) {
      if (dateNow.isAfter(noticeData.start_from) &&
          dateNow.isBefore(noticeData.end_on)) {
        print("here in");
        pageBody.add(MarqueeModel(
            marquee:
                //  MarqueeWidget(
                //   key: Key(index.toString()),
                //   scrollController: ScrollController(),
                //   animationDuration:
                //       Duration(seconds: (noticeData.content.length * 0.05).floor()),
                //   child: Text(
                //     noticeData.content != ""
                //         ? noticeData.content
                //         : "Nepal Telecome",
                //     style: TextStyle(
                //         fontSize: MediaQuery.of(context).size.height * 0.025),
                //   ),
                // ),

                Marquee(
              backDuration: Duration(seconds: 0),
              pauseDuration: Duration(seconds: 1),
              autoRepeat: false,
              forwardAnimation: Curves.linear,
              animationDuration: Duration(
                  seconds: (noticeData.content.length * 0.023).floor()),
              directionMarguee: DirectionMarguee.oneDirection,
              child: Text(
                noticeData.content != ""
                    ? noticeData.content
                    : "Nepal Telecome",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.025),
              ),

              //   style: TextStyle(
              //       fontSize: MediaQuery.of(context).size.height * 0.025),
              //   text: noticeData.content != ""
              //       ? "                    " + noticeData.content
              //       : "Nepal Telecome",
              //   numberOfRounds: 1,

              //   velocity: 20,
              //   onDone: () {
              //     print("newskoindex ");
              //   },
              //   startPadding: 0,
            ),
            title: noticeData.title,
            content: noticeData.content));
      }
    }
  }

  Widget marquee(NoticeModel noticeData) {
    return Marquee(
        // text: noticeData.content != "" ? noticeData.content : "Nepal Telecome",
        // numberOfRounds: 1,
        // pauseAfterRound: Duration(seconds: 10),
        // velocity: 20,
        // onDone: () {
        //   print("newskoindex ");
        // },
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
                  child: Center(
                      child: pageBody.isNotEmpty
                          ? Text(
                              pageBody[index].title,
                              style: TextStyle(fontSize: size.height * 0.033),
                            )
                          : Container()),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 169, 182, 200))),
                )),
            Expanded(
              child: Container(
                  height: size.height * 0.048,
                  color: Color.fromARGB(255, 62, 76, 88).withOpacity(0.5),
                  child:
                      // ScrollingText();

                      //   CarouselSlider.builder(
                      //     options: CarouselOptions(autoPlay: true),
                      // itemCount: pageBody.length,
                      // itemBuilder: (BuildContext context, int itemIndex,
                      //         int pageViewIndex) =>
                      //     Container(
                      //   child: pageBody[itemIndex].marquee,
                      // ),
                      // );
                      PageView.builder(
                    itemCount: pageBody.length,
                    itemBuilder: (context, _index) {
                      return pageBody[index].marquee;
                    },
                    controller: pageController,
                    onPageChanged: (int _index) {
                      setState(() {
                        index = _index;
                      });
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
