import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:shuqi/public.dart';
import 'package:shuqi/reader/reader_menu_chapter.dart';

import 'article_provider.dart';
import 'reader_utils.dart';
import 'reader_config.dart';

import 'reader_page_agent.dart';
import 'reader_menu.dart';
import 'reader_view.dart';

enum PageJumpType { stay, firstPage, lastPage }

class ReaderScene extends StatefulWidget {
  final int articleId;

  ReaderScene({this.articleId});

  @override
  ReaderSceneState createState() => ReaderSceneState();
}

class ReaderSceneState extends State<ReaderScene> with RouteAware {
  int pageIndex = 0;
  static bool isMenuVisiable = false;

  bool isMenuChapterVisible = false;

  PageController pageController = PageController(keepPage: false);

  bool isLoading = false;

  double topSafeHeight = 0;

  Article preArticle;
  Article currentArticle;
  Article nextArticle;

  List<Chapter> chapters = [];

  @override
  void initState() {
    super.initState();
    pageController.addListener(onScroll);

    setup();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPop() {
//    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    pageController.dispose();
    routeObserver.unsubscribe(this);
    super.dispose();
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
    if (jumpType != PageJumpType.stay) {
      pageController.jumpToPage(
          (preArticle != null ? preArticle.pageCount : 0) + pageIndex);
    }

    setState(() {});
  }

  onScroll() {
    var page = pageController.offset / Screen.width;

    var nextArtilePage = currentArticle.pageCount +
        (preArticle != null ? preArticle.pageCount : 0);
    if (page >= nextArtilePage) {
      print('到达下个章节了');

      preArticle = currentArticle;
      currentArticle = nextArticle;
      nextArticle = null;
      pageIndex = 0;
      pageController.jumpToPage(preArticle.pageCount);
      fetchNextArticle(currentArticle.nextArticleId);
      setState(() {});
    }
    if (preArticle != null && page <= preArticle.pageCount - 1) {
      print('到达上个章节了');

      nextArticle = currentArticle;
      currentArticle = preArticle;
      preArticle = null;
      pageIndex = currentArticle.pageCount - 1;
      pageController.jumpToPage(currentArticle.pageCount - 1);
      fetchPreviousArticle(currentArticle.preArticleId);
      setState(() {});
    }
  }

  fetchPreviousArticle(int articleId) async {
    if (preArticle != null || isLoading || articleId == 0) {
      return;
    }
    isLoading = true;
    preArticle = await fetchArticle(articleId);
    pageController.jumpToPage(preArticle.pageCount + pageIndex);
    isLoading = false;
    setState(() {});
  }

  fetchNextArticle(int articleId) async {
    if (nextArticle != null || isLoading || articleId == 0) {
      return;
    }
    isLoading = true;
    nextArticle = await fetchArticle(articleId);
    isLoading = false;
    setState(() {});
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

  /// 判断点击区域
  onTap(Offset position) async {
    double xRate = position.dx / Screen.width;
    if (xRate > 0.33 && xRate < 0.66) {
//      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top, SystemUiOverlay.bottom]);
      /// 恢复状态栏
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
      setState(() {
        isMenuVisiable = true;
      });
    } else if (xRate >= 0.66) {
      nextPage();
    } else {
      previousPage();
    }
  }

  /// 改变页数
  onPageChanged(int index) {
    var page = index - (preArticle != null ? preArticle.pageCount : 0);
    if (page < currentArticle.pageCount && page >= 0) {
      setState(() {
        pageIndex = page;
      });
    }
  }

  /// 上一页
  previousPage() {
    if (pageIndex == 0 && currentArticle.preArticleId == 0) {
      Toast.show('已经是第一页了');
      return;
    }
    pageController.previousPage(
        duration: Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  /// 下一页
  nextPage() {
    if (pageIndex >= currentArticle.pageCount - 1 &&
        currentArticle.nextArticleId == 0) {
      Toast.show('已经是最后一页了');
      return;
    }
    pageController.nextPage(
        duration: Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  /// PageView的每一页内容
  Widget buildPage(BuildContext context, int index) {
    var page = index - (preArticle != null ? preArticle.pageCount : 0);
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
      child: ReaderView(
          article: article, page: page, topSafeHeight: topSafeHeight),
    );
  }

  /// 阅读页
  buildPageView() {
    if (currentArticle == null) {
      return Container();
    }

    int itemCount = (preArticle != null ? preArticle.pageCount : 0) +
        currentArticle.pageCount +
        (nextArticle != null ? nextArticle.pageCount : 0);
    return PageView.builder(
      physics: BouncingScrollPhysics(),
      controller: pageController,
      itemCount: itemCount,
      itemBuilder: buildPage,
      onPageChanged: onPageChanged,
    );

  }

  /// 上下浮层菜单
  buildMenu() {
    if (!isMenuVisiable) {
      return Container();
    }
    return ReaderMenu(
      onTypeTap: (int type){
        switch(type){
          case 1:
            setState(() {
              isMenuVisiable=false;
              isMenuChapterVisible=true;
            });
        }

      },
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

  /// 隐藏菜单
  hideMenu() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    setState(() {
      ReaderSceneState.isMenuVisiable = false;
    });
  }


  Widget buildMenuChapter() {
    if(!isMenuChapterVisible) {
      return Container();
    }

    return ReaderMenuChapter((int type, int value){
      if(type == 1) {
        setState(() {
          isMenuChapterVisible = !isMenuChapterVisible;
        });
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentArticle == null || chapters == null) {
      return Scaffold();
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
              buildPageView(),
              buildMenu(),
              buildMenuChapter()
            ],
          )),
    );
  }
}
