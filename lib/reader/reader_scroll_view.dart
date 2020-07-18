import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screen/screen.dart';
import 'package:shuqi/model/article.dart';
import 'package:shuqi/reader/back_color_change_provider.dart';
import 'package:shuqi/reader/fontSize_provider.dart';
import 'package:shuqi/reader/fontSpace_provider.dart';
import 'package:shuqi/reader/reader_overlayer.dart';

/// 上下翻页的SingleChildScrollView封装
class ReaderScrollView extends StatefulWidget {

  final Article article;
  /// 上下滑动时页数的计算？？？？
  final int page;
  final double topSafeHeight;

  const ReaderScrollView({Key key, this.article, this.page, this.topSafeHeight}) : super(key: key);

  @override
  _ReaderScrollViewState createState() => _ReaderScrollViewState();
}

class _ReaderScrollViewState extends State<ReaderScrollView> {

  ScrollController _controller;


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        /// 背景色
        Positioned(     left: 0,
        top: 0,
        right: 0,
            bottom: 0,
            child: Container(
            color:

            Provider.of<BackgroundColor>(context, listen: true)
            .isTapColor
            )),
        Container(
          child: buildScrollContent(widget.article, widget.page, context),
          color: Colors.transparent,
        ),
        /// 上下翻页的上下边框设置
        ReaderOverlayer(
          article: widget.article, page: widget.page, topSafeHeight: widget.topSafeHeight,
        ),
        /// SingleChildScrollView的上下滑动

      ],
    );
  }

  buildScrollContent(Article article, int page, context){

    var content = article.stringAtPageIndex(page);

    if(content.startsWith('\n')){
      content = content.substring(1);
    }

    return SingleChildScrollView(
      controller: _controller,
      padding: EdgeInsets.fromLTRB(
        16,
        16 + MediaQuery.of(context).padding.top,
        9,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            widget.article.title,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF9F8C54),
            ),
          ),
          SizedBox(
            height: 16,
          ),
      Text.rich(
        TextSpan(children: [
          TextSpan(
              text: content,
              style: TextStyle(

                /// 这里修改字号
                  fontSize: Provider.of<fontSize>(context, listen: true)
                      .fontSizeSet,
                  color: Provider.of<BackgroundColor>(context, listen: true)
                      .isChangeTextColor,

                  /// 这里修改间距
                  height: Provider.of<FontSpace>(context, listen: true)
                      .fontSpaceSet))
        ]),
        textAlign: TextAlign.justify,
      ),
          SizedBox(
            height: 12,
          ),
        ],
      )
    );
  }
}
