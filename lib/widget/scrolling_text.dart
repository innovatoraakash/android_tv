import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_example/cubit/cubit/notice_cubit.dart';
import 'package:video_example/model/notice_slider/notice_data.dart';

class ScrollingText extends StatefulWidget {
  const ScrollingText({
    Key key,
  }) : super(key: key);

  @override
  State<ScrollingText> createState() => _ScrollingTextState();
}

class _ScrollingTextState extends State<ScrollingText> {
  ScrollController _scrollController = ScrollController();
  PageController pageController = PageController();
  int index = 0;
  List<Widget> pageBody;
  //  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageBody = List<Widget>.generate(
        NoticeData.length, (int index) => SinglePage(index));
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addTimingsCallback((timeStamp) {
      double maxScrollExtent1 = _scrollController.position.maxScrollExtent;

      animateToMaxMin(maxScrollExtent1, 2, _scrollController);
          // print("ended in 1");

    });
  }

  animateToMaxMin(
      double direction, int seconds, ScrollController scrollController) {
    scrollController
        .animateTo(direction,
            duration: Duration(seconds: seconds), curve: Curves.linear)
        .then((value) {
      // BlocProvider.of<NoticeCubit>(context).DataChanged();
      // context.read<NoticeCubit>().DataChanged;
      // direction = direction == max ? min : max;
      // print("ended in 1");
      // animateToMaxMin(direction, seconds, scrollController);
    });
    // print("ended in 1");
  }

  _scrollListener() {
    var position = _scrollController.position.outOfRange;
    print("hello$position");
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("ended in 2");
      _onEndScroll();
      // context.read<NoticeCubit>().DataChanged;
    }
  }

  Widget SinglePage(int i) {
    return ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: NoticeData[i].content.split(" ").length,
        itemBuilder: (context, _index) {
          return Container(
            margin: EdgeInsets.all(2),
            child: Text(NoticeData[i].content.split(" ")[_index]),
          );
        });
  }

  void _animateSlider(int _index) {
        _scrollController.dispose();

    // int nextPage = pageController.page.round() + 1;

    if (_index == NoticeData.length) {
      _index = 0;
    }

    pageController.animateToPage(_index,
        duration: Duration(seconds: 2), curve: Curves.linear);
  }

  _onEndScroll() {
    print("Scroll End");
    // _scrollController.dispose();
    index++;
    _animateSlider(index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoticeCubit, NoticeState>(
      builder: (context, state) {
        return Container(
          height: 50,
          child: PageView(controller: pageController, children: pageBody,onPageChanged: (value){
            
          },),
        );
      },
    );
  }
}
