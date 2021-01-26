// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class MyWebView extends StatefulWidget {
//   final String title;
//   final String selectedUrl;

//   MyWebView({
//     @required this.title,
//     @required this.selectedUrl,
//   });

//   @override
//   _MyWebViewState createState() => _MyWebViewState();
// }

// class _MyWebViewState extends State<MyWebView> {
//   final Completer<WebViewController> _controller =
//       Completer<WebViewController>();

//   num _stackToView = 1;

//   void _handleLoad(String value) {
//     setState(() {
//       _stackToView = 0;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(widget.title),
//         ),
//         body: IndexedStack(
//           index: _stackToView,
//           children: [
//             Column(
//               children: <Widget>[
//                 Expanded(
//                     child: WebView(
//                   javascriptMode: JavascriptMode.unrestricted,
//                   initialUrl: this.widget.selectedUrl,
//                   onWebViewCreated: (WebViewController webViewController) {
//                     _controller.complete(webViewController);
//                   },
//                   onPageFinished: _handleLoad,
//                 )),
//               ],
//             ),
//             Container(
//               color: Colors.white,
//               child: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             ),
//           ],
//         ));
//   }

//   String url(String phone) {
//     print("Call url function");
//     if (Platform.isAndroid) {
//       // add the [https]

//       return "https://wa.me/$phone/?text= "; // new line
//     } else {
//       // add the [https]
//       return "https://api.whatsapp.com/send?phone=$phone= "; // new line
//     }
//   }
// }
