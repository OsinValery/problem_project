import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class UrlView extends StatefulWidget {
  const UrlView({super.key, required this.url});

  final String url;

  @override
  State<UrlView> createState() => _UrlViewState();
}

class _UrlViewState extends State<UrlView> {
  late InAppWebViewController _webViewController;
  double progress = 1;

  Future<bool> goBack() async {
    _webViewController.goBack();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WillPopScope(
          onWillPop: goBack,
          child: Stack(children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  useShouldOverrideUrlLoading: true,
                  javaScriptCanOpenWindowsAutomatically: true,
                ),
              ),
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onProgressChanged: (controller, progress) {
                setState(() => this.progress = progress / 100);
              },
            ),
            if (progress < 1.0)
              Center(
                  child: CircularProgressIndicator(
                value: progress,
                color: const Color.fromARGB(255, 54, 244, 177),
                strokeWidth: 2,
              ))
          ]),
        ),
      ),
    );
  }
}
