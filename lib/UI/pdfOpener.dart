import 'dart:async';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart' as launch;
import '../global/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../UI/Home.dart';
import '../main.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

class PdfOpener extends StatefulWidget {
  final String url, name;
  final String mobile;

  const PdfOpener({Key key, this.url, this.mobile, this.name})
      : super(key: key);
  @override
  _PdfOpenerState createState() => _PdfOpenerState();
}

class _PdfOpenerState extends State<PdfOpener> {
  bool _isloading = true;
  PDFDocument doc;
  @override
  void initState() {
    super.initState();
    getPdf();
  }

  getPdf() async {
    doc = await PDFDocument.fromURL(widget.url);
    _isloading = false;
    setState(() {});
  }

  String remotePDFpath = "";
  Future<File> createFileOfPdfUrl(String url) async {
    Completer<File> completer = Completer();
    try {
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      print("Download files");
      print("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }
    setState(() {
      _isloading = false;
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: _isloading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Container(
                        color: Colors.green,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // ignore: deprecated_member_use
                            RaisedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Home(),
                                    ));
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text("Home"),
                            ),
                            // ignore: deprecated_member_use
                            RaisedButton(
                              child: Text("Log Out"),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              onPressed: () {
                                FirebaseAuth.instance.signOut();
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                  builder: (context) {
                                    return MyApp();
                                  },
                                ));
                              },
                            )
                          ],
                        ),
                      ),
                      Expanded(child: PDFViewer(document: doc)),
                      // ignore: deprecated_member_use
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        onPressed: () async {
                          await launch.launch(
                              "https://wa.me/+91${widget.mobile}?text=Dear ${widget.name},\nPlease Download your Prescription Copy from here made by ${data.name.toUpperCase()} ${widget.url}");
                        },
                        color: Colors.green,
                        child: Text("Share it"),
                      )
                    ],
                  )),
      ),
    );
  }
}
