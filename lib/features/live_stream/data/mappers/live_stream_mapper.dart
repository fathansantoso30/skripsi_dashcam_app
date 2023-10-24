import '../../domain/entities/live_stream_entity.dart';
import '../models/live_stream_model.dart';

class LiveStreamMapper {
  const LiveStreamMapper();

  static LiveStreamEntity mapLiveStreamDTO(LiveStreamModel? dto) {
    return LiveStreamEntity(dataStream: dto?.dataStream);
  }
}
