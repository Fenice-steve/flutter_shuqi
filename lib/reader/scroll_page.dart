import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shuqi/app/request.dart';
import 'package:shuqi/model/article.dart';
import 'package:shuqi/model/chapter.dart';
import 'package:shuqi/reader/article_provider.dart';
import 'package:shuqi/reader/reader_config.dart';
import 'package:shuqi/reader/reader_menu.dart';
import 'package:shuqi/reader/reader_page_agent.dart';
import 'package:shuqi/reader/reader_scroll_view.dart';
import 'package:shuqi/reader/reader_utils.dart';
import 'package:shuqi/reader/reader_view.dart';
import 'package:shuqi/utility/screen.dart';


enum PageJumpType { stay, firstPage, lastPage }

/// 上下翻页
class ScrollPageFlip extends StatefulWidget {

  final int articleId;

  const ScrollPageFlip({Key key, this.articleId}) : super(key: key);


  @override
  _ScrollPageFlipState createState() => _ScrollPageFlipState();
}

class _ScrollPageFlipState extends State<ScrollPageFlip> {
  int pageIndex = 0;

  static bool isMenuVisiable = false;
  double topSafeHeight = 0;


  Article preArticle;
  Article currentArticle;
  Article nextArticle;

  List<Chapter> chapters = [];

  @override
  void initState() {
    super.initState();

    setup();
  }


  /// 阅读页面
  Widget buildScrollPageView(BuildContext context) {
//    if (currentArticle == null) {
//      return Container();
//    }
//
//    int itemCount = (preArticle != null ? preArticle.pageCount : 0) +
//        currentArticle.pageCount +
//        (nextArticle != null ? nextArticle.pageCount : 0);

    var page = (preArticle != null ? preArticle.pageCount : 0);
    var article;
    if (page >= this.currentArticle.pageCount) {
      // 到达下一章了
      article = nextArticle;
      page = 0;
    } else if (page < 0) {
      // 到达上一章了
      article = preArticle;
      page = preArticle.pageCount - 1;
    } else {
      article = this.currentArticle;
    }

    return GestureDetector(
        onTapUp: (TapUpDetails details) {
          onTap(details.globalPosition);
        },
        child: ReaderScrollView(
            article: article, page: page,   topSafeHeight: topSafeHeight),
      );

//      ListView.builder(
//      physics: BouncingScrollPhysics(),
//      controller: pageController,
//      itemCount: itemCount,
//      itemBuilder: buildPage,
//      onPageChanged: onPageChanged,
//    );

  }

  onTap(Offset position) async {
    double xRate = position.dx / Screen.width;
    if (xRate > 0.33 && xRate < 0.66) {
//      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top, SystemUiOverlay.bottom]);
      SystemChrome.setEnabledSystemUIOverlays([]);
      setState(() {
        isMenuVisiable = true;
      });
    }
  }


  Future<Article> fetchArticle(int articleId) async {
    var article = await ArticleProvider.fetchArticle(articleId);
    var contentHeight = Screen.height -
        topSafeHeight -
        ReaderUtils.topOffset -
        Screen.bottomSafeHeight -
        ReaderUtils.bottomOffset -
        20;
    var contentWidth = Screen.width - 15 - 10;
    article.pageOffsets = ReaderPageAgent.getPageOffsets(article.content,
        contentHeight, contentWidth, ReaderConfig.instance.fontSize);

    return article;
  }

  resetContent(int articleId, PageJumpType jumpType) async {
    currentArticle = await fetchArticle(articleId);
    if (currentArticle.preArticleId > 0) {
      preArticle = await fetchArticle(currentArticle.preArticleId);
    } else {
      preArticle = null;
    }
    if (currentArticle.nextArticleId > 0) {
      nextArticle = await fetchArticle(currentArticle.nextArticleId);
    } else {
      nextArticle = null;
    }
    if (jumpType == PageJumpType.firstPage) {
      pageIndex = 0;
    } else if (jumpType == PageJumpType.lastPage) {
      pageIndex = currentArticle.pageCount - 1;
    }
//    if (jumpType != PageJumpType.stay) {
//      pageController.jumpToPage(
//
//
//          (preArticle != null ? preArticle.pageCount : 0) + pageIndex);
//    }

    setState(() {});
  }

  void setup() async {
    await SystemChrome.setEnabledSystemUIOverlays([]);
//    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    // 不延迟的话，安卓获取到的topSafeHeight是错的。
    await Future.delayed(const Duration(milliseconds: 200), () {});
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    topSafeHeight = Screen.topSafeHeight;

    List<dynamic> chaptersResponse = await Request.get(action: 'catalog');
    chaptersResponse.forEach((data) {
      chapters.add(Chapter.fromJson(data));
    });

    await resetContent(this.widget.articleId, PageJumpType.stay);
  }


  /// 上下菜单
  buildMenu() {
    if (!isMenuVisiable) {
      return Container();
    }
    return ReaderMenu(
      chapters: chapters,
      articleIndex: currentArticle.index,
      onTap: hideMenu,
      onPreviousArticle: () {
        resetContent(currentArticle.preArticleId, PageJumpType.firstPage);
      },
      onNextArticle: () {
        resetContent(currentArticle.nextArticleId, PageJumpType.firstPage);
      },
      onToggleChapter: (Chapter chapter) {
        resetContent(chapter.id, PageJumpType.firstPage);
      },
    );
  }

  hideMenu() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    setState(() {
      _ScrollPageFlipState.isMenuVisiable = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    if (currentArticle == null || chapters == null) {
      return Scaffold(
        body: Center(
          child: Container(
            child: Text("无数据"),
          ),
        ),
      );
    }

    return Scaffold(
      body: AnnotatedRegion(
          value: SystemUiOverlayStyle.dark,
          child: Stack(
            children: <Widget>[
              Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: Image.asset('img/read_bg.png', fit: BoxFit.cover)),
              buildScrollPageView(context),
              buildMenu(),
            ],
          )),
    );
  }
}
