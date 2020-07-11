import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:shuqi/public.dart';
import 'package:shuqi/reader/fontSpace_provider.dart';
import 'package:shuqi/reader/reader_scene.dart';
import 'package:screen/screen.dart' as lightScreen;
import 'package:provider/provider.dart';
import 'fontSize_provider.dart';

class ReaderMenu extends StatefulWidget {
  final List<Chapter> chapters;
  final int articleIndex;

  final VoidCallback onTap;
  final VoidCallback onPreviousArticle;
  final VoidCallback onNextArticle;
  final void Function(Chapter chapter) onToggleChapter;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ReaderMenu(
      {this.chapters,
      this.articleIndex,
      this.onTap,
      this.onPreviousArticle,
      this.onNextArticle,
      this.onToggleChapter});

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

//  openDrawer() {
//    animationController.reverse();
//    Timer(Duration(milliseconds: 200), () {
//      this.widget.onTap();
//    });
//    setState(() {
//      isTipVisible = false;
//    });
//  }

//  Future openDrawerTime()async{
//    await widget._scaffoldKey.currentState.openDrawer();
//  }

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
            Container(
              width: 44,
              child: Icon(Icons.more_vert, color: SQColor.white),
            ),
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
            animationController.reverse();
            SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

            widget._scaffoldKey.currentState.openDrawer();
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

  void showBottomDialog() {
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
                          style:
                              TextStyle(color: Color(0xFFCCCCCC), fontSize: 20),
                        ),
                        isOnTapButton()
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
                SettingFontSize(),
                SettingFontSpace()
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

class DrawLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(child: Text('drawer'));
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
              child: Slider(
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
            ),
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

/// 设置字体大小
class SettingFontSize extends StatefulWidget {
  @override
  _SettingFontSizeState createState() => _SettingFontSizeState();
}

class _SettingFontSizeState extends State<SettingFontSize> {
  double _textSizeValue = 18;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "字号",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          SizedBox(
            width: 14,
          ),
          Image.asset(
            "images/icon_content_font_small.png",
            color: Colors.white,
            width: 28,
            height: 18,
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                valueIndicatorColor: Color(0xFF33C3A5),
                inactiveTrackColor: Colors.white,
                activeTrackColor: Color(0xFF33C3A5),
                activeTickMarkColor: Colors.transparent,
                inactiveTickMarkColor: Colors.transparent,
                trackHeight: 2.5,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
              ),
              child: Slider(
                value: _textSizeValue,
                label: "字号：${_textSizeValue}",
                divisions: 20,
                min: 10,
                max: 30,
                onChanged: (double value) {
                  setState(() {
                    _textSizeValue = value;
                    Provider.of<fontSize>(context, listen: false)
                        .setFontSize(_textSizeValue);
                  });
                },
                onChangeEnd: (value) {
//                  _spSetTextSizeValue(value);
                },
              ),
            ),
          ),
          Image.asset(
            "images/icon_content_font_big.png",
            color: Colors.white,
            width: 28,
            height: 18,
          ),
        ],
      ),
    );
  }
}

/// 设置行间距
class SettingFontSpace extends StatefulWidget {
  @override
  _SettingFontSpaceState createState() => _SettingFontSpaceState();
}

class _SettingFontSpaceState extends State<SettingFontSpace> {
  double _spaceValue = 1.8;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          "间距",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
        SizedBox(
          width: 14,
        ),
        Image.asset(
          "images/icon_content_space_big.png",
          color: Colors.white,
          width: 28,
          height: 18,
        ),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              valueIndicatorColor: Color(0xFF33C3A5),
              inactiveTrackColor: Colors.white,
              activeTrackColor: Color(0xFF33C3A5),
              activeTickMarkColor: Colors.transparent,
              inactiveTickMarkColor: Colors.transparent,
              trackHeight: 2.5,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: _spaceValue,
              label: "字间距：$_spaceValue",
              min: 1.0,
              divisions: 20,
              max: 3.0,
              onChanged: (double value) {
                setState(() {
                  _spaceValue = value;
                  Provider.of<FontSpace>(context, listen: false)
                      .setFontSpace(_spaceValue);
                });
              },
              onChangeEnd: (value) {
//                _spSetSpaceValue(value);
              },
            ),
          ),
        ),
        Image.asset(
          "images/icon_content_space_small.png",
          color: Colors.white,
          width: 28,
          height: 18,
        ),
      ],
    );
  }
}

/// 封装一个是否点击的按钮

class isOnTapButton extends StatefulWidget {
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
          "护眼模式",
          style: TextStyle(
              color: isTap ? Color(0xFF1C8AEC) : Color(0xFF8F8F8F),
              fontSize: 15),
        ),
      ),
    );
  }
}
