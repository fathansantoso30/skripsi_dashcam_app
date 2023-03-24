import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
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
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Live Video"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: connect,
                      child: const Text("Connect"),
                    ),
                    ElevatedButton(
                      onPressed: disconnect,
                      child: const Text("Disconnect"),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50.0,
                ),
                _isConnected
                    ? StreamBuilder(
                        stream: _channel!.stream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return const Center(
                              child: Text("Connection Closed !"),
                            );
                          }
                          //? Working for single frames
                          return Image.memory(
                            snapshot.data,
                            gaplessPlayback: true,
                            width: 640,
                            height: 480,
                          );
                        },
                      )
                    : const Text("Initiate Connection")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
