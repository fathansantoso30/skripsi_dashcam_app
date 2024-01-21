import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:skripsi_dashcam_app/features/live_stream/domain/usecases/close_live_stream_data_usecase.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_live_stream_data_usecase.dart';

part 'live_stream_state.dart';

class LiveStreamCubit extends Cubit<LiveStreamState> {
  GetLiveStreamDataUseCase getLiveStreamDataUseCase;
  CloseLiveStreamDataUseCase closeLiveStreamDataUseCase;
  // StreamSubscription? _streamSubscription;
  Stream? broadcastStream;
  ScreenshotController screenshotController = ScreenshotController();

  LiveStreamCubit({
    required this.getLiveStreamDataUseCase,
    required this.closeLiveStreamDataUseCase,
  }) : super(LiveStreamInitial());

  // method for calling getLiveStreamData
  Future<void> getLiveStreamData() async {
    emit(LiveStreamLoading());
    try {
      final result = await getLiveStreamDataUseCase.call(const NoParams());
      result.fold((left) {
        emit(
          LiveStreamError(
              message:
                  "$runtimeType Error on try when getLiveStreamData on left - ${left.props}"),
        );
      }, (right) {
        broadcastStream = right.dataStream?.stream.asBroadcastStream();
        log("$runtimeType Success getLiveStreamData on right");
        emit(LiveStreamLoaded());
      });
    } catch (e) {
      emit(LiveStreamError(
          message:
              "$runtimeType Error on Exception when getLiveStreamData on catch - $e"));
    }
  }

  Future<void> disconnectLiveStreamData() async {
    emit(LiveStreamDisconnected());
    try {
      await closeLiveStreamDataUseCase.call(const NoParams());
    } catch (e) {
      emit(LiveStreamError(
          message:
              "$runtimeType Error on Exception when closeLiveStreamData on catch - $e"));
    }
  }

  Future<void> saveScreenshot() async {
    try {
      final String imageName =
          DateFormat('dMMMyyyyHHmmss').format(DateTime.now());
      final image = await screenshotController.capture();
      final result = await ImageGallerySaver.saveImage(image!, name: imageName);
      log('Screenshot saved to gallery: $result');
      Fluttertoast.showToast(
        msg: "Screenshot saved in Gallery",
        toastLength: Toast.LENGTH_SHORT, //duration
        gravity: ToastGravity.BOTTOM, //location
      );
    } catch (e) {
      log('Error saving screenshot: $e');
      Fluttertoast.showToast(
        msg: "Error saving screenshot: $e",
        toastLength: Toast.LENGTH_SHORT, //duration
        gravity: ToastGravity.BOTTOM, //location
      );
    }
  }
}
