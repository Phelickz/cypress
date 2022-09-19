import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/album.dart';
import '../../data/models/photos.dart';

part 'album_event.dart';
part 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  AlbumBloc() : super(AlbumInitial()) {
    on<AlbumEvent>((event, emit) {});
  }
}
