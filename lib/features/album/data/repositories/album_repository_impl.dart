import 'dart:developer';

import 'package:dartz/dartz.dart';

import 'package:skripsi_dashcam_app/features/album/data/datasources/remote/album_remote_data_source.dart';
import 'package:skripsi_dashcam_app/features/album/data/mappers/video_list_mapper.dart';
import 'package:skripsi_dashcam_app/features/album/data/params/video_params.dart';
import 'package:skripsi_dashcam_app/features/album/domain/entities/video_list_entity.dart';
import 'package:skripsi_dashcam_app/features/album/domain/repositories/album_repository.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';

class AlbumRepositoryImpl implements AlbumRepository {
  final AlbumRemoteDataSource albumRemoteDataSource;

  AlbumRepositoryImpl({
    required this.albumRemoteDataSource,
  });

  @override
  Future<Either<Failure, VideoListEntity>> getVideoList() async {
    try {
      final result = await albumRemoteDataSource.getVideoList();
      return Right(
        VideoListMapper.map(result),
      );
    } on ServerException {
      return Left(
        ServerFailure(),
      );
    }
  }

  @override
  Future<Either<Failure, Stream<int>>> downloadVideo(VideoParams params) async {
    try {
      final result = await albumRemoteDataSource.downloadVideo(params);
      return Right(result);
    } on ServerException {
      return Left(
        ServerFailure(),
      );
    }
  }

  @override
  Future<Either<Failure, Uri>> playVideo(VideoParams params) async {
    try {
      final result = albumRemoteDataSource.playVideo(params);
      return Right(result);
    } catch (e) {
      log('$e');
    }
    throw UnimplementedError();
  }
}
