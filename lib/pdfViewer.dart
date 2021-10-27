

import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/rendering.dart';
import 'package:softpoint/properties.dart';

import 'admob.dart';

class PdfViewer extends StatefulWidget {
  final String url;
  PdfViewer({Key key, this.url}) : super(key: key);

  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  bool isLoading = true;
  PDFDocument document;
  AdmobHelper admobHelper = new AdmobHelper();
  @override
  initState() {
    super.initState();
    loadDocument();
  }

 

  loadDocument() async {
    document = await PDFDocument.fromURL(widget.url);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(primeryColor),
                ))
              : PDFViewer(
                  progressIndicator: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(primeryColor),
                  ),
                  scrollDirection: Axis.vertical,
                  pickerButtonColor: Color(0xFFB40284A),
                  document: document)),
    );
  }
}
