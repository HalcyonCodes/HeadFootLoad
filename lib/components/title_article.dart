import '../viewModel/view_model.dart';
import 'package:flutter/material.dart';
import './countTitle/count_title_article.dart';
import './searchBar/bar_search.dart';
import './headFootLoad/head_foot_load.dart';
import '../utils/load_util.dart';

class ArticleTitle extends StatelessWidget {
  final HeadFootLoadViewModel viewModel;
  final double width;
  final LoadUtil loadUtil = LoadUtil();
  final String? searchString;

  ArticleTitle(
      {Key? key,
      required this.viewModel,
      required this.width,
      this.searchString})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            loadUtil: loadUtil,
          ),
          const SizedBox(
            height: 24,
          ),
          ArticleTitleCount(
            page: viewModel.maxPage,
            count: viewModel.maxItem,
            loadUtil: loadUtil,
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
              child: HeadFootLoad(
            loadFootEnable: true,
            loadHeadEnable: true,
            width: width,
            viewModel: viewModel,
            loadUtil: loadUtil,
          ))
        ],
      ),
    );
  }
}
