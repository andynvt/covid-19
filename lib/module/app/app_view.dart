import 'package:covid/resource/resource.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:covid/module/root/root_model.dart';
import '../module.dart';

Widget createApp() {
  return _AppView();
}

class _AppView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return createRoot((context) {
      final root = Provider.of<RootModel>(context);
      return MaterialApp(
        theme: ThemeData(
          fontFamily: 'Roboto',
          cursorColor: Cl.tealish,
        ),
//        localizationsDelegates: [
//          GlobalMaterialLocalizations.delegate,
//          GlobalWidgetsLocalizations.delegate,
//          GlobalCupertinoLocalizations.delegate,
//          DefaultCupertinoLocalizations.delegate,
//          Language.shared().delegate,
//        ],
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('ko', 'KR'),
        ],
        locale: root.currentLocale,
        home: createMain(),
      );
    });
  }
}
