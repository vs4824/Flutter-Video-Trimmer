import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../video_trim_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Video Trimmer'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("Pick Video"),
          onPressed: () async {
            HomeController().pickVideo();
          },
        ),
      ),
    );
  }
}
