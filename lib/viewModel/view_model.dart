import 'package:dio/dio.dart';

//--------注意！：这里需要替换为自己的item的元件数据--------
class ArticleTitleCardViewModel {
  String id;
  String category;
  String date;
  String title;
  String profiles;
  int page;
  List<String> tags;
  ArticleTitleCardViewModel(
      {required this.id,
      required this.page,
      required this.category,
      required this.date,
      required this.title,
      required this.profiles,
      required this.tags});
}

//
abstract class HeadFootLoadViewModel {
  /*late String code;
  late String message;*/
  late String maxPage; //通过http得到数据库中的item有多少页
  late String maxItem;  //通过http得到数据库中的item一共有多少个
  /*late bool loadHeadEnable;
  late bool loadFootEnable;
  */
  late int currentArticleId; //以某Id为准进行查询，根据skincount忽略skincount * 每页条数
  late List<ArticleTitleCardViewModel> titleCards; //请求完数据后存放item 数据的列表，加载元件的时候就用它的数据加载;
  int lastSkinCount = 0; //这里指向后skin多少页
  int headSkinCount = 0; //这里指向前skin多少页

  Response? response;

  //刷新数据
  refresh(int? id);

  //加载更多
  loadMore(int? id);

  //加载上一页
  loadLast(int? id);

  //搜索方法
  search(String? string);
}
