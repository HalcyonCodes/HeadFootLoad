import 'package:flutter/material.dart';
import 'enum_status.dart';

class LoadUtil {
  int _page = 0;
  int get page => _page;
  void setPage(int page) {
    _page = page;
  }

  Function()? _refreshCount;
  Function()? get refreshCount => _refreshCount;
  void setRefreshCount(Function()? fun) {
    _refreshCount = fun;
  }

  Function()? _refreshLoadStatus;
  Function()? get refreshLoadStatus => _refreshLoadStatus;
  void setRefrshLoadStatus(Function()? fun) {
    _refreshLoadStatus = fun;
  }

  Function()? _refreshHeadFootLoad;
  Function()? get refreshHeadFootLoad => _refreshHeadFootLoad;
  void setRefrshHeadFootLoad(Function()? fun) {
    _refreshHeadFootLoad = fun;
  }

  AnimationController? _controller;
  AnimationController get controller => _controller!;
  void setController(AnimationController? ctrl) {
    _controller = ctrl;
  }

  Animation<double>? _animation;
  Animation<double> get dAnimation => _animation!;
  void setAnimation(Animation<double>? animate) {
    _animation = animate;
  }

  Status _status = Status.statusIdel;
  Status get status => _status;
  void setStatus(Status st) {
    _status = st;
  }

  String? _statusText;
  String get statusText => _statusText!;

  void setStatuText() {
    switch (status) {
      case Status.statusHeadLoading:
        _statusText = '加载中';
        break;
      case Status.statusHeadLoading2:
        _statusText = '加载中';
        break;
      case Status.statusFootLoading:
        _statusText = '加载中';
        break;
      case Status.statusIdel:
        _statusText = '加载完成';
        break;
      case Status.statusHeadLoadFaild:
        _statusText = '加载失败';
        break;
      case Status.statusFootLoadFaild:
        _statusText = '加载失败';
        break;
      case Status.statusFootLoadCompleted:
        _statusText = '加载完成';
        break;
      case Status.statusMath:
        _statusText = '加载完成';
        break;
      case Status.statusHeadLoadCompleted:
        _statusText = '加载完成';
        break;
    }
  }

  void startAnimate() {
    controller.forward();
  }

  ScrollController? _scrollController;
  ScrollController get scrollController => _scrollController!;
  void setScrollController(ScrollController t) {
    _scrollController = t;
  }

  ScrollPhysics? _physics;
  ScrollPhysics get physics => _physics!;
  void setPhysics(int type) {
    if (type == 0) {
      _physics = const ClampingScrollPhysics();
    }
    if (type == 1) {
      _physics = const NeverScrollableScrollPhysics();
    }
  }
}
