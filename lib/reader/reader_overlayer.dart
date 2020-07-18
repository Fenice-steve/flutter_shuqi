import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:shuqi/public.dart';
import 'package:shuqi/reader/back_color_change_provider.dart';
import 'battery_view.dart';

class ReaderOverlayer extends StatelessWidget {
  final Article article;
  final int page;
  final double topSafeHeight;

  ReaderOverlayer({this.article, this.page, this.topSafeHeight});

  @override
  Widget build(BuildContext context) {
    var format = DateFormat('HH:mm');
    var time = format.format(DateTime.now());

    return Container(
//      padding: EdgeInsets.fromLTRB(
//          15, 10 + topSafeHeight, 15, 10 + Screen.bottomSafeHeight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
            width: MediaQuery.of(context).size.width,
            height: topSafeHeight + 10,
            color: Provider.of<BackgroundColor>(context, listen: true)
                .isTapColor,
            child: Text(article.title,
                style: TextStyle(
                    fontSize: fixedFontSize(14), color: SQColor.golden)),
          ),
          Expanded(child: Container()),
          Container(
            padding: EdgeInsets.fromLTRB(15, 10 , 15, 10+ Screen.bottomSafeHeight),
            color: Provider.of<BackgroundColor>(context, listen: true)
                .isTapColor,
            child: Row(
              children: <Widget>[
                BatteryView(),
                SizedBox(width: 10),
                Text(time,
                    style: TextStyle(
                        fontSize: fixedFontSize(11), color: SQColor.golden)),
                Expanded(child: Container()),
                Text('第${page + 1}页',
                    style: TextStyle(
                        fontSize: fixedFontSize(11), color: SQColor.golden)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
