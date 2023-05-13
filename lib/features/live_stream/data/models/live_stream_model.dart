import 'package:web_socket_channel/web_socket_channel.dart';

class LiveStreamModel {
  final WebSocketChannel dataStream;

  LiveStreamModel({
    required this.dataStream,
  });

  factory LiveStreamModel.fromJson(Map<String, dynamic> json) {
    return LiveStreamModel(
      dataStream: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': dataStream,
    };
  }
}
