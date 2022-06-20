import 'package:video_example/constants/constants.dart';
import 'package:flutter/material.dart';
// import 'package:marquee/marquee.dart';

import 'package:marquee_widget/marquee_widget.dart';
import 'package:video_example/model/marquee_model.dart';
import 'package:video_example/model/notice_slider/notice_model.dart';
import 'dart:async';
import 'package:video_example/database/database.dart';

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
  var size;
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
    // timerForNext();
    Timer.periodic(Duration(minutes: 1), (timer) {
      for (var noticeData in notice_data) {
        if (noticeData.targeted_time != null) {
          var difference_time =
              noticeData.targeted_time.difference(DateTime.now()).inMinutes;
          if (difference_time == 0) {
            MarqueeModel targeted_marquee = MarqueeModel(
                marquee: marquee(noticeData),
                title: noticeData.title,
                content: noticeData.content);

            setState(() {
              pageBody = [];
              pageBody.add(targeted_marquee);
            });

            Timer(Duration(seconds: 60), () {
              pageBody = [];
              ListGenerator();
              setState(() {});
            });
          }
        }
      }
    });
  }

  playNext() {
    if (this.index < (pageBody.length - 1)) {
      setState(() {
        this.index++;
      });
    } else {
      this.index = 0;
    }

    setState(() {});
  }

  void ListGenerator() {
    size = MediaQuery.of(context).size;
    final dateNow = DateTime.now();

    for (NoticeModel noticeData in notice_data) {
      if (dateNow.isAfter(noticeData.start_from) &&
          dateNow.isBefore(noticeData.end_on)) {
        print("here in");
        pageBody.add(MarqueeModel(
            marquee: marquee(noticeData),
            title: noticeData.title,
            content: noticeData.content));
      }
    }
  }

  Widget marquee(NoticeModel noticeData) {
    return Marquee(
      onFinish: () {
        print("from call back");
        playNext();
      },
      backDuration: Duration(seconds: 0),
      pauseDuration: Duration(milliseconds: 700),
      autoRepeat: false,
      forwardAnimation: Curves.linear,
      animationDuration:
          Duration(seconds: (noticeData.content.length * 0.053).floor()),
      directionMarguee: DirectionMarguee.oneDirection,
      child: Text(
        noticeData.content != ""
            ? noticeData.content +
                List.generate((size.width * 0.35).floor(), (index) => ' ')
                    .join()
            : "Nepal Telecome",
        style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.025),
      ),
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
                  child: PageView.builder(
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
