import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../utils/colors/common_colors.dart';
import '../../../../utils/icons/common_icons.dart';
import '../../../../utils/images/common_images.dart';
import '../../../../utils/text_style/common_text_style.dart';
import '../cubit/live_stream_cubit.dart';
import 'live_stream_full_screen_page.dart';

class LiveStreamPage extends StatefulWidget {
  const LiveStreamPage({super.key});

  @override
  State<LiveStreamPage> createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage> {
  int _selectedIndex = 1;
  late LiveStreamCubit liveStreamCubit;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    liveStreamCubit = GetIt.instance<LiveStreamCubit>();
    super.initState();
  }

  @override
  void dispose() {
    liveStreamCubit.disconnectLiveStreamData();
    super.dispose();
  }

  void navigateToFullScreenPage() {
    dispose();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LiveStreamFullScreenPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LiveStreamCubit>(
      create: (context) => liveStreamCubit,
      child: Scaffold(
        body: ListView(
          children: [
            _buildVideoScreenSection(),
            const SizedBox(
              height: 24.0,
            ),
            _buildBodySection(),
          ],
        ),
        bottomNavigationBar: _buildNavbarSection(),
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
                stream: state.liveStream.dataStream?.stream.asBroadcastStream(),
              ),
              _buildExpandButton(),
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
    return StreamBuilder(
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
        );
      },
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

  Widget _buildBodySection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildDeviceInfoSection(),
          const SizedBox(
            height: 24,
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
        padding: const EdgeInsets.all(24),
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
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Status:",
                  style: bodyMregular,
                ),
                // TODO: Add state wifi off when not connected to the network, must check network device connection first.
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
    return Column(
      children: [
        _commonButton(
          icon: CommonIcons.camera,
          text: "Screenshot Frame",
          colorButton: CommonColors.themeBrandPrimaryLightSurface,
          colorText: CommonColors.themeGreysMainTextPrimary,
          onPressed: () {}, // TODO: Add method for screenshot live stream
        ),
        const SizedBox(
          height: 24,
        ),
        BlocBuilder<LiveStreamCubit, LiveStreamState>(
          builder: (context, state) {
            if (state is LiveStreamLoaded) {
              return _commonButton(
                icon: CommonIcons.videoCameraOff,
                text: "Stop Camera Feed",
                colorButton: CommonColors.themeSemanticErrorSurfacePressed,
                colorText: CommonColors.themeBrandPrimaryTextInvert,
                onPressed: () {
                  // Dispatch an event to stop the camera feed
                  liveStreamCubit.disconnectLiveStreamData();
                },
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
                },
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildNavbarSection() {
    return BottomNavigationBar(
        elevation: 4,
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            label: "Gallery",
            icon: CommonIcons.gallery,
            activeIcon: CommonIcons.galleryActive,
          ),
          BottomNavigationBarItem(
            label: "Home",
            icon: CommonIcons.home,
            activeIcon: CommonIcons.homeActive,
          ),
          BottomNavigationBarItem(
            label: "Settings",
            icon: CommonIcons.settings,
            activeIcon: CommonIcons.settingsActive,
          ),
        ]);
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
            padding: const EdgeInsets.all(16),
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
