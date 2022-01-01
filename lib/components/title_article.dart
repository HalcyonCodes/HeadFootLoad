//import '../utils/page_util.dart';
import 'package:head_foot_load/config/index.dart';

import '../viewModel/view_model.dart';
import 'package:flutter/material.dart';
import './countTitle/count_title_article.dart';
import './searchBar/bar_search.dart';
import './headFootLoad/head_foot_load.dart';
import '../utils/load_util.dart';

class ArticleTitle extends StatelessWidget {
  final HeadFootLoadViewModel viewModel;
  final double width;
  final LoadUtil? loadUtil;
  final String? searchString;
  late LoadUtil trueLoadUtil;

  //final PageUtil? pageUtil;

  ArticleTitle(
      {Key? key,
      required this.viewModel,
      required this.width,
      this.searchString,
      this.loadUtil,
      //this.pageUtil
      })
      : super(key: key){
        trueLoadUtil = loadUtil??LoadUtil();
      }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      color: KColor.backGroundColor,
      width: width,
      height: MediaQuery.of(context).size.height,//调整高度
      margin: const EdgeInsets.only(left: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 24,
          ),
          SearchBar(
            searchInitString: '请输入',
            searchString: searchString,
            viewModel: viewModel,
            loadUtil: trueLoadUtil,
          ),
          const SizedBox(
            height: 24,
          ),
          ArticleTitleCount(
            page: viewModel.maxPage,
            count: viewModel.maxItem,
            loadUtil: trueLoadUtil,
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: HeadFootLoad(
            //pageUtil: pageUtil,
            loadFootEnable: true,
            loadHeadEnable: true,
            width: width,
            viewModel: viewModel,
            loadUtil: trueLoadUtil,
          ))
        ],
      ),
    );
  }
}
