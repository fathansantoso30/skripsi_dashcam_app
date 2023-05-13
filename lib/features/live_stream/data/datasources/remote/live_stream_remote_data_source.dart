import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../models/live_stream_model.dart';

abstract class LiveStreamRemoteDataSource {
  /// Calls the websocket stream channel endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<LiveStreamModel> getLiveStreamData();
}

class LiveStreamRemoteDataSourceImpl implements LiveStreamRemoteDataSource {
  @override
  Future<LiveStreamModel> getLiveStreamData() async {
    // Websocket url address
    const String url = "ws://192.168.4.1:8888";
    // connect tot websocket channel
    WebSocketChannel? channel = IOWebSocketChannel.connect(Uri.parse(url));
    return LiveStreamModel(dataStream: channel);
  }
}
