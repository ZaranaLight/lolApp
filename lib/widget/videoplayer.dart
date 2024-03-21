import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
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
      backgroundColor: Colors.black,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    VideoPlayer(_controller),
                    VideoControls(
                      controller: _controller,
                      videoUrl: widget.videoUrl,
                    ),
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
  final String videoUrl;
  const VideoControls({required this.controller, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.to(FullscreenVideo(videoUrl: videoUrl));
        if (controller.value.isPlaying) {
          controller.pause();
        } else {
          controller.play();
        }
      },
    );
  }
}
