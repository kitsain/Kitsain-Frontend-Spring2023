import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/src/navigation_controls.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:kitsain_frontend_spring2023/src/web_view_stack.dart';
import 'package:kitsain_frontend_spring2023/src/menu.dart';

class Some extends StatefulWidget {
  const Some({super.key});

  @override
  State<Some> createState() => _SomeState();
}

class _SomeState extends State<Some> {
  late final WebViewController controller;
  final String customUserAgent = "Your_Custom_User_Agent";
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://immich.kitsain.com/'),
      );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('immich WebView'),
        actions: [
          NavigationControls(controller: controller),
          Menu(controller: controller),
        ],

      ),
      body: WebViewStack(controller: controller),
    );
  }
}