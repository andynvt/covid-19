import 'package:covid/core/language/language.dart';
import 'package:covid/resource/resource.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:covid/module/root/root_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          Language.shared().delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('vi', 'VN'),
          const Locale('zh', 'CN'),
          const Locale('hi', 'IN'),
          const Locale('es', 'ES'),
          const Locale('fr', 'FR'),
          const Locale('ru', 'RU'),
          const Locale('pt', 'PT'),
        ],
        locale: root.currentLocale,
        home: createMain(),
      );
    });
  }
}
