//import 'package:head_foot_load/utils/page_util.dart';
import '../../config/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../viewModel/view_model.dart';

class ArticleTitleCard extends StatelessWidget {
  final String category;
  final String date;
  final String title;
  final String profiles;
  final List<String> tags;
  final String id;
  //final PageUtil? pageUtil;
  final HeadFootLoadViewModel viewModel;

  const ArticleTitleCard({
    Key? key,
    required this.category,
    required this.date,
    required this.title,
    required this.profiles,
    required this.tags,
    required this.id,
    required this.viewModel
    //this.pageUtil

  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    List<Widget> tagTemps = List.generate(tags.length, (index) {
      return tag(tags[index]);
    });
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: KColor.containColor,
          boxShadow: [KShadow.shadow]),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onClick,
        child: Container(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    category,
                    style: KFont.articleTitleCardCategoryStyle,
                  ),
                  const Expanded(child: SizedBox()),
                  Text(
                    date,
                    style: KFont.articleTitleCardDateStyle,
                  )
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                title,
                style: KFont.articleTitleStyle,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                profiles,
                style: KFont.articleTitleCardProfilesStyle,
              ),
              const SizedBox(
                height: 22,
              ),
              Wrap(
                children: tagTemps,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget tag(String tag) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 16, bottom: 12),
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          height: 26,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: KColor.primaryColor,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 14,
                width: 14,
                child: SvgPicture.asset(
                  'svg/tag.svg',
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 6, bottom: 6),
                  child: Text(
                    tag,
                    style: KFont.articleTitleCardTagStyle,
                    strutStyle: const StrutStyle(
                      leading: 0,
                      height: 1.0,
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
  
  void onClick(){
    //pageUtil!.itemOnClick!(id);
    //viewModel.currentArticleId = int.tryParse(id)!;
    viewModel.itemClick(id);
  }

}
