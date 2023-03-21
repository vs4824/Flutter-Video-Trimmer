import 'dart:io';

import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  pickVideo() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.video, allowCompression: false);
    if (result != null) {
      File file = File(result.files.single.path!);
      Get.toNamed(Routes.VIDEO_TRIM_VIEW, arguments: file);
    }
  }
}
