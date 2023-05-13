import 'package:get_it/get_it.dart';

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
    ),
  );

  // usecase
  sl.registerLazySingleton<GetLiveStreamDataUseCase>(
    () => GetLiveStreamDataUseCase(
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
