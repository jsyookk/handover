import 'package:flutter/material.dart';
import 'package:handover/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AgreeTermsWebview extends StatefulWidget {
  @override
  _AgreeTermsWebviewState createState() => _AgreeTermsWebviewState();
}

class _AgreeTermsWebviewState extends State<AgreeTermsWebview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColour,
        appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
    child: AppBar(
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    backgroundColor: backgroundColour,
    title: Text('agree of terms', style: kAppbarTextStyle))),
    body: SafeArea(
        child: const WebView(
            initialUrl: 'http://52.78.63.34:8080/',
            javascriptMode: JavascriptMode.unrestricted,
    ))
    );
  }

}
