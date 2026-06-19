import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  final String html;

  const PaymentWebView(this.html, {super.key});

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController controller;        
  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
          Page error:
          Code: ${error.errorCode}
          Description: ${error.description}
          Type: ${error.errorType}
        ''');
          },

          onPageFinished: (url) {
            debugPrint("Page finished loading: $url");
          },
          onNavigationRequest: (request) {
            debugPrint("Navigating to => ${request.url}");
            if (request.url.contains("success") ||
                request.url.contains("Approved")) {
              Navigator.pop(context, true);
              return NavigationDecision.prevent;
            }

            if (request.url.contains("fail") ||
                request.url.contains("error") ||
                request.url.contains("Declined")) {
              Navigator.pop(context, false);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );

    // Use loadHtmlString directly
    controller.loadHtmlString(widget.html);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Secure Payment"), centerTitle: true),
      body: WebViewWidget(controller: controller),
    );
  }
}
