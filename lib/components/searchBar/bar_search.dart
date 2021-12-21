import 'package:flutter/material.dart';
import '../../config/index.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../viewModel/view_model.dart';
import '../../utils/load_util.dart';

class SearchBar extends StatefulWidget {

   
  final String searchInitString;
  final String? searchString;
  //final Function(String)? commit;
  //final GlobalKey? dKey;
  //final double? leftMargin;
  //final double? rightMargin;
  final HeadFootLoadViewModel viewModel;
  final LoadUtil loadUtil;
  const SearchBar({ Key? key,required this.searchInitString, this.searchString, required this.viewModel, required this.loadUtil}) : super(key: key);
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {

  TextEditingController? controller;
  late String searchInitString;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text:widget.searchString);
    searchInitString = widget.searchInitString;
  }
  


  @override
  Widget build(BuildContext context) {
    return Container(
      //key: widget.dKey,
      //margin: EdgeInsets.only(left: widget.leftMargin == null?0:widget.leftMargin!,right: widget.rightMargin == null?0:widget.rightMargin!),
      height: 43,
      decoration: BoxDecoration(
        boxShadow: [KShadow.shadow],
        borderRadius: BorderRadius.circular(16),
        color: KColor.containColor
      ),
      padding: const EdgeInsets.only(left: 16,top: 9,bottom: 9,right: 12),
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           SizedBox(
            height: 19,
            width: 19,
            child: SvgPicture.asset(
              'svg/search.svg',
              height: 19,
              width: 19,
              color: Colors.black,
            )
          ),
          const SizedBox(width: 12,),
          Expanded(
            child: TextField(
                    controller: controller,
                    maxLines: 1,
                    style: KFont.searchBarStyle,
                    autofocus: false, //自动对焦
                    cursorColor: Colors.black, //光标颜色
                    cursorWidth: 2,
                    cursorHeight: 20,
                    
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(200)
                    ],
                    maxLength: null,
                    //onChanged: (text){},
                    onSubmitted: commit,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: searchInitString, 
                      contentPadding: EdgeInsets.zero, 
                      hintStyle: KFont.searchBarInitStyle,
                      isDense: true,
                      hintMaxLines: 1,
                      
                    ),
                  ),
          
          )
        ],
      ),
    );
  }
  void commit(String string) async{

       try {
      await Future.delayed(const Duration(milliseconds: 0), () async {
        widget.viewModel.search(string);
        widget.loadUtil.refreshHeadFootLoad!();
        //response = widget.viewModel.response;
      });
    } catch (e) {
      await Future.delayed(const Duration(milliseconds: 350), () async {
        //response = null;
        controller = TextEditingController();
        searchInitString = '加载失败, 请重试';
        setState(() {
          
        });
      });
    }


  }
}