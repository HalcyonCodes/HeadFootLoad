import 'package:flutter/material.dart';
import '../../config/index.dart';
import '../../utils/enum_status.dart';

class StatusWidget extends AnimatedWidget {
  final AnimationController controller;
  final Animation<double> animation;
  final String text;
  final Status status;

  const StatusWidget(
      {Key? key,
      required this.text,
      required this.controller,
      required this.animation,
      required this.status})
      : super(key: key, listenable: controller);

  @override
  Widget build(BuildContext context) {
    Matrix4? m4 = Matrix4.translationValues(0, animation.value, 0);
    return Transform(
        transform: m4,
        child: Visibility(
          visible: true, //animation.isCompleted?false:true,
          child: Container(
              height: 39,
              //padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 24),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [KShadow.shadow],
                color: KColor.containColor,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: KFont.loadStatuStyle,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  //加载中
                  if (status == Status.statusHeadLoading ||
                      status == Status.statusFootLoading)
                    SizedBox(
                      child: CircularProgressIndicator(
                        color: KColor.primaryColor,
                        //value: 1.1,
                      ),
                      width: 14,
                      height: 14,
                    ),

                  //加载完成
                  if (status == Status.statusIdel ||
                      status == Status.statusFootLoadCompleted)
                    Container(
                      height: 14,
                      width: 14,
                      color: Colors.green,
                    ),
                  //加载失败
                  if (status == Status.statusFootLoadFaild ||
                      status == Status.statusHeadLoadFaild)
                    Container(
                      height: 14,
                      width: 14,
                      color: Colors.red,
                    ),
                ],
              )),
        ));
  }
}
