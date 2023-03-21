import 'package:flutter_video_trimmer/app/modules/video_trim_controller.dart';
import 'package:get/get.dart';


class VideoTrimBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VideoTrimController>(
      () => VideoTrimController(),
    );
  }
}
