import 'package:dartz/dartz.dart';
import 'package:skripsi_dashcam_app/features/album/domain/entities/video_list_entity.dart';
import 'package:skripsi_dashcam_app/features/album/domain/repositories/album_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetVideoListUseCase extends UseCase<VideoListEntity, NoParams> {
  final AlbumRepository albumRepository;

  GetVideoListUseCase({required this.albumRepository});

  @override
  Future<Either<Failure, VideoListEntity>> call(NoParams params) async {
    return await albumRepository.getVideoList();
  }
}
