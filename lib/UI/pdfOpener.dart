import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import '../UI/Home.dart';
import '../main.dart';

class PdfOpener extends StatefulWidget {
  final String url;

  const PdfOpener({Key key, this.url}) : super(key: key);
  @override
  _PdfOpenerState createState() => _PdfOpenerState();
}

class _PdfOpenerState extends State<PdfOpener> {
  PDFDocument doc;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    getPdf();
  }

  getPdf() async {
    doc = await PDFDocument.fromURL(widget.url);
    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: _isLoading
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
                              child: Text("Home"),
                            ),
                            RaisedButton(
                              child: Text("Log Out"),
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
                      RaisedButton(
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
