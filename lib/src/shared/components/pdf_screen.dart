import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:upn_financiero_mobil/src/services/account_status/account_status_service.dart';
import 'package:upn_financiero_mobil/src/shared/widgets/loading_indicator.dart';
import 'package:upn_financiero_mobil/src/shared/widgets/toast.dart';

class PDFScreen extends StatefulWidget {
  final File? file;
  final String path;
  final String titlePdf;
  final String clave;
  final bool showDownload;

  PDFScreen(
      {Key? key,
      this.file,
      required this.path,
      this.clave = '',
      this.titlePdf = '',
      this.showDownload = false})
      : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
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
          widget.showDownload && Platform.isAndroid
              ? IconButton(
                  icon: Icon(Icons.download),
                  onPressed: () async {
                    if (widget.file != null) {
                      AccountStatusService _accountStatusService =
                          new AccountStatusService();
                      final Map<String, String> params = {
                        'p': widget.clave.toString(),
                      };
                      ShowLoadingIndicator.showLoadingIndicator(
                          text: 'Descargando ...', context: context);
                      final response =
                          await _accountStatusService.downloadFileWithPath(
                              widget.file!, widget.titlePdf, params,context);
                      if (response.success) {
                        ToastCustom().successContext(
                          context: context,
                            message: 'Después de abrir el documento, de click en descargar para guardar en su dispositivo.',
                            time: 8);
                      }
                      Navigator.pop(context);
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
            onRender: (_pages) {
              setState(() {
                pages = _pages ?? 0;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String? uri) {
              print('goto uri: $uri');
            },
            onPageChanged: (int? page, int? total) {
              print('page change: $page/$total');
              setState(() {
                currentPage = page ?? 0;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? Center(
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
