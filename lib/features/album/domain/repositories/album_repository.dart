import 'package:dartz/dartz.dart';
import 'package:skripsi_dashcam_app/core/error/failures.dart';
import 'package:skripsi_dashcam_app/features/album/data/params/video_params.dart';
import 'package:skripsi_dashcam_app/features/album/domain/entities/video_list_entity.dart';

abstract class AlbumRepository {
  Future<Either<Failure, VideoListEntity>> getVideoList();
  Future<Either<Failure, Stream<int>>> downloadVideo(VideoParams params);
  Future<Either<Failure, Uri>> playVideo(VideoParams params);
}
