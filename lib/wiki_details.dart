import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WikiDetailsScreen extends StatelessWidget {
  final int pageId;
  final String title;

  // In the constructor, require a Todo.
  WikiDetailsScreen({Key key, @required this.pageId, @required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("pageId$pageId");
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: WebView(
        initialUrl: 'https://en.m.wikipedia.org/?curid=$pageId',
      ),
    );
  }
}
