import 'package:get/get.dart';
class AlbumPhotoController extends GetxController {
  final String id;
  AlbumPhotoController({required this.id});

  RxBool clickPage = true.obs;
  RxBool loadingData = true.obs;
  @override
  void onReady() {
    super.onReady();
  }
}
