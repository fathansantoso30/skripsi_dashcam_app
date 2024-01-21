import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/live_stream_entity.dart';

abstract class LiveStreamRepository {
  Future<Either<Failure, LiveStreamEntity>> getLiveStreamData();
  Future<Either<Failure, void>> closeLiveStreamData();
}
