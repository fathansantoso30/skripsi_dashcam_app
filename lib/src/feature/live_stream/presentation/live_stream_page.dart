import 'package:flutter/material.dart';
import 'package:skripsi_dashcam_app/src/utils/colors/common_colors.dart';
import 'package:skripsi_dashcam_app/src/utils/icons/common_icons.dart';
import 'package:skripsi_dashcam_app/src/utils/images/common_images.dart';
import 'package:skripsi_dashcam_app/src/utils/text_style/common_text_style.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class LiveStreamPage extends StatefulWidget {
  const LiveStreamPage({super.key});

  @override
  State<LiveStreamPage> createState() => _LiveStreamPageState();
}

class _LiveStreamPageState extends State<LiveStreamPage> {
  static const String url = "ws://192.168.4.1:8888";
  WebSocketChannel? _channel;
  bool _isConnected = false;
  int _selectedIndex = 1;

  void connect() {
    _channel = IOWebSocketChannel.connect(Uri.parse(url));
    setState(() {
      _isConnected = true;
    });
  }

  void disconnect() {
    _channel!.sink.close();
    setState(() {
      _isConnected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  Widget _buildVideoScreenSection() {
    return Container(
      color: Colors.black,
      height: 261,
      child: _isConnected
          ? StreamBuilder(
              stream: _channel!.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  return const Center(
                    child: Text("Connection Closed !"),
                  );
                }
                //? Working for single frames
                return Image.memory(
                  snapshot.data,
                  gaplessPlayback: true,
                  // width: 640,
                  // height: 480,
                );
              },
            )
          : Center(
              child: Text(
                "Initiate Connection",
                style: bodyMregular.copyWith(
                    color: CommonColors.themeBrandPrimaryTextInvert),
              ),
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
        ),
        const SizedBox(
          height: 24,
        ),
        _commonButton(
          icon: CommonIcons.videoCameraOn,
          text: "Start Camera Feed",
          colorButton: CommonColors.themeBrandPrimarySurface,
          colorText: CommonColors.themeBrandPrimaryTextInvert,
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
  }) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: colorButton,
            foregroundColor: colorText,
            padding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            )),
        onPressed: () {},
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
