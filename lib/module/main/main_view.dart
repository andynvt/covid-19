import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main_model.dart';

ChangeNotifierProvider<MainModel> createMain() {
  return ChangeNotifierProvider(
    create: (_) => MainModel(),
    child: _MainView(),
  );
}

class _MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<_MainView> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MainModel>(context);
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
