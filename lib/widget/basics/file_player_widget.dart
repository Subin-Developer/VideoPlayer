import 'dart:io';

import 'package:fetch_all_videos/fetch_all_videos.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:videoplayer/widget/other/floating_action_button_widget.dart';
import 'package:videoplayer/widget/video_player_widget.dart';
class FilePlayerWidget extends StatefulWidget {
  const FilePlayerWidget({super.key});

  @override
  State<FilePlayerWidget> createState() => _FilePlayerWidgetState();
}

class _FilePlayerWidgetState extends State<FilePlayerWidget> {
  late File file;
  late VideoPlayerController controller;
  bool isVideoInitialized = false;
  final fetchAllVideos = FetchAllVideos();
  List<File> _files = [];

  @override
  void initState() {
    super.initState();
    file = File(
        '/data/user/0/com.example.video_example/cache/file_picker/big_buck_bunny_720p_10mb.mp4');
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
    _getFiles();
  }

  void _getFiles() async {
    List<dynamic> videoPathsDynamic = await fetchAllVideos.getAllVideos();
    List<String> videoPaths =
        List<String>.from(videoPathsDynamic.map((e) => e.toString()));
    List<File> videoFiles = [];
    for (var path in videoPaths) {
      File file = File(path);
      videoFiles.add(file);
    }
    print(videoFiles.length);
    setState(() {
      _files = videoFiles;
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isVideoInitialized) VideoPlayerWidget(controller: controller),
            SizedBox(
              width: 400,
              height: 400,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                ),
                itemCount: _files.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async {
                      if (controller.value.isInitialized) {
                        await controller.pause();
                      }

                      setState(() {
                        file = _files[index];
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
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.video_library,
                            size: 50,
                          ),
                          const SizedBox(height: 10),
                          Text(_files[index].path.split('/').last),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: buildAddButton(),
    );
  }

  Widget buildAddButton() {
    return Container(
      padding: const EdgeInsets.all(32),
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
