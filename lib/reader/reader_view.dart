import 'package:flutter/material.dart';

import 'package:shuqi/public.dart';
import 'reader_overlayer.dart';
import 'reader_utils.dart';
import 'reader_config.dart';
import 'reader_menu.dart';
import 'package:provider/provider.dart';
import 'fontSize_provider.dart';
import 'fontSpace_provider.dart';

class ReaderView extends StatelessWidget {
  final Article article;
  final int page;
  final double topSafeHeight;

  ReaderView({this.article, this.page, this.topSafeHeight});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
//        Positioned(left: 0, top: 0, right: 0, bottom: 0, child: Image.asset('img/read_bg.png', fit: BoxFit.cover)),
        /// 底色改为白色
        Positioned(left: 0, top: 0, right: 0, bottom: 0, child: Container(color: Colors.white,)),
        ReaderOverlayer(article: article, page: page, topSafeHeight: topSafeHeight),
        buildContent(article, page, context),
      ],
    );
  }

  buildContent(Article article, int page, context) {
    var content = article.stringAtPageIndex(page);

    if (content.startsWith('\n')) {
      content = content.substring(1);
    }
    return
      Opacity(opacity: 0.5,child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.fromLTRB(15, topSafeHeight + ReaderUtils.topOffset, 10, Screen.bottomSafeHeight + ReaderUtils.bottomOffset),
        child: Text.rich(
          TextSpan(children: [TextSpan(text: content, style: TextStyle(
            /// 这里修改字号
//            fontSize: fixedFontSize(ReaderConfig.instance.fontSize)
              fontSize: Provider.of<fontSize>(context ,listen: true).fontSizeSet,
              /// 这里修改间距
              height: Provider.of<FontSpace>(context ,listen: true).fontSpaceSet
          ))]),
          textAlign: TextAlign.justify,
        ),
      ),)
      ;
  }
}
