import 'package:flutter/material.dart';
import 'package:videoplayer/widget/basics/file_player_widget.dart';
import 'package:videoplayer/widget/basics/network_player_widget.dart';
import 'package:videoplayer/widget/other/tabbar_widget.dart';

class BasicsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => TabBarWidget(
        tabs: [
          Tab(icon: Icon(Icons.attach_file), text: 'File'),
          Tab(icon: Icon(Icons.ondemand_video_outlined), text: 'Network'),
        ],
        onTap: (int value) { 
          print("dd0");
         },
        children: [
          buildFiles(),
          buildNetwork(),
        ],
      );


  Widget buildFiles() => FilePlayerWidget();

  Widget buildNetwork() => NetworkPlayerWidget();
}
