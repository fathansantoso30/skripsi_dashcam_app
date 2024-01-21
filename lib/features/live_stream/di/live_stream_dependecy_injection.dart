import 'package:get_it/get_it.dart';
import 'package:skripsi_dashcam_app/features/live_stream/domain/usecases/close_live_stream_data_usecase.dart';
import 'package:skripsi_dashcam_app/features/live_stream/presentation/cubit/record_live_stream_cubit.dart';

import '../data/datasources/remote/live_stream_remote_data_source.dart';
import '../data/repositories/live_stream_repository_impl.dart';
import '../domain/repositories/live_stream_repository.dart';
import '../domain/usecases/get_live_stream_data_usecase.dart';
import '../presentation/cubit/live_stream_cubit.dart';

final sl = GetIt.instance;

Future<void> initLiveStreamDI() async {
  _initLiveStreamDI();
}

void _initLiveStreamDI() {
  // cubit
  sl.registerLazySingleton(
    () => LiveStreamCubit(
      getLiveStreamDataUseCase: sl(),
      closeLiveStreamDataUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => RecordLiveStreamCubit(),
  );

  // usecase
  sl.registerLazySingleton<GetLiveStreamDataUseCase>(
    () => GetLiveStreamDataUseCase(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton<CloseLiveStreamDataUseCase>(
    () => CloseLiveStreamDataUseCase(
      repository: sl(),
    ),
  );

  // repository
  sl.registerLazySingleton<LiveStreamRepository>(
    () => LiveStreamRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // data sources
  sl.registerLazySingleton<LiveStreamRemoteDataSource>(
    () => LiveStreamRemoteDataSourceImpl(),
  );
}
