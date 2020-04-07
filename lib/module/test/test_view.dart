import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'test_model.dart';

ChangeNotifierProvider<TestModel> createTest() {
  return ChangeNotifierProvider(
    create: (_) => TestModel(),
    child: _TestView(),
  );
}

class _TestView extends StatefulWidget {
  @override
  _TestViewState createState() => _TestViewState();
}

class _TestViewState extends State<_TestView> {
  WebViewController _viewController;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TestModel>(context);

    return Scaffold(
      body: SafeArea(
        child: WebView(
          initialUrl: '',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _viewController = webViewController;
//            _viewController.loadUrl('https://covid19.data.eti.br');
            _viewController.loadUrl('https://covid19.health/');
          },
          onPageFinished: (String url) {
            Future.delayed(Duration(seconds: 1), () {
              _viewController.evaluateJavascript('''
            document.getElementsByClassName('col-right')[0].remove();
            document.getElementsByClassName('footer')[0].remove();
            ''');
            });
          },
        ),
      ),
    );
  }
}
