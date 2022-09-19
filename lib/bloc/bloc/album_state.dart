part of 'album_bloc.dart';

@immutable
abstract class AlbumState {}

class AlbumInitial extends AlbumState {}

class AlbumGetAllLoading extends AlbumState {}

class AlbumGetAllSuccess extends AlbumState {
  final List<Album> albums;

  AlbumGetAllSuccess(this.albums);
}

class AlbumGetAllError extends AlbumState {
  final String message;

  AlbumGetAllError(this.message);
}

class AlbumGetAllPhotosLoading extends AlbumState {}

class AlbumGetAllPhotosSuccess extends AlbumState {
  final List<Photos> photos;
  final List<Album> albums;

  AlbumGetAllPhotosSuccess(this.photos, this.albums);
}

class AlbumGetAllPhotosError extends AlbumState {
  final String message;

  AlbumGetAllPhotosError(this.message);
}
