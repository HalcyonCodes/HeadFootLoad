import 'dart:html';

import '../data/article_title_data.dart' as titleData;
import 'package:head_foot_load/viewModel/view_model.dart';

import 'package:dio/dio.dart';
import '../fromJsonModel/article_title_model.dart';



class ArticleTitleViewModel extends HeadFootLoadViewModel{
  late String code;
  late String message;
  //late String maxPage;
  //late String maxItem;
  late bool loadHeadEnable;
  late bool loadFootEnable;
  //late int currentArticleId;
  
  
  //List<ArticleTitleCardViewModel> titleCards = [];
  //Response? response;

  //int lastSkinCount = 0; //这里指向后skin多少页
  //int headSkinCount = 0;  //这里指向最skin多少页

  ArticleTitleViewModel();

  //刷新数据
  @override
  Future<int>? refresh(int? articleId,) async {
    
    titleCards = [];
    response = null;
    lastSkinCount = 0;
    headSkinCount = 0;
    //1.dio请求
    //根据articleId查询后n个条数据
    //await Future.delayed(const Duration(milliseconds: 0), () async {
      //await Dio().get('http://localhost:4040/').then((value) => response = value);
      //response = await Dio().get('http://localhost:4040/');
   //});
   //1-1如果articleId为null, 则发起查找最后一条的请求
   //1-2如果articleId不为null，则发起按articleId查找的请求；
   response = await Dio().get('http://localhost:4040/');
   lastSkinCount++;
    //请求成功
    if (response!.statusCode == HttpStatus.ok) {
      //2.假装有了数据加载数据
      //var data = response.data;
      var data = titleData.data;
      //3.解析数据
      ArticleTitleModel articleModel = ArticleTitleModel.fromJson(data);
      //4.绑定数据
      code = articleModel.code;
      message = articleModel.message;
      loadFootEnable =
          articleModel.data.loadFootEnable == 'true' ? true : false;
      loadHeadEnable =
          articleModel.data.loadHeadEnable == 'true' ? true : false;
      maxPage = articleModel.data.maxPage;
      maxItem = articleModel.data.maxItem;
      currentArticleId = int.tryParse(articleModel.data.currentArticleId)!;

      for (var e in articleModel.data.titleList) {
        ArticleTitleCardViewModel card = ArticleTitleCardViewModel(
          id: e.articleId,
          category: e.category,
          date: e.date,
          page: int.tryParse(e.page)!,
          //page: page,
          title: e.title,
          profiles: e.profiles,
          tags: e.tags,
        );
        titleCards.add(card);
      }
      return response!.statusCode!;
    } else {
      return response!.statusCode!;
    }
  }


  //加载更多
  @override
  Future<int> loadMore(int? articleId) async {
    //int page = lastPage + 1; //用于请求
    //lastPage = page;
    response = null;
    //1.根据page发起dio请求
    //await Future.delayed(const Duration(milliseconds: 0), () async {
     // Dio().get('http://localhost:4040/').then((value) => response = value);
    //});
    response = await Dio().get('http://localhost:4040/');
    lastSkinCount++;
    //请求成功
    if (response!.statusCode == HttpStatus.ok) {
      //2.假装有了数据加载数据
      //var data = response.data;
      var data = titleData.data;
      //3.解析数据
      ArticleTitleModel articleModel = ArticleTitleModel.fromJson(data);
      //4.绑定数据
      code = articleModel.code;
      message = articleModel.message;
      loadFootEnable =
          articleModel.data.loadFootEnable == 'true' ? true : false;
      loadHeadEnable =
          articleModel.data.loadHeadEnable == 'true' ? true : false;
      maxPage = articleModel.data.maxPage;
      maxItem = articleModel.data.maxItem;
      currentArticleId = int.tryParse(articleModel.data.currentArticleId)!;

      for (var e in articleModel.data.titleList) {
        ArticleTitleCardViewModel card = ArticleTitleCardViewModel(
          id: e.articleId,
          category: e.category,
          date: e.date,
          page: int.tryParse(e.page)!,
          //page:page,
          title: e.title,
          profiles: e.profiles,
          tags: e.tags,
        );
        titleCards.add(card);
      }
      return response!.statusCode!;
    } else {
      return response!.statusCode!;
    }
  }

  //加载上一页
  @override
   Future<int> loadLast(int? articleId) async {
     
     response = null;
    //1.根据Article发起dio请求, 根据headSkinCount省略条数
    //await Future.delayed(const Duration(milliseconds: 0), () async {
    //  Dio().get('http://localhost:4040/').then((value) => response = value);
    //});
    response = await Dio().get('http://localhost:4040/');
    //请求成功
    headSkinCount++;

    if (response!.statusCode == HttpStatus.ok) {
      //2.模拟加载数据
      //var data = response.data;
      var data = titleData.data;
      //3.解析数据
      ArticleTitleModel articleModel = ArticleTitleModel.fromJson(data);
      //4.绑定数据
      code = articleModel.code;
      message = articleModel.message;
      loadFootEnable =
          articleModel.data.loadFootEnable == 'true' ? true : false;
      loadHeadEnable =
          articleModel.data.loadHeadEnable == 'true' ? true : false;
      maxPage = articleModel.data.maxPage;
      maxItem = articleModel.data.maxItem;
      currentArticleId = int.tryParse(articleModel.data.currentArticleId)!;

      List<ArticleTitleCardViewModel> cardTemp = [];
      for (var e in articleModel.data.titleList) {
        ArticleTitleCardViewModel card = ArticleTitleCardViewModel(
          id: e.articleId,
          category: e.category,
          date: e.date,
          page: int.tryParse(e.page)!,
          title: e.title,
          profiles: e.profiles,
          tags: e.tags,
        );
        cardTemp.add(card);
      }
      titleCards.insertAll(0, cardTemp);
      return response!.statusCode!;
    } else {
      return response!.statusCode!;
    }
  }

  @override
  search(String? string) {
    //根据输入框发起http请求向数据库找数据
    
  }

  @override
  itemClick(String id) {
    // TODO: implement itemClick
    throw UnimplementedError();
  }

}
