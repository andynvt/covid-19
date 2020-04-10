import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'faq_model.dart';

ChangeNotifierProvider<FaqModel> createFaq() {
  return ChangeNotifierProvider(
    create: (_) => FaqModel(),
    child: _FaqView(),
  );
}

class _FaqView extends StatefulWidget {
  @override
  _FaqViewState createState() => _FaqViewState();
}

class _FaqViewState extends State<_FaqView> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<FaqModel>(context);
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
