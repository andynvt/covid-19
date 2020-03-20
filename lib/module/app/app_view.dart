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
        home: createSplash(),
      );
    });
  }
}
