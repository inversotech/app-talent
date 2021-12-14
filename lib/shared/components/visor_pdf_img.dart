import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class VisorPdfImgPage extends StatelessWidget {
  final String title;
  final String filePath;

  // ignore: use_key_in_widget_constructors
  const VisorPdfImgPage({Key? key, this.title = '', required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: filePath.endsWith('.pdf')
            ? PDFView(filePath: filePath)
            : Image.file(
                File(filePath),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
