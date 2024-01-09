part of 'album_cubit.dart';

abstract class AlbumState extends Equatable {
  const AlbumState();

  @override
  List<Object> get props => [];
}

class AlbumInitial extends AlbumState {}

class AlbumLoading extends AlbumState {}

class AlbumLoaded extends AlbumState {}

class AlbumDisconnected extends AlbumState {}

class AlbumError extends AlbumState {
  final String message;

  const AlbumError({required this.message}) : super();
}

class ThumbnailLoading extends AlbumState {}

class ThumbnailLoaded extends AlbumState {
  // final XFile? thumbnailFile;
  // // final XFile? thumbnailUrl;

  // const ThumbnailLoaded({
  //   this.thumbnailFile,
  // });
}

class ThumbnailError extends AlbumState {
  final String error;

  const ThumbnailError(this.error);
}

class DownloadStart extends AlbumState {}

class DownloadProgress extends AlbumState {
  final int progress;

  const DownloadProgress(this.progress);
}

class DownloadDone extends AlbumState {}

class PlayVideoLoading extends AlbumState {}

class PlayVideoLoaded extends AlbumState {}

class AllDataCompleted extends AlbumState {}
