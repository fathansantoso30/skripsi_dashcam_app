import 'package:get_it/get_it.dart';
import 'package:skripsi_dashcam_app/features/album/data/datasources/remote/album_remote_data_source.dart';
// import 'package:skripsi_dashcam_app/features/album/data/datasources/local/album_local_data_source.dart';
import 'package:skripsi_dashcam_app/features/album/data/repositories/album_repository_impl.dart';
import 'package:skripsi_dashcam_app/features/album/domain/repositories/album_repository.dart';
import 'package:skripsi_dashcam_app/features/album/domain/usecases/get_download_video_usecase.dart';
import 'package:skripsi_dashcam_app/features/album/domain/usecases/get_play_video_usecase.dart';
import 'package:skripsi_dashcam_app/features/album/domain/usecases/get_video_list_usecase.dart';
import 'package:skripsi_dashcam_app/features/album/presentation/cubit/album_cubit.dart';

final sl = GetIt.instance;

Future<void> initAlbumDI() async {
  _initAlbumDI();
}

void _initAlbumDI() {
  // cubit
  sl.registerLazySingleton(
    () => AlbumCubit(
      getVideoListUseCase: sl(),
      getDownloadVideoUseCase: sl(),
      getPlayVideoUseCase: sl(),
    ),
  );

  // usecase
  sl.registerLazySingleton<GetVideoListUseCase>(
    () => GetVideoListUseCase(
      albumRepository: sl(),
    ),
  );

  sl.registerLazySingleton<GetDownloadVideoUseCase>(
    () => GetDownloadVideoUseCase(
      albumRepository: sl(),
    ),
  );

  sl.registerLazySingleton<GetPlayVideoUseCase>(
    () => GetPlayVideoUseCase(
      albumRepository: sl(),
    ),
  );

  // repository
  sl.registerLazySingleton<AlbumRepository>(
    () => AlbumRepositoryImpl(
      albumRemoteDataSource: sl(),
    ),
  );

  // data sources
  sl.registerLazySingleton<AlbumRemoteDataSource>(
    () => AlbumRemoteDataSourceImpl(),
  );
}
