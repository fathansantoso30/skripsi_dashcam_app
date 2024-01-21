import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:screenshot/screenshot.dart';
import 'package:skripsi_dashcam_app/features/live_stream/presentation/cubit/record_live_stream_cubit.dart';
import 'package:skripsi_dashcam_app/features/live_stream/presentation/widgets/record_timer.dart';

import '../../../../utils/colors/common_colors.dart';
import '../../../../utils/icons/common_icons.dart';
import '../../../../utils/images/common_images.dart';
import '../../../../utils/text_style/common_text_style.dart';
import '../cubit/live_stream_cubit.dart';
import '../widgets/timestamp_clock.dart';
import 'live_stream_full_screen_page.dart';

class LiveStreamPage extends StatefulWidget {
  const LiveStreamPage({super.key});

  @override
  State<LiveStreamPage> createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage> {
  late LiveStreamCubit liveStreamCubit;
  late RecordLiveStreamCubit recordLiveStreamCubit;
  // ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    liveStreamCubit = GetIt.instance<LiveStreamCubit>();
    recordLiveStreamCubit = GetIt.instance<RecordLiveStreamCubit>();
    super.initState();
  }

  // No need to dispose as StreamBuilder is has its own streamsubscription
  // and will unsubscribe the stream if the widget is destroyed which means its already self managed
  void navigateToFullScreenPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LiveStreamFullScreenPage(
          stream: liveStreamCubit.broadcastStream,
          recordLiveStreamCubit: recordLiveStreamCubit,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: liveStreamCubit,
      child: Column(
        children: [
          _buildVideoScreenSection(),
          _buildBodySection(),
        ],
      ),
    );
  }

  Widget _buildVideoScreenSection() {
    return Container(
      color: Colors.black,
      height: 261,
      child: BlocBuilder<LiveStreamCubit, LiveStreamState>(
          builder: (context, state) {
        if (state is LiveStreamInitial || state is LiveStreamDisconnected) {
          return Center(
            child: Text(
              "Start Camera",
              style: bodyMregular.copyWith(
                  color: CommonColors.themeBrandPrimaryTextInvert),
            ),
          );
        } else if (state is LiveStreamLoaded) {
          // Render the live stream data on the page
          return Stack(
            children: [
              _buildStreamSection(
                stream: liveStreamCubit.broadcastStream,
              ),
              _buildExpandButton(),
              _buildRecordTimer(),
            ],
          );
        } else {
          // Render a loading indicator while the data is being loaded
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }

  Widget _buildStreamSection({required Stream? stream}) {
    return Screenshot(
      controller: liveStreamCubit.screenshotController,
      child: StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (recordLiveStreamCubit.isRecording) {
              recordLiveStreamCubit.saveImageFileToDirectory(
                  snapshot.data, 'image_${recordLiveStreamCubit.frameNum}.jpg');
              recordLiveStreamCubit.frameNum++;
            }
            // Working for single frames
            return Stack(children: [
              Image.memory(
                snapshot.data,
                gaplessPlayback: true,
                width: double.infinity,
              ),
              const TimestampClock(),
            ]);
          }
        },
      ),
    );
  }

  Widget _buildExpandButton() {
    return Positioned(
      bottom: 16,
      right: 16,
      child: GestureDetector(
        onTap: () {
          navigateToFullScreenPage();
        },
        child: CommonIcons.expand,
      ),
    );
  }

  Widget _buildRecordTimer() {
    return BlocBuilder<RecordLiveStreamCubit, RecordLiveStreamState>(
      builder: ((context, state) {
        if (state is RecordLiveStreamTrue) {
          return const Positioned(
            bottom: 16,
            left: 16,
            child: BlinkingTimer(),
          );
        }

        return const SizedBox.shrink();
      }),
    );
  }

  Widget _buildBodySection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildDeviceInfoSection(),
          const SizedBox(
            height: 8,
          ),
          _buildUserActionSection(),
        ],
      ),
    );
  }

  Widget _buildDeviceInfoSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CommonColors.themeBackground02, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              CommonImages.devicePicture,
              width: 80,
              height: 114,
            ),
            const SizedBox(height: 8),
            Text(
              "ESP32-CAM",
              style: bodyLregular,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Status:",
                  style: bodyMregular,
                ),
                Row(
                  children: [
                    CommonIcons.stateWifiOn,
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Connected",
                      style: bodyMregular,
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildUserActionSection() {
    return BlocBuilder<LiveStreamCubit, LiveStreamState>(
        builder: (context, state) {
      if (state is LiveStreamLoaded) {
        return Column(
          children: [
            _commonButton(
              icon: CommonIcons.camera,
              text: "Screenshot Frame",
              colorButton: CommonColors.themeBackground01,
              colorText: CommonColors.themeGreysMainTextPrimary,
              onPressed: () {
                liveStreamCubit.saveScreenshot();
              },
            ),
            const SizedBox(
              height: 12,
            ),
            _buildRecordButton(),
            const SizedBox(
              height: 12,
            ),
            _commonButton(
              icon: CommonIcons.videoCameraOff,
              text: "Stop Camera Feed",
              colorButton: CommonColors.themeSemanticErrorSurfacePressed,
              colorText: CommonColors.themeBrandPrimaryTextInvert,
              onPressed: () {
                // Dispatch an event to stop the camera feed
                liveStreamCubit.disconnectLiveStreamData();
              },
            ),
          ],
        );
      } else {
        return _commonButton(
          icon: CommonIcons.videoCameraOn,
          text: "Start Camera Feed",
          colorButton: CommonColors.themeBrandPrimarySurface,
          colorText: CommonColors.themeBrandPrimaryTextInvert,
          onPressed: () {
            // Dispatch an event to start the camera feed
            liveStreamCubit.getLiveStreamData();
            // get temp app dir for saving record frame image
            recordLiveStreamCubit.getAppTempDirectory();
          },
        );
      }
    });
  }

  Widget _buildRecordButton() {
    return BlocConsumer<RecordLiveStreamCubit, RecordLiveStreamState>(
        builder: (context, state) {
      return _commonButton(
        icon: state is RecordLiveStreamTrue
            ? CommonIcons.recordStop
            : CommonIcons.recordStart,
        text: state is RecordLiveStreamTrue
            ? "Stop Recording"
            : "Start Recording",
        colorButton: CommonColors.themeBackground01,
        colorText: state is RecordLiveStreamTrue
            ? CommonColors.themeSemanticErrorSurfacePressed
            : CommonColors.themeGreysMainTextPrimary,
        onPressed: () {
          // Dispatch an event to start recording the stream
          recordLiveStreamCubit.startStopRecording();
        },
      );
    }, listener: (context, state) {
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
    });
  }

  Widget _commonButton({
    required Widget icon,
    required String text,
    required Color colorButton,
    required Color colorText,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: colorButton,
            foregroundColor: colorText,
            padding: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            )),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(
              width: 8,
            ),
            Text(
              text,
              style: buttonL,
            ),
          ],
        ));
  }
}
