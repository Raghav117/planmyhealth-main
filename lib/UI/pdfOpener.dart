import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

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
      body: Center(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Expanded(child: PDFViewer(document: doc)),
                    RaisedButton(
                      onPressed: () {
                        Share.share('Doctor Prescription PDF \n${widget.url}');
                      },
                      color: Colors.green,
                      child: Text("Share it"),
                    )
                  ],
                )),
    );
  }
}
