import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skripsi_dashcam_app/utils/colors/common_colors.dart';
import 'package:skripsi_dashcam_app/utils/text_style/common_text_style.dart';

class TimestampClock extends StatefulWidget {
  const TimestampClock({super.key});

  @override
  State<TimestampClock> createState() => _TimestampClockState();
}

class _TimestampClockState extends State<TimestampClock>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          top: 24,
          left: 24,
          child: Text(
            _getCurrentTime(),
            style: timestampStyle.copyWith(
              color: CommonColors.themeGreysMainSurface,
            ),
          ),
        );
      },
    );
  }

  String _getCurrentTime() {
    DateTime now = DateTime.now();
    String formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    return formattedTime;
  }
}
