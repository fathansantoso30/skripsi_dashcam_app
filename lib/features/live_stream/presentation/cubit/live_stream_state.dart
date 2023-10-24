part of 'live_stream_cubit.dart';

abstract class LiveStreamState extends Equatable {
  const LiveStreamState();

  @override
  List<Object> get props => [];
}

class LiveStreamInitial extends LiveStreamState {}

class LiveStreamLoading extends LiveStreamState {}

class LiveStreamLoaded extends LiveStreamState {}

class LiveStreamDisconnected extends LiveStreamState {}

class LiveStreamError extends LiveStreamState {
  final String message;

  const LiveStreamError({required this.message}) : super();
}
