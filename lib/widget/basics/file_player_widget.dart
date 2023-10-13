import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:videoplayer/widget/other/floating_action_button_widget.dart';
import 'package:videoplayer/widget/video_player_widget.dart';

class FilePlayerWidget extends StatefulWidget {
  const FilePlayerWidget({Key? key}) : super(key: key);

  @override
  _FilePlayerWidgetState createState() => _FilePlayerWidgetState();
}

class _FilePlayerWidgetState extends State<FilePlayerWidget> {
  late File file;
  late VideoPlayerController controller;
  bool isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    file = File('/data/user/0/com.example.video_example/cache/file_picker/big_buck_bunny_720p_10mb.mp4');
    controller = VideoPlayerController.file(file);

    controller.addListener(() {
      setState(() {});
    });

    controller.setLooping(true);
    controller.initialize().then((_) {
      setState(() {
        isVideoInitialized = true;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (isVideoInitialized) VideoPlayerWidget(controller: controller),
          buildAddButton(),
        ],
      ),
    );
  }

  Widget buildAddButton() {
    return Container(
      padding: EdgeInsets.all(32),
      child: FloatingActionButtonWidget(
        onPressed: () async {
          final selectedFile = await pickVideoFile();
          if (selectedFile == null) return;

          if (controller.value.isInitialized) {
            await controller.pause();
          }

          setState(() {
            file = selectedFile;
            controller = VideoPlayerController.file(file);
            controller.addListener(() {
              setState(() {});
            });
            controller.setLooping(true);
            controller.initialize().then((_) {
              controller.play();
              setState(() {
                isVideoInitialized = true;
              });
            });
          });
        },
      ),
    );
  }

  Future<File?> pickVideoFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result == null) return null;

    final path = result.files.single.path;
    if (path == null) return null;

    return File(path);
  }
}
