import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/live_stream_entity.dart';
import '../../domain/usecases/get_live_stream_data_usecase.dart';

part 'live_stream_state.dart';

class LiveStreamCubit extends Cubit<LiveStreamState> {
  GetLiveStreamDataUseCase getLiveStreamDataUseCase;
  // StreamSubscription? _streamSubscription;
  Stream? broadcastStream;

  LiveStreamCubit({
    required this.getLiveStreamDataUseCase,
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
        log("$runtimeType Success getLiveStreamData on right");
        // TODO: fix streamsubscription not implemented correctly

        broadcastStream = right.dataStream?.stream.asBroadcastStream();
        // _streamSubscription = broadcastStream?.listen(
        //   (event) {},
        //   onDone: () => debugPrint('Stream closed successfully'),
        // );
        emit(LiveStreamLoaded());
        // emit(LiveStreamLoaded(liveStream: right));
      });
    } catch (e) {
      emit(LiveStreamError(
          message:
              "$runtimeType Error on Exception when getLiveStreamData on catch - $e"));
    }
  }

  void disconnectLiveStreamData() {
    // _streamSubscription?.cancel();
    // TODO: make sure the stream is closed
    // The connection is still alive but because the cubit emit LiveStreamDisconnected state
    // when this method called, the screen did changed like its disconnected but its not

    // liveStreamEntity?.dataStream?.sink.close();
    emit(LiveStreamDisconnected());
  }
}
