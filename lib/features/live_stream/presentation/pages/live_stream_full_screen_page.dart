import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../utils/icons/common_icons.dart';

class LiveStreamFullScreenPage extends StatefulWidget {
  final Stream<dynamic>? stream;
  const LiveStreamFullScreenPage({super.key, required this.stream});

  @override
  State<LiveStreamFullScreenPage> createState() =>
      _LiveStreamFullScreenPageState();
}

class _LiveStreamFullScreenPageState extends State<LiveStreamFullScreenPage> {
  ScreenshotController screenshotLandscapeController = ScreenshotController();
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.initState();
  }

  Future<void> saveScreenshot() async {
    try {
      final image = await screenshotLandscapeController.capture();
      final result = await ImageGallerySaver.saveImage(image!);
      debugPrint('Screenshot saved to gallery: $result');
    } catch (e) {
      debugPrint('Error saving screenshot: $e');
    }
  }

  // TODO: implement show snackbar if succesfully saved to gallery and also error
  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(
          seconds: 2,
        ),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black,
        child:
            // Render the live stream data on the page
            Stack(
          children: [
            _buildStreamSection(
              stream: widget.stream,
            ),
            _buildButtonSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonSection() {
    return Positioned(
      bottom: 24,
      right: 24,
      child: Row(
        children: [
          _buildScreenshotButton(),
          const SizedBox(
            width: 24,
          ),
          _buildCollapseButton(),
        ],
      ),
    );
  }

  Widget _buildCollapseButton() {
    return Positioned(
      bottom: 24,
      right: 24,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: CommonIcons.collapse,
      ),
    );
  }

  Widget _buildScreenshotButton() {
    return GestureDetector(
      onTap: () {
        saveScreenshot();
      },
      child: CommonIcons.cameraWhite,
    );
  }

  Widget _buildStreamSection({required Stream? stream}) {
    return Screenshot(
      controller: screenshotLandscapeController,
      child: StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          //? Working for single frames
          return Image.memory(
            snapshot.data,
            gaplessPlayback: true,
            height: double.infinity,
            width: double.infinity,
          );
        },
      ),
    );
  }
}
