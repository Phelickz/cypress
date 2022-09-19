import 'package:cypress/data/api/api.dart';
import 'package:cypress/data/models/photos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/models/album.dart';

part 'album_state.dart';

const String albumBox = 'albumBox';
const String photoBox = 'photoBox';
const String appHiveKey = 'state';

class AlbumCubit extends Cubit<AlbumState> {
  AlbumCubit() : super(AlbumInitial());

  void getAlbumsFromStorage() async {
    try {
      emit(AlbumGetAllLoading());
      var data = Hive.box<Album>(albumBox);
      List<Album>? d = data.values.toList();
      if (d.isEmpty) {
        getAlbums();
      } else {
        emit(AlbumGetAllSuccess(d));
      }
    } catch (e) {
      emit(AlbumGetAllError(
          "We encountered some error while fetching the data."));
    }
  }

  void getAlbums() async {
    try {
      emit(AlbumGetAllLoading());
      List<Album>? d = await MakeRequestService().getAlbums();
      if (d != null) {
        await saveAlbums(d);
        emit(AlbumGetAllSuccess(d));
      } else {
        emit(AlbumGetAllError(
            "We encountered some error while fetching the data."));
      }
    } catch (e) {
      emit(AlbumGetAllError(
          "We encountered some error while fetching the data."));
    }
  }

  Future<void> saveAlbums(List<Album> ab) async {
    var data = Hive.box<Album>(albumBox);
    await data.addAll(ab);
  }

  Future<void> savePhotos(List<Photos> ph) async {
    var data = Hive.box<Photos>(photoBox);
    await data.addAll(ph);
  }

  void getPhotosFromStorage(List<Album> ab) async {
    try {
      emit(AlbumGetAllLoading());
      var data = Hive.box<Photos>(photoBox);
      List<Photos>? d = data.values.toList();
      if (d.isEmpty) {
        getPhotos(ab);
      } else {
        emit(AlbumGetAllPhotosSuccess(d, ab));
      }
    } catch (e) {
      emit(AlbumGetAllError(
          "We encountered some error while fetching the data."));
    }
  }

  void getPhotos(List<Album> ab) async {
    try {
      List<Photos> allPhotos = [];
      emit(AlbumGetAllPhotosLoading());
      for (Album album in ab.take(20)) {
        List<Photos>? d =
            await MakeRequestService().getPhotos((album.id ?? 0).toString());
        if (d != null) {
          allPhotos.addAll(d);
        }
      }
      if (allPhotos.isNotEmpty) {
        await savePhotos(allPhotos);
        emit(AlbumGetAllPhotosSuccess(allPhotos, ab));
      } else {
        emit(AlbumGetAllPhotosError(
            "We encountered some error while fetching the data."));
      }
    } catch (e) {
      emit(AlbumGetAllPhotosError(
          "We encountered some error while fetching the data."));
    }
  }
}
