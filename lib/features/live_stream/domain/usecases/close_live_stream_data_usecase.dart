import 'package:dartz/dartz.dart';
import 'package:skripsi_dashcam_app/core/error/failures.dart';
import 'package:skripsi_dashcam_app/core/usecases/usecase.dart';
import 'package:skripsi_dashcam_app/features/live_stream/domain/repositories/live_stream_repository.dart';

class CloseLiveStreamDataUseCase extends UseCase<void, NoParams> {
  final LiveStreamRepository repository;

  CloseLiveStreamDataUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.closeLiveStreamData();
  }
}
