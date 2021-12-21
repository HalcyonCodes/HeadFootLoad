# head_foot_load

一个Web端的加载列表

- 可以把数据加载到头部
- 可以把数据加载到尾部
- 可以加载完成之后得到不规则item在列表中的位置，并把item所在的数据库里的页数显示在上面
  

## Getting Started

- 构造视图模型
  - import 'package:head_foot_load/viewModel/view_model.dart';
  - 继承 HeadFootLoadViewModel
  - 在 refresh() loadMore() loadLast() search() 里发起http请求，把得到的数据存放到 ‘titleCards’ 属性里

- 加载元件
  - import 'package:head_foot_load/head_foot_load.dart'; 
  - return ArticleTitle(viewModel: viewModel, width: yourWidth)

## 需要完善的地方

lib/components/loadStatus/widget_status.dart 那里需要完善加载图标