import 'package:flutter/material.dart';

class MarqueeWidget extends StatefulWidget {
  final Widget child;
  final Axis direction;
  final Duration animationDuration, pauseDuration;
  final ScrollController scrollController;

  const MarqueeWidget({
    Key key,
    @required this.child,
    this.scrollController,
    this.direction = Axis.horizontal,
    this.animationDuration = const Duration(milliseconds: 6000),
    this.pauseDuration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  _MarqueeWidgetState createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<MarqueeWidget> {
  ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = widget.scrollController;
    _scrollController = ScrollController(initialScrollOffset: 0);
    WidgetsBinding.instance?.addPostFrameCallback(scroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: widget.child,
      scrollDirection: widget.direction,
      controller: _scrollController,
      reverse: false,
    );
  }

  void scroll(_) async {
    while (_scrollController.hasClients) {
      await Future.delayed(widget.pauseDuration);
      if (_scrollController.hasClients) {
        await _scrollController
            .animateTo(
              _scrollController.position.maxScrollExtent,
              duration: widget.animationDuration,
              curve: Curves.linear,
            )
            .whenComplete(() {});
      }
      // _scrollController.dispose();
    
      await Future.delayed(widget.pauseDuration);
    }
  }
}
