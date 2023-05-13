import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/live_stream_entity.dart';
import '../repositories/live_stream_repository.dart';

class GetLiveStreamDataUseCase extends UseCase<LiveStreamEntity, NoParams> {
  final LiveStreamRepository repository;

  GetLiveStreamDataUseCase({required this.repository});

  @override
  Future<Either<Failure, LiveStreamEntity>> call(NoParams params) async {
    return await repository.getLiveStreamData();
  }
}
