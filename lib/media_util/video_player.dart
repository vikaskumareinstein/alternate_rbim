import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {}); // Refresh UI after video is initialized
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Stack(
            alignment: Alignment.center, // Center the play/pause button
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              // Overlay the play/pause button
              if (!_controller.value.isPlaying)
                GestureDetector(
                  onTap: _togglePlayPause,
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 80.0, // Adjust the size of the play button
                  ),
                ),
              if (_controller.value.isPlaying)
                GestureDetector(
                  onTap: _togglePlayPause,
                  child: Icon(
                    Icons.pause,
                    color: Colors.white,
                    size: 80.0, // Adjust the size of the pause button
                  ),
                ),
            ],
          )
        : Center(child: CircularProgressIndicator());
  }
}
