import 'package:dartz/dartz.dart';
import '../entities/live_stream_entity.dart';

import '../../../../core/error/failures.dart';

abstract class LiveStreamRepository {
  Future<Either<Failure, LiveStreamEntity>> getLiveStreamData();
}
