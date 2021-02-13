import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:share/share.dart';
import '../UI/Home.dart';
import '../main.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfOpener extends StatefulWidget {
  final String url;

  const PdfOpener({Key key, this.url}) : super(key: key);
  @override
  _PdfOpenerState createState() => _PdfOpenerState();
}

class _PdfOpenerState extends State<PdfOpener> {
  bool _isloading = true;

  @override
  void initState() {
    super.initState();
    createFileOfPdfUrl(widget.url).then((f) {
      setState(() {
        remotePDFpath = f.path;
      });
    });
  }

  String remotePDFpath = "";
  Future<File> createFileOfPdfUrl(String url) async {
    Completer<File> completer = Completer();
    print("Start download file from internet!");
    try {
      // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
      // final url = "https://pdfkit.org/docs/guide.pdf";

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
                      Expanded(
                          child: PDF.network(
                        widget.url,
                        height: MediaQuery.of(context).size.height - 100,
                        width: MediaQuery.of(context).size.width,
                      )),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        onPressed: () {
                          Share.share(
                              'Doctor Prescription PDF \n${widget.url}');
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
