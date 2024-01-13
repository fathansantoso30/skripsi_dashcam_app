import 'package:get_it/get_it.dart';
import 'package:skripsi_dashcam_app/features/home/presentation/cubit/connectivity_cubit.dart';
import 'package:skripsi_dashcam_app/features/home/presentation/cubit/navbar_cubit.dart';

final sl = GetIt.instance;

Future<void> initHomeDI() async {
  _initHomeDI();
}

void _initHomeDI() {
  // cubit
  sl.registerLazySingleton(() => NavbarCubit());

  sl.registerLazySingleton(() => ConnectivityCubit());
}
