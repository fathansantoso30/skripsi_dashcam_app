import 'package:dartz/dartz.dart';
import 'package:skripsi_dashcam_app/core/error/failures.dart';
import 'package:skripsi_dashcam_app/core/usecases/usecase.dart';
import 'package:skripsi_dashcam_app/features/album/data/params/video_params.dart';
import 'package:skripsi_dashcam_app/features/album/domain/repositories/album_repository.dart';

class GetDownloadVideoUseCase extends UseCase<Stream<int>, VideoParams> {
  final AlbumRepository albumRepository;

  GetDownloadVideoUseCase({required this.albumRepository});

  @override
  Future<Either<Failure, Stream<int>>> call(VideoParams params) async {
    return await albumRepository.downloadVideo(params);
  }
}
