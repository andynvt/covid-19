import 'package:covid/model/language_enum.dart';
import 'package:covid/resource/resource.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'change_language_model.dart';

ChangeNotifierProvider<ChangeLanguageModel> createChangeLanguage() {
  return ChangeNotifierProvider(
    create: (_) => ChangeLanguageModel(),
    child: _ChangeLanguageView(),
  );
}

class _ChangeLanguageView extends StatefulWidget {
  @override
  _ChangeLanguageViewState createState() => _ChangeLanguageViewState();
}

class _ChangeLanguageViewState extends State<_ChangeLanguageView> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ChangeLanguageModel>(context);
    return Scaffold(
      backgroundColor: Cl.white,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Cl.white,
        elevation: 1,
        leading: FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          padding: EdgeInsets.zero,
          child: Icon(Icons.keyboard_backspace),
          shape: CircleBorder(),
        ),
        title: Text('Select language', style: Style.ts2),
      ),
      body: SafeArea(
        child: ListView.separated(
          itemCount: LanguageEnum.values.length,
          itemBuilder: (_, index) {
            return _renderLanguageItem(LanguageEnum.values[index]);
          },
          separatorBuilder: (_, __) {
            return Container(height: 1, color: Cl.cloudyBlue18);
          },
        ),
      ),
    );
  }

  Widget _renderLanguageItem(LanguageEnum lang) {
    return ListTile(
      onTap: () {},
      title: Text(langToNative(lang), style: Style.ts_16_black),
      trailing: Icon(Icons.check_circle, color: Cl.tealish,),
    );
  }
}
