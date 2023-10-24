import 'package:flutter/material.dart';

import 'features/live_stream/di/live_stream_dependecy_injection.dart';
import 'features/live_stream/presentation/pages/live_stream_page.dart';

void main() {
  initDependencyInjection();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  static const String url = "ws://192.168.4.1:8888";
  WebSocketChannel? _channel;
  bool _isConnected = false;

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
