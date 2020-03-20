import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:covid/module/main/main_view.dart';
import 'package:covid/resource/resource.dart';
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
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  Widget build(BuildContext context) {
//    final model = Provider.of<SplashModel>(context);
    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => createMain()),
      );
    });
    return Container(
      color: Cl.pinkRed,
//      child: Image.asset(Id.bg_girl, fit: BoxFit.cover),
    );
  }
}
