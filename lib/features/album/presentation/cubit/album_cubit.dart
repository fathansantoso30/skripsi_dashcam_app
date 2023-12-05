import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:skripsi_dashcam_app/core/usecases/usecase.dart';
import 'package:skripsi_dashcam_app/features/album/domain/entities/video_list_entity.dart';
import 'package:skripsi_dashcam_app/features/album/domain/usecases/get_video_list_usecase.dart';

part 'album_state.dart';

class AlbumCubit extends Cubit<AlbumState> {
  GetVideoListUseCase getVideoListUseCase;

  AlbumCubit({required this.getVideoListUseCase}) : super(AlbumInitial());

  VideoListEntity? videoListEntity;
  DateTime? now;
  String? todayDate;
  String? yesterdayDate;

  Future<void> getVideoList() async {
    emit(AlbumLoading());
    try {
      final result = await getVideoListUseCase.call(const NoParams());
      result.fold((left) {
        emit(AlbumError(
            message:
                "$runtimeType Error on try when getVideoList on left - ${left.props}"));
      }, (right) {
        log("$runtimeType Success getVideoList on right");
        //TODO: what todo with the result
        videoListEntity = right;
        emit(AlbumLoaded());
      });
    } catch (e) {
      emit(AlbumError(
          message:
              "$runtimeType Error on try when getVideoList on catch - $e}"));
    }
  }

  void getCurrentDate() {
    now = DateTime.now();
    todayDate = DateFormat('d MMM yyyy').format(now!);
    yesterdayDate = DateFormat('d MMM yyyy')
        .format(DateTime(now!.year, now!.month, now!.day - 1));
  }
}
