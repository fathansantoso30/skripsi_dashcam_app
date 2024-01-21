import 'dart:developer';

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/live_stream_entity.dart';
import '../../domain/repositories/live_stream_repository.dart';
import '../datasources/remote/live_stream_remote_data_source.dart';
import '../mappers/live_stream_mapper.dart';

class LiveStreamRepositoryImpl implements LiveStreamRepository {
  final LiveStreamRemoteDataSource remoteDataSource;

  LiveStreamRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, LiveStreamEntity>> getLiveStreamData() async {
    try {
      final result = await remoteDataSource.getLiveStreamData();
      return Right(
        LiveStreamMapper.mapLiveStreamDTO(result),
      );
    } on ServerException {
      return Left(
        ServerFailure(),
      );
    }
  }

  @override
  Future<Either<Failure, void>> closeLiveStreamData() async {
    try {
      final result = remoteDataSource.closeLiveStreamData();
      return Right(result);
    } catch (e) {
      log('$e');
      throw UnimplementedError();
    }
  }
}
