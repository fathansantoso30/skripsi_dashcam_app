import 'package:dartz/dartz.dart';
import 'package:skripsi_dashcam_app/core/error/failures.dart';
import 'package:skripsi_dashcam_app/core/usecases/usecase.dart';
import 'package:skripsi_dashcam_app/features/album/data/params/video_params.dart';
import 'package:skripsi_dashcam_app/features/album/domain/repositories/album_repository.dart';

class GetPlayVideoUseCase extends UseCase<Uri, VideoParams> {
  final AlbumRepository albumRepository;

  GetPlayVideoUseCase({required this.albumRepository});

  @override
  Future<Either<Failure, Uri>> call(VideoParams params) async {
    return await albumRepository.playVideo(params);
  }
}
