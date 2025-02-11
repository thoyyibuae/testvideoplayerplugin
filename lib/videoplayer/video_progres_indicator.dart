import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Displays the play/buffering status of the video controlled by [controller].



/// [padding] allows to specify some extra padding around the progress indicator
/// that will also detect the gestures.
class CustomVideoProgressIndicator extends StatefulWidget {

  CustomVideoProgressIndicator(
      this.controller, {
        VideoProgressColors colors,
        this.allowScrubbing,
        this.padding = const EdgeInsets.only(top: 5.0),
        this.timestamps,
      }) : colors = colors ?? VideoProgressColors();

  /// The [VideoPlayerController] that actually associates a video with this
  final VideoPlayerController controller;

  /// The default colors used throughout the indicator.

  final VideoProgressColors colors;

  final List<Duration> timestamps;

  /// When true, the widget will detect touch input and try to seek the video
  /// accordingly. The widget ignores such input when false.
  /// Defaults to false.
  final bool allowScrubbing;

  /// This allows for visual padding around the progress indicator that can
  /// still detect gestures via [allowScrubbing].
  ///
  /// Defaults to `top: 5.0`.
  final EdgeInsets padding;

  @override
  _CustomVideoProgressIndicatorState createState() =>
      _CustomVideoProgressIndicatorState();
}

class _CustomVideoProgressIndicatorState
    extends State<CustomVideoProgressIndicator> {
  _CustomVideoProgressIndicatorState() {
    listener = () {
      if (!mounted) {
        return;
      }
      setState(() {});
    };
  }

  VoidCallback listener;

  //get video controller
  VideoPlayerController get controller => widget.controller;

  //get video progres color
  VideoProgressColors get colors => widget.colors;


  //calculate duration of video
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  List<int> durationDifferences = [];

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  //call deactivate method
  @override
  void deactivate() {
    controller.removeListener(listener);
    super.deactivate();
  }

  //calculate video duration to playing duration
  void calculateDurationDiffs() {
    final timestamps = widget.timestamps;
    final firstDifference =
        timestamps.first.inSeconds - Duration.zero.inSeconds;

    durationDifferences.add(firstDifference);
    for (int i = 0; i < timestamps.length - 1; i++) {
      final difference = timestamps[i + 1].inSeconds - timestamps[i].inSeconds;
      durationDifferences.add(difference);
    }
    final lastDifference =
        controller.value.duration.inSeconds - timestamps.last.inSeconds;
    durationDifferences.add(lastDifference);
  }

  //build widget
  @override
  Widget build(BuildContext context) {
    Widget progressIndicator;
    if (controller.value.initialized) {
      if (durationDifferences.isEmpty) {
        // calculateDurationDiffs();
      }

      final int duration = controller.value.duration.inMilliseconds;
      final int position = controller.value.position.inMilliseconds;

      int maxBuffering = 0;
      for (DurationRange range in controller.value.buffered) {
        final int end = range.end.inMilliseconds;
        if (end > maxBuffering) {
          maxBuffering = end;
        }
      }

      progressIndicator = Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          LinearProgressIndicator(
            value: maxBuffering / duration,
            valueColor: AlwaysStoppedAnimation<Color>(colors.bufferedColor),
            backgroundColor: colors.backgroundColor,
          ),
          LinearProgressIndicator(
            value: position / duration,
            valueColor: AlwaysStoppedAnimation<Color>(colors.playedColor),
            backgroundColor: Colors.transparent,
          ),
        ],
      );
    } else {
      progressIndicator = LinearProgressIndicator(
        value: null,
        valueColor: AlwaysStoppedAnimation<Color>(colors.playedColor),
        backgroundColor: colors.backgroundColor,
      );
    }
    final Widget paddedProgressIndicator = Stack(
      children: [
        Container(
          height: 10,
          child: progressIndicator,
        ),
        Container(
          height: 10,
          child: Row(
            children: durationDifferences
                .map(
                  (difference) => Expanded(
                flex: difference,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    height: double.infinity,
                    width: 2,
                    color: Colors.white70,
                  ),
                ),
              ),
            )
                .toList(),
          ),
        ),
      ],
    );

    final progressBar = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [

        paddedProgressIndicator,
      ],
    );

    if (widget.allowScrubbing) {
      return _VideoScrubber(
        child: progressBar,
        controller: controller,
      );
    } else {
      return progressBar;
    }
  }
}

class _VideoScrubber extends StatefulWidget {
  _VideoScrubber({
    @required this.child,
    @required this.controller,
  });

  //variable declarations

  final Widget child;
  final VideoPlayerController controller;

  @override
  _VideoScrubberState createState() => _VideoScrubberState();
}

class _VideoScrubberState extends State<_VideoScrubber> {
  bool _controllerWasPlaying = false;

  //get controller
  VideoPlayerController get controller => widget.controller;


  //build widget
  @override
  Widget build(BuildContext context) {
    void seekToRelativePosition(Offset globalPosition) {
      final RenderBox box = context.findRenderObject();
      final Offset tapPos = box.globalToLocal(globalPosition);
      final double relative = tapPos.dx / box.size.width;
      final Duration position = controller.value.duration * relative;
      controller.seekTo(position);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: widget.child,
      onHorizontalDragStart: (DragStartDetails details) {
        if (!controller.value.initialized) {
          return;
        }
        _controllerWasPlaying = controller.value.isPlaying;
        if (_controllerWasPlaying) {
          controller.pause();
        }
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (!controller.value.initialized) {
          return;
        }
        seekToRelativePosition(details.globalPosition);
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        if (_controllerWasPlaying) {
          controller.play();
        }
      },
      onTapDown: (TapDownDetails details) {
        if (!controller.value.initialized) {
          return;
        }
        seekToRelativePosition(details.globalPosition);
      },
    );
  }
}