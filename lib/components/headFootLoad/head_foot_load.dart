import 'dart:io';

import 'package:flutter/material.dart';

import '../loadStatus/ticker_status.dart';
import 'package:dio/dio.dart';
import '../../utils/enum_status.dart';
import '../../utils/load_util.dart';
import '../../viewModel/view_model.dart';
import '../listItem/card_title_article.dart';

class HeadFootLoad extends StatefulWidget {
  //final List<Widget> widgets;
  //final List<ArticleTitleCardViewModel> viewData;
  final HeadFootLoadViewModel viewModel;
  final LoadUtil loadUtil;
  final bool? loadHeadEnable;
  final bool? loadFootEnable;
  final double width;

  const HeadFootLoad({
    Key? key,
    //required this.viewModel,
    this.loadHeadEnable,
    this.loadFootEnable,
    required this.viewModel,
    required this.loadUtil,
    required this.width,
  }) : super(key: key);

  @override
  _HeadFootLoadState createState() => _HeadFootLoadState();
}

class _HeadFootLoadState extends State<HeadFootLoad> {
  ScrollController? controller;

  List<ArticleTitleCardViewModel> data = [];

  double widgetHeight = 0;

  List<Widget> widgets = [];

  Map<int, double> pageOffsetSheet = <int, double>{}; //存放页数和滚动条偏移位置

  List<GlobalKey> pageOffsetKeys = []; //存放列表widget所有key
  List<int> pageOffsetIndex = []; //存放哪个index开始page发生改变

  int currentPage = 0;

  bool isListView = false; //计算时需要先把列表转成singlechildscrollview，显示时转成listview

  double endOffsetTemp = 0; //用于判断页面所在位置减少provide刷新

  double lastScrollPx = 0; //获得最后一次滚动的坐标

  int startPage = 0; //用于显示从哪一页开始

  Response? response; //存放dio返回值

  double currentOffset = 0.0; //存放当前滚动条偏移用于初始化controller

  bool loadHeadEnable = true;

  bool loadFootEnable = true;

  int loadHeadCount = 1;

  bool isInPageStack = false;

  void refreshHeadFootLoad() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    //data = widget.viewData;
    //data.addAll(widget.viewModel.titleCards);
    widget.loadUtil.setRefrshHeadFootLoad(refreshHeadFootLoad);

    loadHeadEnable =
        widget.loadHeadEnable == null ? true : widget.loadHeadEnable!;
    loadFootEnable =
        widget.loadFootEnable == null ? true : widget.loadFootEnable!;

    data = widget.viewModel.titleCards;

    isListView = false;
    controller = ScrollController(initialScrollOffset: 2);
    //controller = ScrollController();
    //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
    //    .setScrollController(controller!);
    widget.loadUtil.setScrollController(controller!);

    //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
    //   .setPhysics(0);
    widget.loadUtil.setPhysics(0);

    //-currentPage = widget.viewData[0].page;
    currentPage = data[0].page;

    //Provider.of<ArticleTitleCountProvider>(context, listen: false)
    //   .setPage(currentPage);
    widget.loadUtil.setPage(currentPage);

    WidgetsBinding dinstance = WidgetsBinding.instance!;
    dinstance.addPostFrameCallback((timeStamp) async {
      //----test---
      pushPageOffset();
      //----test----

      //isListView = true;
      //添加监听
      scrollCtrlAddListener();

      //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
      // .setStatus(Status.statusIdel);
      widget.loadUtil.setStatus(Status.statusIdel);
      //Provider.of<ArticleTitleCountProvider>(context, listen: false).refresh();
      widget.loadUtil.refreshCount!();
      //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
      //   .refresh();
    });
  }

  /*@override
  void deactivate() {
    super.deactivate();
    isInPageStack = true;
    print('-----deactivate----');
  }*/

  void scrollCtrlAddListener() {
    //ScrollController sCtrl =
    //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
    //   .scrollController;
    ScrollController sCtrl = widget.loadUtil.scrollController;

    sCtrl.addListener(() async {
      //

      selectPage(sCtrl.position.pixels);

      if (sCtrl.position.pixels == sCtrl.position.minScrollExtent &&
          loadHeadEnable == true) {
        //ScrollController dCtrl =
        //   Provider.of<ArticleTitleStatusProvider>(context, listen: false)
        //       .scrollController;
        ScrollController dCtrl = widget.loadUtil.scrollController;
        currentOffset = dCtrl.position.pixels;
        await loadPre(widget.viewModel.currentArticleId);
      }

      if (sCtrl.position.pixels == sCtrl.position.maxScrollExtent &&
          loadFootEnable == true) {
        //ScrollController dCtrl =
        //   Provider.of<ArticleTitleStatusProvider>(context, listen: false)
        //       .scrollController;
        ScrollController dCtrl = widget.loadUtil.scrollController;
        currentOffset = dCtrl.position.pixels;
        await loadNext(widget.viewModel.currentArticleId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    pageOffsetKeys = [];
    //-int currentPage = data[0].page;
    //int currentPage = widget.viewModel.titleCards[0].page;
    int currentPage = data[0].page;

    startPage = currentPage;
    widgets = [];
    List<Widget> widgetTemp = [];
    pageOffsetIndex = [];

    //如果下拉加载上一页则在上方添加状态器
    if (widget.loadUtil.status == Status.statusHeadLoading ||
        widget.loadUtil.status == Status.statusHeadLoadCompleted ||
        widget.loadUtil.status == Status.statusHeadLoadFaild) {
      widgets.add(StatusTicker(
        width: widget.width,
        loadUtil: widget.loadUtil,
      ));
    }
    //data.lenght
    widgetTemp = List.generate(data.length, (index) {
      GlobalKey dkey = GlobalKey();
      //pageOffsetKeys.add(dkey);
      //判断是否换页
      if (currentPage == data[index].page) {
      } else {
        pageOffsetIndex.add(index);
        currentPage = data[index].page;
      }
      Widget card = SizedBox(
        child: ArticleTitleCard(
          key: dkey,
          category: data[index].category,
          date: data[index].date,
          title: data[index].title,
          profiles: data[index].profiles,
          tags: data[index].tags,
          id: data[index].id,
        ),
      );

      pageOffsetKeys.add(dkey);
      return card;
    });

    //如果上拉加载则在下方加载状态器
    if (widget.loadUtil.status == Status.statusFootLoading ||
        widget.loadUtil.status == Status.statusFootLoadCompleted ||
        widget.loadUtil.status == Status.statusFootLoadFaild) {
      widgetTemp.add(StatusTicker(
        width: widget.width,
        loadUtil: widget.loadUtil,
      ));
    }
    widgets.addAll(widgetTemp);

    return isListView
        ? ListView(
            physics: widget.loadUtil.physics,
            controller: widget.loadUtil.scrollController,
            //controller: controller,
            shrinkWrap: true,
            children: widgets)
        : SingleChildScrollView(
            physics: widget.loadUtil.physics,
            controller: widget.loadUtil.scrollController,
            //controller:controller,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widgets,
            ),
          );
  }

  //将有变化的元素的key页数和value坐标存入pageOffsetSheet
  void pushPageOffset() {
    int i = 0;
    double height = 0;
    ScrollController ctrl = widget.loadUtil.scrollController;
    //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
    //    .scrollController;
    pageOffsetSheet.clear();
    for (GlobalKey e in pageOffsetKeys) {
      if (pageOffsetIndex.contains(i)) {
        pageOffsetSheet.putIfAbsent(
          //--data[i].page,
          data[i].page,
          () => ctrl.position.maxScrollExtent - height <= 0
              ? ctrl.position.maxScrollExtent + 10000
              : ctrl.position.maxScrollExtent -
                  (ctrl.position.maxScrollExtent - height),
        );
      }
      height = e.currentContext!.size!.height + height;
      //var rb = e.currentContext!.findRenderObject();
      //height = rb.size.height + height;
      //height = rb.semanticBounds.size.height + height;
      //height = rb!.semanticBounds.height;
      i++;
    }
  }

  //判断并刷新页面计数
  void selectPage(double px) {
    //向下
    if (lastScrollPx - px < 0) {
      for (var e in pageOffsetSheet.keys) {
        if (px >= pageOffsetSheet[e]! && px >= endOffsetTemp) {
          //Provider.of<ArticleTitleCountProvider>(context, listen: false)
          //   .setPage(e);
          widget.loadUtil.setPage(e);
          //Provider.of<ArticleTitleCountProvider>(context, listen: false)
          //   .refresh();
          widget.loadUtil.refreshCount!();
          if (pageOffsetSheet[e + 1] != null) {
            endOffsetTemp = pageOffsetSheet[e + 1]!;
          } else {
            endOffsetTemp = controller!.position.maxScrollExtent + 1000;
          }
        }
      }
      lastScrollPx = px;
    }

    //向上
    if (lastScrollPx - px > 0) {
      for (var e in pageOffsetSheet.keys) {
        if (px <= pageOffsetSheet[e]! && px <= endOffsetTemp) {
          if (e - 1 <= startPage) {
            //Provider.of<ArticleTitleCountProvider>(context, listen: false)
            //    .setPage(startPage);
            widget.loadUtil.setPage(startPage);
            if (pageOffsetSheet[e - 1] != null) {
              endOffsetTemp = pageOffsetSheet[e - 1]!;
            } else {
              endOffsetTemp = 0;
            }
            //Provider.of<ArticleTitleCountProvider>(context, listen: false)
            //   .refresh();
            widget.loadUtil.refreshCount!();
            break;
          } else {
            //Provider.of<ArticleTitleCountProvider>(context, listen: false)
            //   .setPage(e - 1);
            widget.loadUtil.setPage(e - 1);
            if (pageOffsetSheet[e - 1] != null) {
              endOffsetTemp = pageOffsetSheet[e - 1]!;
            } else {
              endOffsetTemp = 0;
            }
            //Provider.of<ArticleTitleCountProvider>(context, listen: false)
            //   .refresh();
            widget.loadUtil.refreshCount!();
            break;
          }
        }
      }
      lastScrollPx = px;
    }
  }

  //加载上一页
  Future<void> loadPre(int articleId) async {
    //print(Provider.of<ArticleTitleStatusProvider>(context,listen: false).scrollController.position.maxScrollExtent);

    double maxScrollPosition = 0;
    double currentMaxSctrPosition = 0;
    Status currentStatus =
        //Provider.of<ArticleTitleStatusProvider>(context, listen: false).status;
        widget.loadUtil.status;
    currentMaxSctrPosition =
        //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
        //   .scrollController
        //   .position
        //  .maxScrollExtent;
        widget.loadUtil.scrollController.position.maxScrollExtent;
    if (currentStatus == Status.statusIdel) {
      isListView = true;
      //0.禁止滚动
      //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
      //   .setPhysics(1);
      widget.loadUtil.setPhysics(1);
      //1.更新状态
      //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
      //    .setStatus(Status.statusHeadLoading);
      widget.loadUtil.setStatus(Status.statusHeadLoading);
      //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
      //   .setStatuText();
      widget.loadUtil.setStatuText();

      await Future.delayed(const Duration(seconds: 0), () {
        //----test---
        controller = ScrollController(initialScrollOffset: 1);

        //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
        //   .setScrollController(controller!);
        widget.loadUtil.setScrollController(controller!);
        //----test----
      });

      //刷出加载提示器
      //Provider.of<ArticleTitleStatusProvider>(context, listen: false).refresh();
      widget.loadUtil.refreshLoadStatus!();
      WidgetsBinding instance = WidgetsBinding.instance!;
      instance.addPostFrameCallback((timeStamp) async {
        //2.配置controller和animated

        AnimationController aController = widget.loadUtil.controller;
        //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
        //   .controller;
        aController.reset();
        Animation<double> animation = widget.loadUtil.dAnimation;
        //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
        //    .dAnimation;
        animation = Tween(begin: -63.0, end: 0.0).animate(aController);

        //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
        //   .setAnimation(animation);
        widget.loadUtil.setAnimation(animation);
        //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
        //   .setController(aController);
        widget.loadUtil.setController(aController);
        //3.添加指示器并刷新组件
        //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
        //    .refresh(); //
        widget.loadUtil.refreshLoadStatus!();
        WidgetsBinding instance = WidgetsBinding.instance!;
        instance.addPostFrameCallback((timeStamp) async {
          ScrollController sCtrl = widget.loadUtil.scrollController;
          //   Provider.of<ArticleTitleStatusProvider>(context, listen: false)
          //       .scrollController;

          await Future.delayed(const Duration(seconds: 0), () {
            //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
            //   .startAnimate();
            widget.loadUtil.startAnimate();
          });

          //保存现场
          List<ArticleTitleCardViewModel> temp = [];
          temp.addAll(data);

          //4.请求数据
          response = null;
          await loadLast(articleId);
          data = temp;

          //等待请求结果
          int i = 0;
          while (i == 0) {
            if (aController.isCompleted) {
              i = 1;
            } else {
              await Future.delayed(const Duration(milliseconds: 50), () {});
            }
          }
          //response = null;//test

          //请求成功
          //5.加载配置动画效果
          if (response?.statusCode == HttpStatus.ok && response != null) {
            //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
            //    .setStatus(Status.statusHeadLoadCompleted);
            widget.loadUtil.setStatus(Status.statusHeadLoadCompleted);
            //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
            //   .setStatuText();
            widget.loadUtil.setStatuText();
            aController = widget.loadUtil.controller;
            //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
            //   .controller;
            aController.stop();
            aController.reset();
            animation = widget.loadUtil.dAnimation;
            //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
            //   .dAnimation;
            animation = Tween(begin: 0.0, end: -63.0).animate(aController);
            //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
            //   .setAnimation(animation);
            widget.loadUtil.setAnimation(animation);
            //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
            //    .setController(aController);
            widget.loadUtil.setController(aController);
            //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
            //   .refresh();
            widget.loadUtil.refreshLoadStatus!();
            WidgetsBinding instance = WidgetsBinding.instance!;
            instance.addPostFrameCallback((timeStamp) async {
              await Future.delayed(const Duration(seconds: 0), () {
                //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
                //   .startAnimate();
                widget.loadUtil.startAnimate();
              });
              //6.延时
              i = 0;
              while (i == 0) {
                if (response != null && aController.isCompleted) {
                  i = 1;
                } else {
                  await Future.delayed(const Duration(milliseconds: 50), () {});
                }
              }

              //进入计算模式
              //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
              //   .setStatus(Status.statusMath);
              widget.loadUtil.setStatus(Status.statusMath);
              //加载刷新数据
              data = widget.viewModel.titleCards;

              //切换成singleChildScrollview
              isListView = false;
              controller = ScrollController(initialScrollOffset: 0);
              //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
              //   .setScrollController(controller!);
              widget.loadUtil.setScrollController(controller!);
              //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
              //   .refresh();
              widget.loadUtil.refreshLoadStatus!();
              WidgetsBinding instance = WidgetsBinding.instance!;
              instance.addPostFrameCallback((timeStamp) async {
                //await Future.delayed(const Duration(seconds: 2), () {});
                pushPageOffset(); //dddddd
                //dddddd
                //maxScrollPosition = Provider.of<ArticleTitleStatusProvider>(
                //       context,
                //       listen: false)
                //  .scrollController
                //  .position
                //  .maxScrollExtent;
                maxScrollPosition =
                    widget.loadUtil.scrollController.position.maxScrollExtent;

                //double px = Provider.of<ArticleTitleStatusProvider>(context,
                //        listen: false)
                //   .scrollController
                //  .position
                //  .pixels;

                double px = widget.loadUtil.scrollController.position.pixels;

                lastScrollPx = px + 1;
                endOffsetTemp = 0;
                selectPage(px);
                isListView = true;
                controller = ScrollController(initialScrollOffset: 0);
                currentOffset = maxScrollPosition - currentMaxSctrPosition - 63;

                //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
                //    .setScrollController(controller!);
                //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
                //    .setPhysics(0);
                //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
                //   .refresh();
                widget.loadUtil.setScrollController(controller!);
                widget.loadUtil.setPhysics(0);
                widget.loadUtil.refreshLoadStatus!();

                WidgetsBinding instance = WidgetsBinding.instance!;
                instance.addPostFrameCallback((timeStamp) {
                  //controller = Provider.of<ArticleTitleStatusProvider>(context,
                  //        listen: false)
                  //   .scrollController;
                  controller = widget.loadUtil.scrollController;
                  controller!.animateTo(currentOffset,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.linear);
                  scrollCtrlAddListener();
                  //Provider.of<ArticleTitleStatusProvider>(context,
                  //       listen: false)
                  //  .setStatus(Status.statusIdel);
                  widget.loadUtil.setStatus(Status.statusIdel);
                });
              });
            });
          } else {
            //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
            //    .setStatus(Status.statusHeadLoadFaild);
            widget.loadUtil.setStatus(Status.statusHeadLoadFaild);
            //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
            //   .setStatuText();
            widget.loadUtil.setStatuText();
            //aController =
            //    Provider.of<ArticleTitleStatusProvider>(context, listen: false)
            //       .controller;
            aController = widget.loadUtil.controller;
            aController.stop();
            aController.reset();
            animation = widget.loadUtil.dAnimation;
            //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
            //    .dAnimation;
            animation = Tween(begin: 0.0, end: -63.0).animate(aController);
            //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
            //   .setAnimation(animation);
            widget.loadUtil.setAnimation(animation);
            //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
            //   .setController(aController);
            widget.loadUtil.setController(aController);
            //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
            //   .refresh();
            widget.loadUtil.refreshLoadStatus!();
            WidgetsBinding instance = WidgetsBinding.instance!;
            instance.addPostFrameCallback((timeStamp) async {
              await Future.delayed(const Duration(seconds: 0), () {
                //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
                //    .startAnimate();
                widget.loadUtil.startAnimate();
              });

              i = 0;
              while (i == 0) {
                if (aController.isCompleted) {
                  i = 1;
                } else {
                  await Future.delayed(const Duration(milliseconds: 50), () {});
                }
              }

              //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
              //   .setStatus(Status.statusIdel);
              //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
              //    .setPhysics(0);
              //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
              //    .refresh();
              widget.loadUtil.setStatus(Status.statusIdel);
              widget.loadUtil.setPhysics(0);
              widget.loadUtil.refreshLoadStatus!();

              WidgetsBinding instance = WidgetsBinding.instance!;
              instance.addPostFrameCallback((timeStamp) async {
                ScrollController sCtrl = widget.loadUtil.scrollController;
                //Provider.of<ArticleTitleStatusProvider>(context,
                //      listen: false)
                //  .scrollController;
                await Future.delayed(const Duration(seconds: 0), () async {
                  sCtrl.jumpTo(4.0);
                });
                scrollCtrlAddListener();
              });
            });
          }
        });
      });
    }
  }

  //加载下一页
  Future<void> loadNext(int articleId) async {
    Status currentStatus = widget.loadUtil.status;
    // Provider.of<ArticleTitleStatusProvider>(context, listen: false).status;
    if (currentStatus == Status.statusIdel) {
      isListView = true;
      //0.禁止滚动
      //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
      //    .setPhysics(1);
      widget.loadUtil.setPhysics(1);
      //1.更新状态
      //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
      //    .setStatus(Status.statusFootLoading);
      //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
      //    .setStatuText();
      widget.loadUtil.setStatus(Status.statusFootLoading);
      widget.loadUtil.setStatuText();
      await Future.delayed(const Duration(seconds: 0), () {
        //----test---
        controller = ScrollController(initialScrollOffset: currentOffset);
        //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
        //   .setScrollController(controller!);
        widget.loadUtil.setScrollController(controller!);
        //----test----
      });
      //刷出加载提示器
      //Provider.of<ArticleTitleStatusProvider>(context, listen: false).refresh();
      widget.loadUtil.refreshLoadStatus!();

      WidgetsBinding instance = WidgetsBinding.instance!;
      instance.addPostFrameCallback((timeStamp) async {
        //2.配置controller和animated

        AnimationController aController = widget.loadUtil.controller;
        //    Provider.of<ArticleTitleStatusProvider>(context, listen: false)
        //       .controller;

        aController.reset();
        Animation<double> animation = widget.loadUtil.dAnimation;
        //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
        //    .dAnimation;
        animation = Tween(begin: 63.0, end: 0.0).animate(aController);

        //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
        //   .setAnimation(animation);
        widget.loadUtil.setAnimation(animation);
        //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
        //   .setController(aController);
        widget.loadUtil.setController(aController);
        //3.添加指示器并刷新组件
        //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
        //    .refresh(); //
        widget.loadUtil.refreshLoadStatus!();
        WidgetsBinding instance = WidgetsBinding.instance!;
        instance.addPostFrameCallback((timeStamp) async {
          ScrollController sCtrl = widget.loadUtil.scrollController;
          //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
          //   .scrollController;
          await Future.delayed(const Duration(seconds: 0), () async {
            await sCtrl.animateTo(sCtrl.position.maxScrollExtent,
                duration: const Duration(milliseconds: 100),
                curve: Curves.linear);
            currentOffset = sCtrl.position.pixels;
          });

          await Future.delayed(const Duration(seconds: 0), () {
            //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
            //   .startAnimate();
            widget.loadUtil.startAnimate();
          });

          //保存现场
          List<ArticleTitleCardViewModel> temp = [];
          temp.addAll(data);

          //4.请求数据
          response = null;
          await loadMore(articleId);
          data = temp;
          //等待请求结果
          int i = 0;
          while (i == 0) {
            if (aController.isCompleted) {
              i = 1;
            } else {
              await Future.delayed(const Duration(milliseconds: 50), () {});
            }
          }

          //请求成功
          //5.加载配置动画效果
          if (response?.statusCode == HttpStatus.ok && response != null) {
            //data = [];
            //int a;

            //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
            //   .setStatus(Status.statusFootLoadCompleted);
            //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
            //   .setStatuText();
            //aController =
            //    Provider.of<ArticleTitleStatusProvider>(context, listen: false)
            //       .controller;
            widget.loadUtil.setStatus(Status.statusFootLoadCompleted);
            widget.loadUtil.setStatuText();
            aController = widget.loadUtil.controller;
            aController.stop();
            aController.reset();
            animation = widget.loadUtil.dAnimation;
            //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
            //   .dAnimation;
            animation = Tween(begin: 0.0, end: 63.0).animate(aController);
            //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
            //    .setAnimation(animation);
            //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
            //    .setController(aController);
            //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
            //    .refresh();
            widget.loadUtil.setAnimation(animation);
            widget.loadUtil.setController(aController);
            widget.loadUtil.refreshLoadStatus!();

            WidgetsBinding instance = WidgetsBinding.instance!;
            instance.addPostFrameCallback((timeStamp) async {
              await Future.delayed(const Duration(seconds: 0), () {
                //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
                //    .startAnimate();
                widget.loadUtil.startAnimate();
              });
              //6.延时
              i = 0;
              while (i == 0) {
                if (response != null && aController.isCompleted) {
                  i = 1;
                } else {
                  await Future.delayed(const Duration(milliseconds: 50), () {});
                }
              }

              //进入计算模式
              //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
              //    .setStatus(Status.statusMath);
              widget.loadUtil.setStatus(Status.statusMath);
              //加载刷新数据
              data = widget.viewModel.titleCards;

              //切换成singleChildScrollview
              isListView = false;
              controller = ScrollController(initialScrollOffset: currentOffset);
              //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
              //    .setScrollController(controller!);
              widget.loadUtil.setScrollController(controller!);
              //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
              //    .refresh();
              widget.loadUtil.refreshLoadStatus;
              WidgetsBinding instance = WidgetsBinding.instance!;
              instance.addPostFrameCallback((timeStamp) async {
                pushPageOffset();
                //double px = Provider.of<ArticleTitleStatusProvider>(context,
                //        listen: false)
                //    .scrollController
                //    .position
                //    .pixels;
                double px = widget.loadUtil.scrollController.position.pixels;
                lastScrollPx = px - 1;
                endOffsetTemp = 0;
                selectPage(px);
                isListView = true;
                controller =
                    ScrollController(initialScrollOffset: currentOffset);
                //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
                //    .setScrollController(controller!);
                //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
                //    .setPhysics(0);
                //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
                //    .refresh();
                widget.loadUtil.setScrollController(controller!);
                widget.loadUtil.setPhysics(0);
                widget.loadUtil.refreshLoadStatus!();

                scrollCtrlAddListener();
                //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
                //    .setStatus(Status.statusIdel);
                widget.loadUtil.setStatus(Status.statusIdel);
              });
            });
          } else {
            //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
            //    .setStatus(Status.statusFootLoadFaild);
            widget.loadUtil.setStatus(Status.statusFootLoadCompleted);
            //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
            //    .setStatuText();
            widget.loadUtil.setStatuText();
            //aController =
            //    Provider.of<ArticleTitleStatusProvider>(context, listen: false)
            //       .controller;
            aController = widget.loadUtil.controller;
            aController.stop();
            aController.reset();
            //animation =
            //   Provider.of<ArticleTitleStatusProvider>(context, listen: false)
            //       .dAnimation;
            animation = widget.loadUtil.dAnimation;
            animation = Tween(begin: 0.0, end: 63.0).animate(aController);
            //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
            //    .setAnimation(animation);
            widget.loadUtil.setAnimation(animation);
            //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
            //    .setController(aController);
            widget.loadUtil.setController(aController);
            //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
            //    .refresh();
            widget.loadUtil.refreshLoadStatus;
            WidgetsBinding instance = WidgetsBinding.instance!;
            instance.addPostFrameCallback((timeStamp) async {
              await Future.delayed(const Duration(seconds: 0), () {
                //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
                //    .startAnimate();
                widget.loadUtil.startAnimate();
              });

              i = 0;
              while (i == 0) {
                if (aController.isCompleted) {
                  i = 1;
                } else {
                  await Future.delayed(const Duration(milliseconds: 50), () {});
                }
              }

              //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
              //   .setStatus(Status.statusIdel);
              widget.loadUtil.setStatus(Status.statusIdel);
              //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
              //    .setPhysics(0);
              widget.loadUtil.setPhysics(0);
              //Provider.of<ArticleTitleStatusProvider>(context, listen: false)
              //    .refresh();
              widget.loadUtil.refreshLoadStatus!();
              WidgetsBinding instance = WidgetsBinding.instance!;
              instance.addPostFrameCallback((timeStamp) async {
                ScrollController sCtrl = widget.loadUtil.scrollController;
                //Provider.of<ArticleTitleStatusProvider>(context,
                //       listen: false)
                //    .scrollController;
                await Future.delayed(const Duration(seconds: 0), () async {
                  sCtrl.jumpTo(sCtrl.position.maxScrollExtent - 4);
                });
                scrollCtrlAddListener();
              });
            });
          }
        });
      });
    }
  }

  //加载
  Future<void> loadMore(int articleId) async {
    /*await Future.delayed(const Duration(milliseconds: 300), () async {
      Dio().get('http://localhost:4040/').then((value) => response = value);
    });*/
    try {
      await Future.delayed(const Duration(milliseconds: 350), () async {
        await widget.viewModel.loadMore(articleId);
        response = widget.viewModel.response;
      });
    } catch (e) {
      await Future.delayed(const Duration(milliseconds: 350), () async {
        response = null;
      });
    }
  }

  //加载上一页
  Future<void> loadLast(int articleId) async {
    /*await Future.delayed(const Duration(milliseconds: 300), () async {
      Dio().get('http://localhost:4040/').then((value) => response = value);
    });*/
    try {
      await Future.delayed(const Duration(milliseconds: 350), () async {
        await widget.viewModel.loadLast(articleId);
        response = widget.viewModel.response;
      });
    } catch (e) {
      await Future.delayed(const Duration(milliseconds: 350), () async {
        response = null;
      });
    }
  }
}
