

class ArticleModel{

  late String code;
  late String message;
  late ArticleModelData data;

  ArticleModel();

  ArticleModel.fromJson(Map<String, dynamic> json){
    code = json['code'];
    message = json['message'];
    data = ArticleModelData();
    if(json['data'] != null){
       data = ArticleModelData.fromJson(json['data']);
    }


  }

}



class ArticleModelData{

  late String articleId;
  late String content;
  
  ArticleModelData();

  ArticleModelData.fromJson(Map<String, dynamic> json){
    articleId = json['articleId'];
    content = json['content'];
  }

}