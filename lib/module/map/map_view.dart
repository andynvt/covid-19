import 'package:covid/resource/resource.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

Widget createMap() {
  return _MapView();
}

class _MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<_MapView> {
  WebViewController _webViewController;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            WebView(
              initialUrl: '',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _webViewController = webViewController;
                _webViewController.loadUrl('https://covid19.health/');
              },
              onPageFinished: (String url) {
                Future.delayed(Duration(seconds: 2), () {
                  _webViewController.evaluateJavascript('''
                document.getElementsByClassName('col-right')[0].remove();
                document.getElementsByClassName('footer')[0].remove();
                document.getElementsByClassName('header')[0].remove();
                document.getElementsByClassName("nav-bar")[0].style = 'padding-top: 20px';
                document.getElementsByClassName("anime-ctrl")[0].style = 'padding-bottom: 0px';
                document.getElementsByClassName("date-slider")[0].style = 'padding-bottom: 0px';
                document.getElementsByClassName("footer-white")[0].style = 'height: 130px;';
                document.getElementsByClassName("map-toggle")[0].style = 'margin-bottom: 150px';
                document.getElementsByClassName("nav-bar-icon")[1].click();
                ''');
                });
              },
            ),
            SizedBox(
              width: 60,
              child: FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                padding: EdgeInsets.zero,
                child: Icon(Icons.keyboard_backspace, color: Cl.white),
                shape: CircleBorder(),
                color: Cl.black.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
