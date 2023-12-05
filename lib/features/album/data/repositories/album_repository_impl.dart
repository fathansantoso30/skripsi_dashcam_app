import 'package:dartz/dartz.dart';
import 'package:skripsi_dashcam_app/features/album/data/datasources/local/album_local_data_source.dart';
import 'package:skripsi_dashcam_app/features/album/data/mappers/video_list_mapper.dart';
import 'package:skripsi_dashcam_app/features/album/domain/entities/video_list_entity.dart';
import 'package:skripsi_dashcam_app/features/album/domain/repositories/album_repository.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';

class AlbumRepositoryImpl implements AlbumRepository {
  final AlbumLocalDataSource albumLocalDataSource;

  AlbumRepositoryImpl({
    required this.albumLocalDataSource,
  });

  @override
  Future<Either<Failure, VideoListEntity>> getVideoList() async {
    try {
      final result = await albumLocalDataSource.getVideoList();
      return Right(
        VideoListMapper.map(result),
      );
    } on ServerException {
      return Left(
        ServerFailure(),
      );
    }
  }
}
