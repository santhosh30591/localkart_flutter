import 'package:flutter/material.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class WebViewLoad extends StatefulWidget {
  dynamic roots;

  WebViewLoad({Key? key, @required this.roots}) : super(key: key);

  @override
  _WebViewLoad createState() => _WebViewLoad();
}

class _WebViewLoad extends State<WebViewLoad> {
  bool isLoading = true;

  late final WebViewController controller;
  late var url = "";
  String title = "";

  gettingDetails() async {
    try {
      url = await widget.roots["url"];
      title = await widget.roots["title"];
      print("skk path title $title url $url");
    } catch (e) {
      print("web view loading e " + e.toString());
    }
    setState(() {});
    _controller = await WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onProgress: (int progress) {
            // Update a custom progress bar if needed
          },
        ),
      )
      ..loadRequest(Uri.parse(url.toString()));
  }

  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    gettingDetails();
  }

  @override
  Widget build(BuildContext context) {
    return actionBarTopBottomView(
      title,
      context,
      Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
