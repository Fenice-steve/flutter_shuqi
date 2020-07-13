import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:shuqi/public.dart';
import 'battery_view.dart';

/// 阅读器的目录
class ReaderDrawer extends StatefulWidget {
  final List<Chapter> chapters;

  const ReaderDrawer({Key key, this.chapters}) : super(key: key);

  @override
  _ReaderDrawerState createState() => _ReaderDrawerState();
}

class _ReaderDrawerState extends State<ReaderDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
          child: Column(
        children: <Widget>[
          Container(
            color: Color(0xFFDED9C5),
            child: Row(
              children: <Widget>[
                Image.asset("name"),
                Column(
                  children: <Widget>[Text("那年盛夏微微甜"), Text("作者名")],
                )
              ],
            ),
          ),
          Container(
            color: Color(0xFFDED9C5),
            child: Row(
              children: <Widget>[
                Expanded(child: Text("已完结 共84章")),
                GestureDetector(
                  onTap: () {},
                  child: Text("正序"),
                )
              ],
            ),
          ),
        Expanded(
          child:
          ListView.separated(
            itemCount: widget.chapters.length,
            itemBuilder: (context, index) {
              return itemView(index);
            },
            separatorBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
                child: Divider(height: 1, color: Colors.black),
              );
            },
          ),
        )
        ],
      )),
    );
  }


  Widget itemView(int index){
    return Container(
      child: Text(widget.chapters[index].title),
    );
  }



//  Widget itemView(int index) {
//    return Material(
//      color: Colors.transparent,
//      child: InkWell(
//        onTap: () {
////          setState(() {
////            setState(() {
////              _loadStatus = LoadStatus.LOADING;
////              this.widget._initOffset = 0;
////              this.widget._index = index;
////              this.widget._bookUrl = _listBean[index].link;
////              getData();
////            });
////          });
////          Navigator.pop(context);
//        },
//        child: Padding(
//          padding: EdgeInsets.fromLTRB(
//              Dimens.leftMargin, 16, Dimens.rightMargin, 16),
//          child: Row(
//            crossAxisAlignment: CrossAxisAlignment.center,
//            mainAxisSize: MainAxisSize.max,
//            children: <Widget>[
//              Padding(
//                padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
//                child: Text(
//                  "${index + 1}.  ",
//                  style: TextStyle(fontSize: 9, color: MyColors.textBlack9),
//                ),
//              ),
//              Expanded(
//                child: Text(
//                  _listBean[index].title,
//                  style: TextStyle(
//                    fontSize: Dimens.textSizeM,
//                    color: this.widget._index == index
//                        ? MyColors.textPrimaryColor
//                        : MyColors.textBlack9,
//                  ),
//                ),
//              ),
//              _listBean[index].isVip
//                  ? Image.asset(
//                "images/icon_chapters_vip.png",
//                width: 16,
//                height: 16,
//              )
//                  : Container(),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
}
