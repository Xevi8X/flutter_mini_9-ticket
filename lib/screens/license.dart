import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
//import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;

class LicenseWebView extends StatelessWidget {
  const LicenseWebView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var fileUrl = 'https://xevix.tplinkdns.com/regulamin.pdf';
    if(kIsWeb)
     {
     //   html.window.open(fileUrl, 'new tab');
       Navigator.of(context).pop();
        return Container();
     }
    var url = 'https://docs.google.com/gview?embedded=true&url=${fileUrl}';
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(url),
      );
    return Container(
        child: WebViewWidget(controller: controller)
    );
  }
}
