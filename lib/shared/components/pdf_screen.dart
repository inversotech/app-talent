import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:lamb_talent/resources/services/account_status/account_status_service.dart';

import 'loading.dart';

class PDFScreen extends StatefulWidget {
  final String path;
  final String urlFileDownload;
  final String titlePdf;
  final String clave;
  final bool showDownload;

  const PDFScreen(
      {Key? key,
      required this.path,
      this.urlFileDownload = '',
      this.clave = '',
      this.titlePdf = '',
      this.showDownload = false})
      : super(key: key);

  @override
  PDFScreenState createState() => PDFScreenState();
}

class PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titlePdf),
        actions: <Widget>[
          widget.showDownload && widget.urlFileDownload.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () async {
                    if (widget.urlFileDownload.isNotEmpty) {
                      final accountStatusService = AccountStatusService();
                      final Map<String, String> params = {
                        'p': widget.clave.toString(),
                      };
                      loadingIndicator(
                          onlyLoading: true, text: 'Descargando ...');
                      await accountStatusService.saveDownloadPaymentTicket(
                          widget.urlFileDownload, widget.titlePdf, params);
                      // Navigator.pop(context);
                      Get.back();
                    }
                  },
                )
              : Container(),
        ],
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation:
                false, // if set to true the link is handled in flutter
            onRender: (pages) {
              setState(() {
                pages = pages ?? 0;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              //print(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              //print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String? uri) {
              //print('goto uri: $uri');
            },
            onPageChanged: (int? page, int? total) {
              //print('page change: $page/$total');
              setState(() {
                currentPage = page ?? 0;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container()
              : Center(
                  child: Text(errorMessage),
                )
        ],
      ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData) {
            return pages > 1
                ? FloatingActionButton.extended(
                    label: Text("Ir a ${pages ~/ 2}"),
                    onPressed: () async {
                      await snapshot.data!.setPage(pages ~/ 2);
                    },
                  )
                : Container();
          }

          return Container();
        },
      ),
    );
  }
}
