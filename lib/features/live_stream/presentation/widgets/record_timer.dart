import 'dart:async';

import 'package:flutter/material.dart';
import 'package:skripsi_dashcam_app/utils/colors/common_colors.dart';
import 'package:skripsi_dashcam_app/utils/text_style/common_text_style.dart';

class BlinkingTimer extends StatefulWidget {
  const BlinkingTimer({super.key});

  @override
  BlinkingTimerState createState() => BlinkingTimerState();
}

class BlinkingTimerState extends State<BlinkingTimer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late DateTime currentTime;
  late String _timeString;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.repeat();

    _timeString = "00:00";
    currentTime = DateTime.now();
    _timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTimer());
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 30,
      decoration: const BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FadeTransition(
            opacity: _animationController,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                  color: Colors.red, shape: BoxShape.circle),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(_timeString,
              style: bodyMmedium.copyWith(
                color: CommonColors.themeBrandPrimaryTextInvert,
              ))
        ],
      ),
    );
  }

  _getTimer() {
    final DateTime now = DateTime.now();
    Duration d = now.difference(currentTime);

    setState(() {
      _timeString =
          "${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
    });
  }

  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
}
