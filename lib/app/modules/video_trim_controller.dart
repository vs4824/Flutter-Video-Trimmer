import 'package:get/get.dart';
import 'package:video_trimmer/video_trimmer.dart';

class VideoTrimController extends GetxController {
  final Trimmer trimmer = Trimmer();
  var startValue = 0.0.obs;
  var endValue = 0.0.obs;
  var isPlaying = false.obs;
  var progressVisibility = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadVideo();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  loadVideo() {
    trimmer.loadVideo(videoFile: Get.arguments);
  }

  saveVideo() async {
    progressVisibility.value = true;
    String? result;
    await trimmer.saveTrimmedVideo(
        startValue: startValue.value,
        endValue: endValue.value,
        onSave: (value) {
          progressVisibility.value = false;
          result = value;
          Get.snackbar("Video", result!);
        });
  }
}
