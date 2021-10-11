import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upn_financiero_mobil/src/models/models.dart' show ApiResponse;
import 'package:upn_financiero_mobil/src/shared/components/components.dart'
    show VisorPdfImgPage;

class PdfImgInputUpload extends StatelessWidget {
  final String title;
  final String subTitle;
  final String filePath;
  final bool showUploadFile;
  final bool showTakePicture;
  final bool showVisor;
  final bool showDelete;
  final Color colorBorder;
  final Function(PlatformFile) onFile;
  final Function(XFile) onTakePicture;
  final Future<ApiResponse> Function()? onGetFile;
  final onDelete;
  PdfImgInputUpload(
      {Key? key,
      required this.title,
      required this.subTitle,
      required this.filePath,
      this.showUploadFile = true,
      this.showTakePicture = true,
      this.showVisor = true,
      this.showDelete = true,
      this.colorBorder = Colors.black12,
      required this.onFile,
      required this.onTakePicture,
      this.onGetFile,
      required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: colorBorder),
          borderRadius: BorderRadius.circular(15.0)),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(subTitle),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                showUploadFile
                    ? IconButton(
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: [
                                'jpg',
                                'pdf',
                                'png',
                                'jpeg'
                              ]);

                          if (result != null) {
                            PlatformFile file = result.files.first;
                            this.onFile(file);
                          } else {
                            return;
                          }
                        },
                        icon: Icon(Icons.file_upload_outlined),
                      )
                    : Container(),
                showTakePicture
                    ? IconButton(
                        onPressed: () async {
                          final picker = new ImagePicker();
                          final XFile? pickedFile = await picker.pickImage(
                              source: ImageSource.camera, imageQuality: 100);
                          if (pickedFile == null) {
                            return;
                          } else {
                            this.onTakePicture(pickedFile);
                          }
                        },
                        icon: Icon(Icons.photo_camera),
                      )
                    : Container(),
                showVisor
                    ? IconButton(
                        onPressed: () async {
                          if (filePath.isEmpty && onGetFile != null) {
                            ApiResponse resp = await onGetFile!();
                            if (resp.success) {
                              final dir = await getTemporaryDirectory();
                              File file = new File(dir.path + subTitle);
                              Uint8List bytes = base64.decode(resp.data);
                              await file.writeAsBytes(bytes);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VisorPdfImgPage(
                                          title: 'Adjunto',
                                          filePath: file.path)));
                            }
                          } else if (filePath.isNotEmpty) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VisorPdfImgPage(
                                        title: 'Adjunto', filePath: filePath)));
                          }
                        },
                        icon: Icon(Icons.remove_red_eye),
                      )
                    : Container(),
                showDelete
                    ? IconButton(
                        onPressed: onDelete,
                        icon: Icon(Icons.delete),
                      )
                    : Container()
              ],
            )
          ],
        ),
      ),
    );
  }
}
