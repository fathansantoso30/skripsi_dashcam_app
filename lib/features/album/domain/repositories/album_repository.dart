import 'package:dartz/dartz.dart';
import 'package:skripsi_dashcam_app/core/error/failures.dart';
import 'package:skripsi_dashcam_app/features/album/domain/entities/video_list_entity.dart';

abstract class AlbumRepository {
  Future<Either<Failure, VideoListEntity>> getVideoList();
}
