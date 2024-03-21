import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:video_player/video_player.dart';

class FullscreenVideo extends StatefulWidget {
  final String videoUrl;

  const FullscreenVideo({required this.videoUrl});

  @override
  _FullscreenVideoState createState() => _FullscreenVideoState();
}

class _FullscreenVideoState extends State<FullscreenVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize the video controller with the provided video URL
    _controller = VideoPlayerController.network(widget.videoUrl);

    // Initialize GetStorage for caching video position
    GetStorage box = GetStorage();
    int? savedPosition = box.read('videoPosition');

    if (savedPosition != null) {
      _controller.seekTo(Duration(milliseconds: savedPosition));
    }

    _controller.addListener(() {
      box.write('videoPosition', _controller.value.position.inMilliseconds);
    });

    _controller.initialize().then((_) {
      // Once the video is loaded, do not play automatically
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    VideoPlayer(_controller),
                    VideoControls(controller: _controller),
                  ],
                ),
              )
            : CircularProgressIndicator(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class VideoControls extends StatelessWidget {
  final VideoPlayerController controller;

  const VideoControls({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ... existing code ...

        // Fullscreen button
        Positioned(
          top: 10.0,
          right: 10.0,
          child: IconButton(
            icon: Icon(Icons.fullscreen),
            onPressed: () {
              controller.play();
              controller.pause();
              controller.setVolume(1.0);
              controller.setPlaybackSpeed(1.0);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => FullscreenVideo(
              //       videoUrl: widget.videoUrl,
              //     ),
              //   ),
              // );
            },
          ),
        ),
      ],
    );
  }
}

void openFullscreenVideo(BuildContext context, String videoUrl) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => FullscreenVideo(videoUrl: videoUrl),
    ),
  );
}
