import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:wifi_iot/wifi_iot.dart';

part 'connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  ConnectivityCubit() : super(ConnectInitialState());
  bool isConnectedToTargetWifi = false;
  bool isConnected = false;

  final String targetSSID = 'ESP32-CAM';
  Location location = Location();

  bool? serviceEnabled;
  PermissionStatus? permissionGranted;

  Future<void> checkWifiStatus() async {
    // emit(ConnectLoadingState());
    try {
      isConnected = await WiFiForIoTPlugin.isConnected();
      String? ssid = await WiFiForIoTPlugin.getSSID();

      log("connection status: $isConnected");
      log("SSID status: $ssid");

      if (isConnected == true && ssid == targetSSID) {
        isConnectedToTargetWifi = true;
        emit(ConnectTrueState());
      } else {
        emit(ConnectFalseState());
      }
    } catch (e) {
      log("Error checking Wi-Fi status: $e");
    }
  }

  Future<void> checkLocationService() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled!) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled!) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }
}
