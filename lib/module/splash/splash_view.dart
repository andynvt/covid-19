import 'package:covid/module/module.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'splash_model.dart';

ChangeNotifierProvider<SplashModel> createSplash() {
  return ChangeNotifierProvider(
    create: (_) => SplashModel(),
    child: _SplashView(),
  );
}

class _SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<_SplashView> {

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 200), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => createMain()),
      );
    });
    return Container(
      color: Colors.amberAccent,
    );
  }
}
