import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';





class CustomControlsWidget extends StatefulWidget {
  // const CustomControlsWidget({Key? key}) : super(key: key);
  final VideoPlayerController controller;
  final List<Duration> timestamps;

  const CustomControlsWidget({
    @required this.controller,
    @required this.timestamps,
    Key key,
  }) : super(key: key);
  @override
  _CustomControlsWidgetState createState() => _CustomControlsWidgetState();
}

class _CustomControlsWidgetState extends State<CustomControlsWidget> {
  @override

  //widget build  custom video control
  Widget build(BuildContext context) => Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildButton(Icon(Icons.fast_rewind), rewindToPosition),
        SizedBox(width: 12),
        buildButton(Icon(Icons.replay_5), rewind5Seconds),
        SizedBox(width: 12),
        buildButton(Icon(Icons.forward_5), forward5Seconds),
        SizedBox(width: 12),
        buildButton(Icon(Icons.fast_forward), forwardToPosition),
      ],
    ),
  );

  //customized button
  Widget buildButton(Widget child, Function onPressed) => Container(
    height: 50,
    width: 50,
    child: RaisedButton(
      child: child,
      onPressed: onPressed,
      color: Colors.black.withOpacity(0.1),
    ),
  );

  // call back to the postion
  Future rewindToPosition() async {
    if (this.widget.timestamps.isEmpty) return;
    Duration rewind(Duration currentPosition) => this.widget.timestamps.lastWhere(
          (element) => currentPosition > element + Duration(seconds: 2),
      orElse: () => Duration.zero,
    );

    await goToPosition(rewind);
  }

  //video move to forward position
  Future forwardToPosition() async {
    if (this.widget.timestamps.isEmpty) return;
    Duration forward(Duration currentPosition) => this.widget.timestamps.firstWhere(
          (position) => currentPosition < position,
      orElse: () => Duration(days: 1),
    );

    await goToPosition(forward);
  }

  //play forward to wait 5 second
  Future forward5Seconds() async =>
      goToPosition((currentPosition) => currentPosition + Duration(seconds: 5));

  //play back to wait 5 second

  Future rewind5Seconds() async =>
      goToPosition((currentPosition) => currentPosition - Duration(seconds: 5));

  //goto specific position of the video
  Future goToPosition(
      Duration Function(Duration currentPosition) builder,
      ) async {
    final currentPosition = await this.widget.controller.position;
    final newPosition = builder(currentPosition);

    await this.widget.controller.seekTo(newPosition);
  }
}
