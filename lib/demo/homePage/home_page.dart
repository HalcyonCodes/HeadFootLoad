

import 'package:flutter/material.dart';
import 'model/viewModel/article_title_card_viewmodel.dart';
import '../../config/index.dart';
import 'package:head_foot_load/head_foot_load.dart';

class HomePage extends StatelessWidget {
  final ArticleTitleViewModel viewModel = ArticleTitleViewModel();
  final int? articleId;
  final String? searchString;
  final initIndex = 0;

  HomePage({Key? key, this.articleId, this.searchString}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 231, 208, 1.0),
      body: Container(
          constraints: const BoxConstraints(),
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1920,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FutureBuilder<int>(
                      future: viewModel.refresh(5),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return const Text('none');

                          case ConnectionState.waiting:
                            //后期需要添加等待页
                            return const Text('waiting');

                          case ConnectionState.active:
                            return const Text('active');

                          case ConnectionState.done:
                            if (snapshot.hasError) {
                              //请求失败，添加从新刷新控件
                              return const Text('请求失败，放置重新刷新按钮');
                            } else {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ArticleTitle(viewModel: viewModel, width: 482),
                                ],
                              );
                            }

                          default:
                            return const Text('Unkonwn state');
                        }
                      })
                ],
              ),
            ),
          )),
    );
  }
}
