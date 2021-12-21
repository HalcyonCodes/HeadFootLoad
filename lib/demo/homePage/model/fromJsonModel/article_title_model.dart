class ArticleTitleModel {
  late String code;
  late String message;
  late ArticleTitleModelData data;

  ArticleTitleModel();

  ArticleTitleModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = ArticleTitleModelData();
    if (json['data'] != null) {
      data = ArticleTitleModelData.fromJson(json['data']);
    }
  }
}

class ArticleTitleModelData {
  late String maxPage;
  late String maxItem;
  late List<ArticleTitle> titleList;
  late String loadHeadEnable;
  late String loadFootEnable;
  late String currentArticleId;

  ArticleTitleModelData();

  ArticleTitleModelData.fromJson(Map<String, dynamic> json) {
    maxPage = json['maxPage'];
    maxItem = json['maxItem'];
    loadHeadEnable = json['loadHeadEnable'];
    loadFootEnable = json['loadFootEnable'];
    currentArticleId = json['currentArticleId'];

    if (json['titleList'] != null) {
      titleList = [];
      json['titleList'].forEach((e) {
        ArticleTitle article = ArticleTitle();
        article = ArticleTitle.fromJson(e);
        titleList.add(article);
      });
    }
  }
}

class ArticleTitle {
  late String articleId;
  late String page;
  late String date;
  late String category;
  late String title;
  late String profiles;
  late List<String> tags;

  ArticleTitle();

  ArticleTitle.fromJson(Map<String, dynamic> json) {
    articleId = json['articleId'];
    page = json['page'];
    date = json['date'];
    category = json['category'];
    title = json['title'];
    profiles = json['profiles'];
    tags = [];
    if (json['tags'] != null) {
        json['tags'].forEach((e) {
          tags.add(e);
        });
    }
  }
}
