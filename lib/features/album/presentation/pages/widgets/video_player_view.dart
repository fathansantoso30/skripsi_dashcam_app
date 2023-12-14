import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:skripsi_dashcam_app/utils/colors/common_colors.dart';
import 'package:skripsi_dashcam_app/utils/icons/common_icons.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatefulWidget {
  final String videoPath;
  const VideoPlayerView({
    Key? key,
    required this.videoPath,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VideoPlayerViewState();
  }
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late VideoPlayerController _videoPlayerController1;
  ChewieController? _chewieController;
  int? bufferDelay;

  @override
  void initState() {
    super.initState();
    initializePlayer(widget.videoPath);
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  // example for url video source
  // String srcs =
  //   "https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4",

  Future<void> initializePlayer(String videoPath) async {
    // network url source
    // _videoPlayerController1 =
    //     VideoPlayerController.networkUrl(Uri.parse(srcs));
    _videoPlayerController1 = VideoPlayerController.asset(videoPath);
    await Future.wait([
      _videoPlayerController1.initialize(),
    ]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: true,
      looping: true,
      showOptions: false,
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
      materialProgressColors: ChewieProgressColors(
        playedColor: CommonColors.themeBrandPrimarySurface,
        handleColor: CommonColors.themeBrandPrimaryText,
        backgroundColor: CommonColors.themeGreysInvertTextPrimary,
        bufferedColor: CommonColors.themeGreysInvertTextPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: CommonColors.themeGreysInvertSurfacePressed,
            ),
            height: 42,
            width: 42,
            child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CommonIcons.arrowBack),
          ),
        ),
      ),
      backgroundColor: CommonColors.themeBackground03,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: _chewieController != null &&
                      _chewieController!
                          .videoPlayerController.value.isInitialized
                  ? Chewie(
                      controller: _chewieController!,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text('Loading'),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
