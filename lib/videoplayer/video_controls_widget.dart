import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';



class VideoControlsWidget extends StatefulWidget {
  // const VideoControlsWidget({Key? key}) : super(key: key);

  final VideoPlayerController controller;

  const VideoControlsWidget({
    @required this.controller,
    Key key,
  }) : super(key: key);
  @override
  _VideoControlsWidgetState createState() => _VideoControlsWidgetState();
}

class _VideoControlsWidgetState extends State<VideoControlsWidget> {
  //build widget
  @override
  Widget build(BuildContext context) =>
      Stack(
    children: <Widget>[
      AnimatedSwitcher(
        duration: Duration(milliseconds: 50),
        reverseDuration: Duration(milliseconds: 200),
        child: this.widget.controller.value.isPlaying
            ? SizedBox.shrink()
            : Container(
          color: Colors.black26,
          child: Center(
            child: Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 100.0,
            ),
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          this.widget.controller.value.isPlaying
              ? this.widget.controller.pause()
              : this.widget.controller.play();
        },
      ),
    ],
  );
}
