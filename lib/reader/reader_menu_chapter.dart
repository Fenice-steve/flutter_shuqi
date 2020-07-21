import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shuqi/reader/back_color_change_provider.dart';

/// 左側章节
class ReaderMenuChapter extends StatefulWidget {
  final void Function(int, int) onTypeTap;

  ReaderMenuChapter(this.onTypeTap);

  @override
  _ReaderMenuChapterState createState() => _ReaderMenuChapterState();
}

class _ReaderMenuChapterState extends State<ReaderMenuChapter>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    animation.addListener(() {
      setState(() {});
    });
    animationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  hide(int type, int value) {
    animationController.reverse();
    Timer(Duration(milliseconds: 200), () {
      this.widget.onTypeTap(type, value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            color: Color(0x7F000000),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Positioned(
            left: -300 * (1 - animation.value),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  color: Provider.of<BackgroundColor>(context, listen: true)
                      .isTapColor,
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.symmetric(horizontal: 14),
                ),
                GestureDetector(
                  onTap: () {
                    hide(1, 0);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 300,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
