import 'package:flutter/material.dart';
import './widget_status.dart';
import '../../utils/load_util.dart';

class StatusTicker extends StatefulWidget {
  final LoadUtil loadUtil;
  final double width;

  const StatusTicker({Key? key, required this.loadUtil, required this.width})
      : super(key: key);

  @override
  _StatusTricker createState() => _StatusTricker();
}

class _StatusTricker extends State<StatusTicker> with TickerProviderStateMixin {
  AnimationController? controller;

  Animation<double>? animation;

  void refershStatusWidget() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    animation = CurvedAnimation(parent: controller!, curve: Curves.easeInOut);
    animation = Tween(begin: 68.0, end: 0.0).animate(controller!);
    widget.loadUtil.setAnimation(animation);
    widget.loadUtil.setController(controller);
    widget.loadUtil.setRefrshLoadStatus(refershStatusWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 63,
      width: widget.width,
      child: Stack(
        children: [
          StatusWidget(
            animation: widget.loadUtil.dAnimation,
            controller: widget.loadUtil.controller,
            text: widget.loadUtil.statusText,
            status: widget.loadUtil.status,
          ),
        ],
      ),
    );
  }
}
