import 'package:get_it/get_it.dart';
import 'package:skripsi_dashcam_app/features/album/data/datasources/local/album_local_data_source.dart';
import 'package:skripsi_dashcam_app/features/album/data/repositories/album_repository_impl.dart';
import 'package:skripsi_dashcam_app/features/album/domain/repositories/album_repository.dart';
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
    ),
  );

  // usecase
  sl.registerLazySingleton<GetVideoListUseCase>(
    () => GetVideoListUseCase(
      albumRepository: sl(),
    ),
  );

  // repository
  sl.registerLazySingleton<AlbumRepository>(
    () => AlbumRepositoryImpl(
      albumLocalDataSource: sl(),
    ),
  );

  // data sources
  sl.registerLazySingleton<AlbumLocalDataSource>(
    () => AlbumLocalDataSourceImpl(),
  );
}
