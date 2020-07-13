import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:shuqi/public.dart';
import 'package:shuqi/reader/back_color_change_provider.dart';
import 'package:shuqi/reader/circle_select_button.dart';
import 'package:shuqi/reader/fontSpace_provider.dart';
import 'package:shuqi/reader/font_size_button.dart';
import 'package:shuqi/reader/reader_drawer.dart';
import 'package:shuqi/reader/reader_scene.dart';
import 'package:screen/screen.dart' as lightScreen;
import 'package:provider/provider.dart';
import 'fontSize_provider.dart';
import 'change_night_provider.dart';

class ReaderMenu extends StatefulWidget {
  List<Chapter> chapters = [];
  final int articleIndex;

  final VoidCallback onTap;
  final VoidCallback onPreviousArticle;
  final VoidCallback onNextArticle;
  final void Function(Chapter chapter) onToggleChapter;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  /// 章节是否倒序
  bool isReversed = false;

  /// 目录选择的 item 索引
  int index = 0;

  ReaderMenu(
      {this.chapters,
      this.articleIndex,
      this.onTap,
      this.onPreviousArticle,
      this.onNextArticle,
      this.onToggleChapter,
      this.isReversed,
      this.index});

  @override
  _ReaderMenuState createState() => _ReaderMenuState();
}

class _ReaderMenuState extends State<ReaderMenu>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  double progressValue;
  bool isTipVisible = false;

  @override
  initState() {
    super.initState();

    progressValue =
        this.widget.articleIndex / (this.widget.chapters.length - 1);
    animationController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    animation.addListener(() {
      setState(() {});
    });
    animationController.forward();
  }

  @override
  void didUpdateWidget(ReaderMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    progressValue =
        this.widget.articleIndex / (this.widget.chapters.length - 1);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  hide() {
    animationController.reverse();
    Timer(Duration(milliseconds: 200), () {
      this.widget.onTap();
    });
    setState(() {
      isTipVisible = false;
    });
  }

  buildTopView(BuildContext context) {
    return Positioned(
      top: -Screen.navigationBarHeight * (1 - animation.value),
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
            color: SQColor.menuDark, boxShadow: Styles.borderShadow),
        height: Screen.navigationBarHeight,
        padding: EdgeInsets.fromLTRB(5, Screen.topSafeHeight, 5, 0),
        child: Row(
          children: <Widget>[
            Container(
              width: 44,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  'img/pub_back_gray.png',
                  color: SQColor.white,
                  width: 15,
                  height: 15,
                ),
              ),
            ),
            Expanded(child: Container()),
            Container(
              width: 50,
//              child: Image.asset('img/read_icon_voice.png'),
              /// 改为汉字
              child: Text(
                "下载",
                style: TextStyle(color: SQColor.white),
              ),
            ),
            Container(
              width: 60,
//              child: Image.asset('img/read_icon_voice.png'),
              /// 改为汉字
              child: Text("加入书架", style: TextStyle(color: SQColor.white)),
            ),
//            GestureDetector(
//              onTap: (){
//                onPopMenu();
//              },
//              child:

            Container(
              width: 44,
              child: onPopMenu(),
            ),
//            )
          ],
        ),
      ),
    );
  }

  int currentArticleIndex() {
    return ((this.widget.chapters.length - 1) * progressValue).toInt();
  }

  buildProgressTipView() {
    if (!isTipVisible) {
      return Container();
    }
    Chapter chapter = this.widget.chapters[currentArticleIndex()];
    double percentage = chapter.index / (this.widget.chapters.length - 1) * 100;
    return Opacity(
      opacity: 0.8,
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xFF000000), borderRadius: BorderRadius.circular(5)),
        margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
        padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(chapter.title,
                style: TextStyle(color: Colors.white, fontSize: 16)),
            Text('${percentage.toStringAsFixed(1)}%',
                style: TextStyle(color: SQColor.lightGray, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  previousArticle() {
    if (this.widget.articleIndex == 0) {
      Toast.show('已经是第一章了');
      return;
    }
    this.widget.onPreviousArticle();
    setState(() {
      isTipVisible = true;
    });
  }

  nextArticle() {
    if (this.widget.articleIndex == this.widget.chapters.length - 1) {
      Toast.show('已经是最后一章了');
      return;
    }
    this.widget.onNextArticle();
    setState(() {
      isTipVisible = true;
    });
  }

  buildProgressView() {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: previousArticle,
            child: Container(
              padding: EdgeInsets.all(20),
//              child: Image.asset('img/read_icon_chapter_previous.png'),
              /// 改为汉字
              child: Text(
                "上一章",
                style: TextStyle(color: SQColor.white),
              ),
            ),
          ),
          Expanded(
            child: Slider(
              value: progressValue,
              onChanged: (double value) {
                setState(() {
                  isTipVisible = true;
                  progressValue = value;
                });
              },
              onChangeEnd: (double value) {
                Chapter chapter = this.widget.chapters[currentArticleIndex()];
                this.widget.onToggleChapter(chapter);
              },
              activeColor: SQColor.white,
              inactiveColor: SQColor.gray,
            ),
          ),
          GestureDetector(
            onTap: nextArticle,
            child: Container(
              padding: EdgeInsets.all(20),
//              child: Image.asset('img/read_icon_chapter_next.png'),
              /// 改为汉字
              child: Text(
                "下一章",
                style: TextStyle(color: SQColor.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  buildBottomView() {
    return Positioned(
      bottom: -(Screen.bottomSafeHeight + 110) * (1 - animation.value),
      left: 0,
      right: 0,
      child: Column(
        children: <Widget>[
          buildProgressTipView(),
          Container(
            decoration: BoxDecoration(
                color: SQColor.menuDark, boxShadow: Styles.borderShadow),
            padding: EdgeInsets.only(bottom: Screen.bottomSafeHeight),
            child: Column(
              children: <Widget>[
                buildProgressView(),
                buildBottomMenus(),
              ],
            ),
          )
        ],
      ),
    );
  }

  buildBottomMenus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        GestureDetector(
          onTap: () {
//            Navigator.of(context).pop();
//          hide();
//            animationController.reverse();

            widget._scaffoldKey.currentState.openDrawer();
//            openDrawer().then((value) => (){
//              debugPrint("点击打开了抽屉");
//            });
          },
          child: buildBottomItem('目录', 'img/read_icon_catalog.png'),
        ),
        buildBottomItem('亮度', 'img/read_icon_brightness.png'),
        GestureDetector(
          onTap: () {
            hide();
            showBottomDialog();
          },
          child: buildBottomItem('设置', 'img/read_icon_setting.png'),
        ),
      ],
    );
  }

  /// 延迟打开drawer
  Future openDrawer() async {
//    Timer(Duration(milliseconds: 300), () {
    Future.delayed(
      Duration(milliseconds: 300),
    );
    widget._scaffoldKey.currentState.openDrawer();
//    });
  }

  void showBottomDialog() {
//    Color _tapLargeSpaceColor = Provider.of<FontSpace>(context, listen: true)
//        .tapLargeFontSpace ? Color(0xFF1C8AEC) : Color(0xFFF6F6F6);
//    Color _tapMidSpaceColor = Provider.of<FontSpace>(context, listen: true)
//        .tapMidFontSpace ? Color(0xFF1C8AEC) : Color(0xFFF6F6F6);
//    Color _tapSmallSpaceColor = Provider.of<FontSpace>(context, listen: true)
//        .tapSmallFontSpace ? Color(0xFF1C8AEC) : Color(0xFFF6F6F6);

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: Screen.height / 2,
            color: Color(0xFF292929),
            child: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "模式",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        isOnTapButton(
                          title: "护眼模式",
                        ),
                        isOnTapButton(
                          title: "夜间模式",
                        )
                      ],
                    )),
                Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "亮度",
                          style:
                              TextStyle(color: Color(0xFFCCCCCC), fontSize: 20),
                        ),
//                        _SettingMenuScreenBrightItem()
                      ],
                    )),
                _SettingMenuScreenBrightItem(),
                Container(
                  margin: EdgeInsets.only(left: 10, top: 15),
                  child: Row(
                    children: <Widget>[
                      Text("字号",
                          style: TextStyle(color: Colors.grey, fontSize: 16)),
                      SetFontSizeButton(
                        title: "A-",
                        isTapFinish:
                            Provider.of<fontSize>(context, listen: true)
                                .tapToMin,
                        onTap: () {
                          Provider.of<fontSize>(context, listen: false)
                              .downFontSize();
                        },
                      ),
                      SetFontSizeButton(
                          title: "A+",
                          isTapFinish:
                              Provider.of<fontSize>(context, listen: true)
                                  .tapToMax,
                          onTap: () {
                            Provider.of<fontSize>(context, listen: false)
                                .addFontSize();
                          }),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, top: 15),
                  child: Row(
                    children: <Widget>[
                      Text("背景",
                          style: TextStyle(color: Colors.grey, fontSize: 16)),
                      CircleSelectButton(
                        onTap: () {
                          Provider.of<BackgroundColor>(context, listen: false)
                              .isTapButton("white");
                        },
                        innerWidget: Container(
                          color: Color(0xFFF6F6F6),
                        ),
                        isSelected: true,
                        selectedColor: Color(0xFFDED9C5),
                      ),
                      CircleSelectButton(
                        onTap: () {
                          Provider.of<BackgroundColor>(context, listen: false)
                              .isTapButton("yellow");
                        },
                        selectedColor: Color(0xFFDED9C5),
                        innerWidget: Container(
                          color: Color(0xFFDED9C5),
                        ),
                        isSelected: true,
                      ),
                      CircleSelectButton(
                        onTap: () {
                          Provider.of<BackgroundColor>(context, listen: false)
                              .isTapButton("green");
                        },
                        selectedColor: Color(0xFFDED9C5),
                        innerWidget: Container(
                          color: Color(0xFFD7E3CB),
                        ),
                        isSelected: true,
                      ),
                      CircleSelectButton(
                        onTap: () {
                          Provider.of<BackgroundColor>(context, listen: false)
                              .isTapButton("blue");
                        },
                        selectedColor: Color(0xFFDED9C5),
                        innerWidget: Container(
                          color: Color(0xFFCCD8E4),
                        ),
                        isSelected: true,
                      ),
                      CircleSelectButton(
                        onTap: () {
                          Provider.of<BackgroundColor>(context, listen: false)
                              .isTapButton("black");
                        },
                        selectedColor: Color(0xFFDED9C5),
                        innerWidget: Container(
                          color: Color(0xFF161616),
                        ),
                        isSelected: true,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, top: 15),
                  child: Row(
                    children: <Widget>[
                      Text("行距",
                          style: TextStyle(color: Colors.grey, fontSize: 16)),
                      CircleSelectButton(
                        onTap: () {
                          Provider.of<FontSpace>(context, listen: false)
                              .setLargeFontSpace();
                        },
                        isSelected:
                            Provider.of<FontSpace>(context, listen: true)
                                .tapLargeFontSpace,
                        innerWidget: Image.asset("img/font_space_large.png",
                            color: Provider.of<FontSpace>(context, listen: true)
                                    .tapLargeFontSpace
                                ? Color(0xFF1C8AEC)
                                : Color(0xFFF6F6F6)),
                        selectedColor:
                            Provider.of<FontSpace>(context, listen: true)
                                    .tapLargeFontSpace
                                ? Color(0xFF1C8AEC)
                                : Color(0xFFF6F6F6),
                      ),
                      CircleSelectButton(
                        onTap: () {
                          Provider.of<FontSpace>(context, listen: false)
                              .setMidFontSpace();
                        },
                        isSelected:
                            Provider.of<FontSpace>(context, listen: true)
                                .tapMidFontSpace,
                        innerWidget: Image.asset("img/font_space_large.png",
                            color: Provider.of<FontSpace>(context, listen: true)
                                    .tapMidFontSpace
                                ? Color(0xFF1C8AEC)
                                : Color(0xFFF6F6F6)),
                        selectedColor:
                            Provider.of<FontSpace>(context, listen: true)
                                    .tapMidFontSpace
                                ? Color(0xFF1C8AEC)
                                : Color(0xFFF6F6F6),
                      ),
                      CircleSelectButton(
                        onTap: () {
                          Provider.of<FontSpace>(context, listen: false)
                              .setSmallFontSpace();
                        },
                        isSelected:
                            Provider.of<FontSpace>(context, listen: true)
                                .tapSmallFontSpace,
                        innerWidget: Image.asset("img/font_space_large.png",
                            color: Provider.of<FontSpace>(context, listen: true)
                                    .tapSmallFontSpace
                                ? Color(0xFF1C8AEC)
                                : Color(0xFFF6F6F6)),
                        selectedColor:
                            Provider.of<FontSpace>(context, listen: true)
                                    .tapSmallFontSpace
                                ? Color(0xFF1C8AEC)
                                : Color(0xFFF6F6F6),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  buildBottomItem(String title, String icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7),
      child: Column(
        children: <Widget>[
          Image.asset(
            icon,
            color: SQColor.white,
          ),
          SizedBox(height: 5),
          Text(title,
              style:
                  TextStyle(fontSize: fixedFontSize(12), color: SQColor.white)),
        ],
      ),
    );
  }

  DrawLayout() {
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
                  onTap: () {
                    setState(() {
//                          this.widget.isReversed = !this.widget.isReversed;
                      this.widget.index =
                          this.widget.chapters.length - 1 - this.widget.index;
                      this.widget.chapters =
                          this.widget.chapters.reversed.toList();
                    });
                  },
                  child: Text("正序"),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: this.widget.chapters.length,
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

  Widget itemView(int index) {
    return Container(
      child: Text(widget.chapters[index].title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        key: widget._scaffoldKey,
        drawer: DrawLayout(),
        drawerEnableOpenDragGesture: false,
        body: Stack(
          children: <Widget>[
            GestureDetector(
              onTapDown: (_) {
                hide();
              },
              child: Container(color: Colors.transparent),
            ),
            buildTopView(context),
            buildBottomView(),
          ],
        ));
  }
}

class _SettingMenuScreenBrightItem extends StatefulWidget {
  @override
  __SettingMenuScreenBrightItemState createState() =>
      __SettingMenuScreenBrightItemState();
}

class __SettingMenuScreenBrightItemState
    extends State<_SettingMenuScreenBrightItem> {
  /// 因为不同机型上有不同的max brightness值，比如说小米cc9 上亮度最大值是超过255的，不是标准的谷歌标准，所以这块采用默认0.2，然后用户设置保存到数据库中，每回打开的时候设置一遍用户数据
  double _currentScreenBrightness = 0.2;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
//      width: double.infinity,
//      width: double.infinity,
      height: 70,
      child: Row(
        children: <Widget>[
          Padding(
            child: Icon(
              Icons.brightness_low,
              color: Colors.grey,
              size: 24,
            ),
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          ),
          Expanded(
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    valueIndicatorColor: Color(0xFFFFFFFF),
                    inactiveTrackColor: Color(0xFF808080),
                    activeTrackColor: Color(0xFFFFFFFF),
                    activeTickMarkColor: Colors.transparent,
                    inactiveTickMarkColor: Colors.transparent,
                    trackHeight: 2.5,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
                  ),
                  child: Slider(
                    activeColor: Color(0xFFFFFFFF),
                    inactiveColor: Color(0xFF808080),
                    value: _currentScreenBrightness == null
                        ? 0
                        : _currentScreenBrightness,
                    onChanged: (value) {
                      setState(() {
                        _currentScreenBrightness = value;
                        lightScreen.Screen.setBrightness(value);
//                    NovelConfigManager().setUserBrightnessConfig(value);
                      });
                    },
                  ),
                )),
            flex: 1,
          ),
          Padding(
            child: Icon(
              Icons.brightness_high,
              color: Colors.grey,
              size: 24,
            ),
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          ),
        ],
      ),
    );
  }
}

/// 设置字体大小按钮
Widget setFontSizeButton(context) {
  /// 按钮内容文字
  String title;

  /// 是否已点击到最大值
  bool isTapToMax;

  return GestureDetector(
    onTap: () {
      Provider.of<fontSize>(context, listen: false).addFontSize();
    },
    child: Container(
      alignment: Alignment.center,
      width: 100,
      height: 35,
      decoration: BoxDecoration(
        color: Color(0xFF4F4F4F),
        borderRadius: BorderRadius.all(Radius.circular(34)),
      ),
      child: Text("A+"),
    ),
  );
}

/// 设置字体大小按钮
Widget setFontSizeButton1(context) {
  /// 按钮内容文字
  String title;

  /// 是否已点击到最大值
  bool isTapToMax;

  return GestureDetector(
    onTap: () {
      Provider.of<fontSize>(context, listen: false).downFontSize();
    },
    child: Container(
      alignment: Alignment.center,
      width: 100,
      height: 35,
      decoration: BoxDecoration(
        color: Color(0xFF4F4F4F),
        borderRadius: BorderRadius.all(Radius.circular(34)),
      ),
      child: Text("A+"),
    ),
  );
}

/// 封装一个是否点击的按钮
class isOnTapButton extends StatefulWidget {
  final String title;

  const isOnTapButton({Key key, this.title}) : super(key: key);

  @override
  _isOnTapButtonState createState() => _isOnTapButtonState();
}

class _isOnTapButtonState extends State<isOnTapButton> {
  bool isTap = false;

  var onColor = Color(0xFF1C8AEC);
  var offColor = Color(0xFF8F8F8F);
  Color tapColor = Color(0xFF1C8AEC);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isTap) {
            isTap = false;
          } else {
            isTap = true;
          }
          Provider.of<NightChange>(context, listen: false).isTapButton(isTap);
          Provider.of<NightChange>(context, listen: false)
              .tapChangeTextColor(isTap);
        });
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
        decoration: BoxDecoration(
          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
          borderRadius: BorderRadius.all(Radius.circular(30.5)),
          //设置四周边框
          border: new Border.all(
              width: 1, color: isTap ? Color(0xFF1C8AEC) : Color(0xFF8F8F8F)),
        ),
        alignment: Alignment.center,
        child: Text(
          widget.title,
          style: TextStyle(
              color: isTap ? Color(0xFF1C8AEC) : Color(0xFF8F8F8F),
              fontSize: 15),
        ),
      ),
    );
  }
}

/// 右上角弹出菜单
Widget onPopMenu() {
  return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
            new PopupMenuItem<String>(
                value: 'value01', child: new Text('Item One')),
            new PopupMenuItem<String>(
                value: 'value02', child: new Text('Item Two')),
            new PopupMenuItem<String>(
                value: 'value03', child: new Text('Item Three')),
            new PopupMenuItem<String>(
                value: 'value04', child: new Text('I am Item Four'))
          ]);
}
