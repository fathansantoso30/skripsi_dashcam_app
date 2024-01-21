part of 'record_live_stream_cubit.dart';

abstract class RecordLiveStreamState extends Equatable {
  const RecordLiveStreamState();

  @override
  List<Object> get props => [];
}

class RecordLiveStreamInitial extends RecordLiveStreamState {}

class RecordLiveStreamTrue extends RecordLiveStreamState {}

class RecordLiveStreamFalse extends RecordLiveStreamState {}

class RecordLiveStreamStopped extends RecordLiveStreamState {}

class RecordLiveStreamSaved extends RecordLiveStreamState {}
