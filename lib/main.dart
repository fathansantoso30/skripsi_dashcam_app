import 'package:flutter/material.dart';

import 'features/live_stream/di/live_stream_dependecy_injection.dart';
import 'features/live_stream/presentation/pages/live_stream_page.dart';

void main() {
  initDependencyInjection();
  WidgetsFlutterBinding.ensureInitialized();
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
      // home: const LiveStreamFullScreenPage(),
    );
  }
}

void initDependencyInjection() {
  initLiveStreamDI();
}
