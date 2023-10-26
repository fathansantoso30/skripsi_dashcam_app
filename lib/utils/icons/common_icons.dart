import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../colors/common_colors.dart';

class CommonIcons {
  static SvgPicture defaultSizeAssets(
    String filename, {
    Color color = CommonColors.themeGreysMainTextPrimary,
    double width = 24,
    double height = 24,
  }) {
    return SvgPicture.asset(
      getAssetPath(filename),
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      width: width,
      height: height,
    );
  }

  static String getAssetPath(String filename) {
    return "assets/icons/$filename";
  }

  // Live Stream Icons
  static SvgPicture collapse = defaultSizeAssets(
    "collapse.svg",
    width: 24,
    height: 24,
    color: CommonColors.themeGreysMainSurface,
  );

  static SvgPicture expand = defaultSizeAssets(
    "expand.svg",
    width: 24,
    height: 24,
    color: CommonColors.themeGreysMainSurface,
  );

  static SvgPicture videoCameraOn = defaultSizeAssets(
    "video-camera.svg",
    width: 24,
    height: 24,
    color: CommonColors.themeBrandPrimaryTextInvert,
  );

  static SvgPicture videoCameraOff = defaultSizeAssets(
    "video-camera-off.svg",
    width: 24,
    height: 24,
    color: CommonColors.themeBrandPrimaryTextInvert,
  );

  static SvgPicture camera = defaultSizeAssets(
    "camera.svg",
    width: 24,
    height: 24,
    color: CommonColors.themeGreysMainTextPrimary,
  );

  static SvgPicture cameraWhite = defaultSizeAssets(
    "camera.svg",
    width: 24,
    height: 24,
    color: CommonColors.themeGreysMainSurface,
  );
  // Navbar Icons [Active State]
  static SvgPicture galleryActive = defaultSizeAssets(
    "gallery.svg",
    width: 24,
    height: 24,
    color: CommonColors.themeBrandPrimarySurface,
  );

  static SvgPicture homeActive = defaultSizeAssets(
    "home.svg",
    width: 24,
    height: 24,
    color: CommonColors.themeBrandPrimarySurface,
  );

  static SvgPicture settingsActive = defaultSizeAssets(
    "settings.svg",
    width: 24,
    height: 24,
    color: CommonColors.themeBrandPrimarySurface,
  );

  // Navbar Icons [Default State]
  static SvgPicture gallery = defaultSizeAssets(
    "gallery.svg",
    width: 24,
    height: 24,
    color: CommonColors.themeBrandPrimaryBorderAlpha,
  );

  static SvgPicture home = defaultSizeAssets(
    "home.svg",
    width: 24,
    height: 24,
    color: CommonColors.themeBrandPrimaryBorderAlpha,
  );

  static SvgPicture settings = defaultSizeAssets(
    "settings.svg",
    width: 24,
    height: 24,
    color: CommonColors.themeBrandPrimaryBorderAlpha,
  );

  // Wifi State Icons
  static SvgPicture stateWifiOff = defaultSizeAssets(
    "state=wifi-off.svg",
    width: 24,
    height: 24,
  );

  static SvgPicture stateWifiOn = defaultSizeAssets(
    "state=wifi.svg",
    width: 24,
    height: 24,
  );

  static SvgPicture time = defaultSizeAssets(
    "time.svg",
    width: 16,
    height: 16,
  );

  static SvgPicture play = defaultSizeAssets(
    "play.svg",
    width: 16,
    height: 16,
    color: CommonColors.themeGreysMainSurface,
  );

  static SvgPicture share = defaultSizeAssets(
    "share.svg",
    width: 24,
    height: 24,
  );
}
