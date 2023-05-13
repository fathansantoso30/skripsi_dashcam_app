import 'package:web_socket_channel/web_socket_channel.dart';

class LiveStreamEntity {
  final WebSocketChannel? dataStream;

  LiveStreamEntity({
    required this.dataStream,
  });
}
