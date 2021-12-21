
import 'package:flutter/material.dart';
import '../../config/index.dart';
import '../../utils/load_util.dart';




class ArticleTitleCount extends StatefulWidget {

   final String page;
  final String count;
  final LoadUtil loadUtil;

  const ArticleTitleCount({ Key? key,required this.page,
    required this.count,required this.loadUtil}
  ) : super(key: key);

  @override
  _ArticleTitleCountState createState() => _ArticleTitleCountState();
}

class _ArticleTitleCountState extends State<ArticleTitleCount> {


  @override
  void initState() {
    super.initState();
    widget.loadUtil.setRefreshCount(refreshCount);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
   
          children: [
            Text('第 ', style: KFont.articleTitleCountStyle,),
            Text(widget.loadUtil.page.toString(),
              style: KFont.articleTitleCountStyle,
            ),
            Text(' / ', style: KFont.articleTitleCountStyle,),
            Text(widget.page, style: KFont.articleTitleCountStyle,),
            Text(' 页', style: KFont.articleTitleCountStyle,),
            const Expanded(child: SizedBox()),
            Text('共 ',style: KFont.articleTitleCountStyle,),
            Text(widget.count, style: KFont.articleTitleCountStyle,),
            Text(' 条', style: KFont.articleTitleCountStyle,),
          ],
        
        );
  }

  void refreshCount(){
    setState(() {
      
    });
  }
}