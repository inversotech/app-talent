import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:lamb_talent/core/colors.dart';
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
  ReceivePort receivePort = ReceivePort();
  int showprogress = 0;

  @override
  void initState() {
    super.initState();

    downloadListener();
  }

  downloadListener() {
    final isSuccess = IsolateNameServer.registerPortWithName(
        receivePort.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      downloadListener();
      return;
    }

    receivePort.listen((dynamic message) async {
      String id = message[0];
      DownloadTaskStatus status = message[1];
      int progress = message[2];
      showprogress = progress;

      if (status == DownloadTaskStatus.complete &&
          progress == 100 &&
          id.isNotEmpty) {
        showprogress = 0;
        String query = "SELECT * FROM task WHERE task_id='$id'";
        await FlutterDownloader.loadTasksWithRawQuery(query: query);
        if (progress == 100) {
          final accountStatusService = AccountStatusService();
          final Map<String, String> params = {
            'p': widget.clave.toString(),
          };
          await accountStatusService.saveDownloadPaymentTicket(params);
        }
        //if the task exists, open it
        // if (tasks != null) FlutterDownloader.open(taskId: id);
      } else if (status == DownloadTaskStatus.failed && id.isNotEmpty) {
        showprogress = 0;
        String query = "SELECT * FROM task WHERE task_id='$id'";
        await FlutterDownloader.loadTasksWithRawQuery(query: query);
        if (progress == 100) {
          Get.snackbar('Mensaje:', 'Descarga fallida.',
              duration: const Duration(seconds: 8),
              colorText: ColorsApp.white,
              backgroundColor: ColorsApp.danger);
        }
      } else if (status == DownloadTaskStatus.canceled && id.isNotEmpty) {
        showprogress = 0;
        String query = "SELECT * FROM task WHERE task_id='$id'";
        await FlutterDownloader.loadTasksWithRawQuery(query: query);
        if (progress == 100) {
          Get.snackbar('Mensaje:', 'Descarga cancelada.',
              duration: const Duration(seconds: 8),
              colorText: ColorsApp.white,
              backgroundColor: ColorsApp.danger);
        }
      }
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? sendPort =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    sendPort!.send([id, status, progress]);
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

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
                      try {
                        final accountStatusService = AccountStatusService();
                        loadingIndicator(
                            onlyLoading: false, text: 'Descargando ...');
                        await accountStatusService.downloadPaymentTicket(
                            widget.urlFileDownload, widget.titlePdf);
                        // Navigator.pop(context);
                        Get.back();
                      } catch (e) {
                        Get.back();
                        Get.snackbar('Mensaje:', e.toString(),
                            duration: const Duration(seconds: 8),
                            colorText: ColorsApp.white,
                            backgroundColor: ColorsApp.danger);
                      }
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
