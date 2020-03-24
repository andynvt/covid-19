import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:covid/module/main/main_view.dart';
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
//    final model = Provider.of<SplashModel>(context);
    Future.delayed(Duration(milliseconds: 100), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => createMain()),
      );
    });
    return Container(
      color: Colors.amberAccent,
//      child: Image.asset(Id.bg_girl, fit: BoxFit.cover),
    );
  }
}
