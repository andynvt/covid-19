import 'package:covid/model/model.dart';
import 'package:flutter/material.dart';

import 'news_detail_logic.dart';

class NewsDetailModel extends ChangeNotifier {
  NewsDetailLogic _logic;
  NewsDetailLogic get logic => _logic;
  final NewsInfo info;

  NewsDetailModel(this.info) {
    _logic = NewsDetailLogic(this);
  }
}
