import 'package:covid/model/model.dart';
import 'package:covid/resource/resource.dart';
import 'package:covid/service/service.dart';
import 'package:covid/util/string_util.dart';
import 'package:covid/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'news_detail_model.dart';

ChangeNotifierProvider<NewsDetailModel> createNewsDetail(NewsInfo info) {
  assert(info != null);
  return ChangeNotifierProvider(
    create: (_) => NewsDetailModel(info),
    child: _NewsDetailView(),
  );
}

class _NewsDetailView extends StatefulWidget {
  @override
  _NewsDetailViewState createState() => _NewsDetailViewState();
}

class _NewsDetailViewState extends State<_NewsDetailView> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<NewsDetailModel>(context);
    return Scaffold(
      backgroundColor: Cl.white,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TTNetworkImage(
                    width: double.infinity,
                    boxFit: BoxFit.contain,
                    imageUrl: model.info.urlToImage,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Chip(
                              label: Text(
                                model.info.source ?? '',
                                style: TextStyle(color: Cl.white),
                              ),
                              backgroundColor: Cl.brownGrey,
                            ),
                            Spacer(),
                            Icon(Icons.access_time, size: 18),
                            SizedBox(width: 8),
                            Text(TTString.shared()
                                .formatDate(model.info.publishedAt) ?? ''),
                          ],
                        ),
                        Text(model.info.title, style: Style.ts_total_18),
                        SizedBox(height: 12),
                        Row(
                          children: <Widget>[
                            Icon(Icons.edit, size: 17, color: Cl.blackThree),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                model.info.author ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Style.ts5,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Divider(),
                        SizedBox(height: 8),
                        Text(
                          model.info.description ?? '',
                          style: Style.ts7,
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: FlatButton(
                            onPressed: () {
                              LaunchURL.launch(model.info.url);
                            },
                            color: Cl.tealish,
                            child: Text(
                              'View More',
                              style: Style.ts_21_white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 60,
              child: RawMaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.keyboard_backspace, color: Cl.white),
                shape: CircleBorder(),
                elevation: 2,
                fillColor: Cl.black.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
