part of 'live_stream_cubit.dart';

abstract class LiveStreamState extends Equatable {
  const LiveStreamState();

  @override
  List<Object> get props => [];
}

class LiveStreamInitial extends LiveStreamState {}

class LiveStreamLoading extends LiveStreamState {}

class LiveStreamLoaded extends LiveStreamState {
  final LiveStreamEntity liveStream;

  const LiveStreamLoaded({required this.liveStream}) : super();
}

class LiveStreamTest extends LiveStreamState {
  // ignore: prefer_typing_uninitialized_variables
  final streamTest;

  // ignore: prefer_const_constructors_in_immutables
  LiveStreamTest({this.streamTest});
}

class LiveStreamDisconnected extends LiveStreamState {}

class LiveStreamError extends LiveStreamState {
  final String message;

  const LiveStreamError({required this.message}) : super();
}
