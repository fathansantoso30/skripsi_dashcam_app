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
