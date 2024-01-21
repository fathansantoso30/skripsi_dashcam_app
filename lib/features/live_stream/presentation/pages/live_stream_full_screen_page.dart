import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:skripsi_dashcam_app/features/live_stream/presentation/cubit/record_live_stream_cubit.dart';
import 'package:skripsi_dashcam_app/features/live_stream/presentation/widgets/record_timer.dart';
import 'package:skripsi_dashcam_app/features/live_stream/presentation/widgets/timestamp_clock.dart';
import 'package:skripsi_dashcam_app/utils/colors/common_colors.dart';
import 'package:skripsi_dashcam_app/utils/text_style/common_text_style.dart';

import '../../../../utils/icons/common_icons.dart';

class LiveStreamFullScreenPage extends StatefulWidget {
  final Stream<dynamic>? stream;
  final RecordLiveStreamCubit recordLiveStreamCubit;
  const LiveStreamFullScreenPage(
      {super.key, required this.stream, required this.recordLiveStreamCubit});

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
      final String imageName =
          DateFormat('dMMMyyyyHHmmss').format(DateTime.now());
      final image = await screenshotLandscapeController.capture();
      final result = await ImageGallerySaver.saveImage(image!, name: imageName);
      debugPrint('Screenshot saved to gallery: $result');
      Fluttertoast.showToast(
        msg: "Screenshot saved",
        toastLength: Toast.LENGTH_SHORT, //duration
        gravity: ToastGravity.BOTTOM, //location
      );
    } catch (e) {
      debugPrint('Error saving screenshot: $e');
      Fluttertoast.showToast(
        msg: "Error saving screenshot: $e",
        toastLength: Toast.LENGTH_SHORT, //duration
        gravity: ToastGravity.BOTTOM, //location
      );
    }
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
    return BlocProvider(
      create: (context) => widget.recordLiveStreamCubit,
      child: Scaffold(
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
              _buildRecordTimer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonSection() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildRecordButton(),
            const SizedBox(
              width: 24,
            ),
            _buildScreenshotButton(),
            const SizedBox(
              width: 24,
            ),
            _buildCollapseButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapseButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: CommonIcons.collapse,
    );
  }

  Widget _buildRecordButton() {
    return BlocConsumer<RecordLiveStreamCubit, RecordLiveStreamState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            // Dispatch an event to start recording the stream
            widget.recordLiveStreamCubit.startStopRecording();
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: state is RecordLiveStreamTrue
                  ? CommonColors.themeSemanticErrorSurfacePressed
                  : CommonColors.themeGreysMainSurface,
            ),
            child: state is RecordLiveStreamTrue
                ? CommonIcons.recordStopWhite
                : CommonIcons.recordStart,
          ),
        );
      },
      listener: (context, state) {
        // TODO: implement listener
        print(state);
        if (state is RecordLiveStreamStopped) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return Dialog(
                // The background color

                backgroundColor: CommonColors.themeBackground00,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // The loading indicator
                      const CircularProgressIndicator(),
                      const SizedBox(
                        height: 12,
                      ),
                      // Some text
                      Text(
                        'Saving...',
                        style: bodyMregular,
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }

        if (state is RecordLiveStreamSaved) {
          // Close the dialog if the state is not RecordLiveStreamSaving
          Navigator.of(context).pop();
        }
      },
    );
  }

  Widget _buildScreenshotButton() {
    return GestureDetector(
      onTap: () {
        saveScreenshot();
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: CommonColors.themeGreysMainSurface,
        ),
        child: CommonIcons.camera,
      ),
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
          } else {
            if (widget.recordLiveStreamCubit.isRecording) {
              widget.recordLiveStreamCubit.saveImageFileToDirectory(
                  snapshot.data,
                  'image_${widget.recordLiveStreamCubit.frameNum}.jpg');
              widget.recordLiveStreamCubit.frameNum++;
            }
            // Working for single frames
            return Stack(
              children: [
                Image.memory(
                  snapshot.data,
                  gaplessPlayback: true,
                  height: double.infinity,
                  width: double.infinity,
                ),
                const TimestampClock(),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildRecordTimer() {
    return BlocBuilder<RecordLiveStreamCubit, RecordLiveStreamState>(
      builder: ((context, state) {
        if (state is RecordLiveStreamTrue) {
          return const Positioned(
            bottom: 24,
            left: 24,
            child: BlinkingTimer(),
          );
        }

        return const SizedBox.shrink();
      }),
    );
  }
}
