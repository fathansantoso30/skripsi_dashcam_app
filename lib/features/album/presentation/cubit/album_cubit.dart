import 'dart:developer';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skripsi_dashcam_app/core/usecases/usecase.dart';
import 'package:skripsi_dashcam_app/features/album/data/params/video_params.dart';
import 'package:skripsi_dashcam_app/features/album/domain/entities/video_list_entity.dart';
import 'package:skripsi_dashcam_app/features/album/domain/usecases/get_download_video_usecase.dart';
import 'package:skripsi_dashcam_app/features/album/domain/usecases/get_play_video_usecase.dart';
import 'package:skripsi_dashcam_app/features/album/domain/usecases/get_video_list_usecase.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';

part 'album_state.dart';

class AlbumCubit extends Cubit<AlbumState> {
  GetVideoListUseCase getVideoListUseCase;
  GetDownloadVideoUseCase getDownloadVideoUseCase;
  GetPlayVideoUseCase getPlayVideoUseCase;

  AlbumCubit({
    required this.getVideoListUseCase,
    required this.getDownloadVideoUseCase,
    required this.getPlayVideoUseCase,
  }) : super(AlbumInitial());

  VideoListEntity? videoListEntity;
  DateTime? now;
  String? todayDate;
  String? yesterdayDate;
  List<Uri> videoPath = [];
  List<XFile> thumbnailFile = [];

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
        videoListEntity = right;
        emit(AlbumLoaded());
      });
    } catch (e) {
      emit(AlbumError(
          message:
              "$runtimeType Error on try when getVideoList on catch - $e}"));
    }
  }

  void getDownloadVideo({
    required String? filePath,
    required String? fileName,
  }) async {
    try {
      showStartDownloadToast();
      final result = await getDownloadVideoUseCase.call(VideoParams(
        filePath: filePath ?? "",
        fileName: fileName ?? "",
      ));
      result.fold((left) {
        emit(AlbumError(
            message:
                "$runtimeType Error on try when getDownloadVideo on left - ${left.props}"));
      }, (right) async {
        log("$runtimeType Success getDownloadVideo on right");

        await for (int progress in right) {
          if (progress == 100) {
            showDoneDownloadToast();
          }
        }
      });
    } catch (e) {
      emit(AlbumError(
          message:
              "$runtimeType Error on try when getVideoList on catch - $e}"));
    }
  }

  void getPlayVideo(String? filePath) async {
    emit(PlayVideoLoading());
    try {
      final result =
          await getPlayVideoUseCase.call(VideoParams(filePath: filePath ?? ""));
      result.fold((left) {
        emit(AlbumError(
            message:
                "$runtimeType Error on try when getPlayVideo on left - ${left.props}"));
      }, (right) {
        log("$runtimeType Success getPlayVideo on right");
        videoPath.add(right);
        emit(PlayVideoLoaded());
      });
    } catch (e) {
      print(e);
    }
  }

  void getThumbnailVideo() async {
    try {
      emit(ThumbnailLoading());

      for (var video in videoPath) {
        print("check value videoPath: ${video.toString()}");
        thumbnailFile.add(await VideoThumbnail.thumbnailFile(
          video: video.toString(),
          thumbnailPath: (await getTemporaryDirectory()).path,
          imageFormat: ImageFormat.JPEG,
          maxHeight:
              120, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
          quality: 10,
        ));
      }
      print("check thumbnailFile: $thumbnailFile");
      emit(ThumbnailLoaded());
    } catch (e) {
      emit(ThumbnailError(e.toString()));
    }
  }

  void emitAllCompleted() {
    emit(AllDataCompleted());
  }

  void getCurrentDate() {
    now = DateTime.now();
    todayDate = DateFormat('d MMM yyyy').format(now!);
    yesterdayDate = DateFormat('d MMM yyyy')
        .format(DateTime(now!.year, now!.month, now!.day - 1));
  }

  void showStartDownloadToast() {
    Fluttertoast.showToast(
      msg: "Downloading File...",
      toastLength: Toast.LENGTH_SHORT, //duration
      gravity: ToastGravity.BOTTOM, //location
    );
  }

  void showDoneDownloadToast() {
    Fluttertoast.showToast(
      msg: "File Saved to Gallery",
      toastLength: Toast.LENGTH_SHORT, //duration
      gravity: ToastGravity.BOTTOM, //location
    );
  }

  Future<File> copyAssetFile(String assetFileName) async {
    Directory tempDir = await getTemporaryDirectory();
    final byteData = await rootBundle.load(assetFileName);

    File videoThumbnailFile = File("${tempDir.path}/$assetFileName")
      ..createSync(recursive: true)
      ..writeAsBytesSync(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return videoThumbnailFile;
  }
}
