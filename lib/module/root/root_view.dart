import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:covid/resource/resource.dart';

import 'root_model.dart';

ChangeNotifierProvider<RootModel> createRoot(WidgetBuilder builder) {
  assert(builder != null);
  return ChangeNotifierProvider(
    create: (_) => RootModel(),
    child: _RootView(builder),
  );
}


class _RootView extends StatefulWidget {
  final WidgetBuilder builder;

  _RootView(this.builder);

  @override
  _RootViewState createState() => _RootViewState();
}

class _RootViewState extends State<_RootView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(
        children: <Widget>[
          widget.builder(context),
          _renderLoading(context),
        ],
      ),
    );
  }

  Widget _renderLoading(BuildContext context) {
    final model = Provider.of<RootModel>(context);
    return StreamBuilder<bool>(
      stream: model.isLoading.distinct(),
      initialData: false,
      builder: (_, snapshot) {
        if (snapshot.data) {
          return Container(
            color: Colors.black38,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Cl.pinkRed),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}