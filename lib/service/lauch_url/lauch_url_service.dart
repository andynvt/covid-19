import 'package:url_launcher/url_launcher.dart' as _service;

class LaunchURL {
  static Future<bool> canOpen(String url) async {
    assert(url != null);
    return await _service.canLaunch(url);
  }

  static void launch(String url) async {
    assert(url != null);
    if (await canOpen(url)) {
      await _service.launch(url);
    }
  }
}
