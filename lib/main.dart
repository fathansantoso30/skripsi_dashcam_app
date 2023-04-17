import 'package:flutter/material.dart';
import 'package:skripsi_dashcam_app/injection.dart';

import 'src/feature/live_stream/presentation/live_stream_page.dart';

void main() {
  configureDependencies();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      home: const LiveStreamPage(),
    );
  }
}
