import 'package:flutter/material.dart';
import '../config/color.dart';

class KFont {
  //列表刷新指示器字体
  static TextStyle loadStatuStyle = const TextStyle(
    fontFamily: 'PingFangHK',
    fontSize: 14,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.none,
    height: 14 / 14,
  );

  //标题卡片顶部分类字体
  static TextStyle articleTitleCardCategoryStyle = const TextStyle(
    fontFamily: 'PingFangHK',
    fontSize: 12,
    color: Colors.black,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.none,
    height: 17 / 12,
  );

  //--标题卡片顶部日期字体
  static TextStyle articleTitleCardDateStyle = TextStyle(
    fontFamily: 'PingFangHK',
    fontSize: 12,
    color: KColor.greyTextColor,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.none,
    height: 17 / 12,
  );

  //--标题卡片标题字体
  static TextStyle articleTitleStyle = const TextStyle(
    fontFamily: 'PingFangHK',
    fontSize: 18,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.none,
    height: 25 / 18,
  );

  //--标题卡片简介字体
  static TextStyle articleTitleCardProfilesStyle = TextStyle(
    fontFamily: 'PingFangHK',
    fontSize: 14,
    color: KColor.greyTextColor,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.none,
    height: 20 / 14,
  );

  //--标题卡片标签字体
  static TextStyle articleTitleCardTagStyle = const TextStyle(
    fontFamily: 'PingFangHK',
    fontSize: 14,
    color: Colors.white,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.none,
    height: 14 / 14,
  );

  //--标题显示页数和数量的字体
  static TextStyle articleTitleCountStyle = const TextStyle(
    fontFamily: 'PingFangHK',
    fontSize: 12,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.none,
    height: 17 / 12,
  );

  //--搜索栏字体
  static TextStyle searchBarStyle = const TextStyle(
    fontFamily: 'PingFangHK',
    fontSize: 18,
    color: Colors.black,
    decoration: TextDecoration.none,
    height: 22 / 18,
  );

  //--搜索栏提示字体
  static TextStyle searchBarInitStyle = TextStyle(
    fontFamily: 'PingFangHK',
    fontSize: 18,
    color: KColor.greyTextColor,
    decoration: TextDecoration.none,
    height: 22 / 18,
  );
}
