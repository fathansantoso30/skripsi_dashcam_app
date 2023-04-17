import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:skripsi_dashcam_app/injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();
