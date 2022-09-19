import 'dart:convert';

import 'package:cypress/data/models/album.dart';
import 'package:cypress/data/models/photos.dart';
import 'package:dio/dio.dart';
import 'package:one_context/one_context.dart';

import '../locator/locator.dart';
import '../services/snackBar_service.dart';

const API_BASE_URL = "https://jsonplaceholder.typicode.com/";

class MakeRequest {
  // ignore: prefer_final_fields
  static Dio _dio = Dio(
    BaseOptions(baseUrl: API_BASE_URL, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    }),
  );

  static final snackBar = locator<SnackBarService>();

  static Future<dynamic> get({
    String? route,
    Map<String, dynamic>? header,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    try {
      if (token != null) {
        _dio.options.headers.addAll({"Authorization": "Bearer $token"});
      }
      Response response = await _dio.get(route!, queryParameters: query);
      OneContext.instance.hideProgressIndicator();
      if (response.statusCode.toString().startsWith('2')) {
        return response;
      } else {
        return null;
      }
    } on DioError catch (e) {
      snackBar.showSnackBar1(e.toString());

      return null;
    }
  }
}

class MakeRequestService {
  Future<List<Album>?> getAlbums() async {
    Response? response = await MakeRequest.get(route: 'albums');
    if (response != null) {
      List<Album> ab = albumFromJson(jsonEncode(response.data));
      return ab;
    } else {
      return null;
    }
  }

  Future<List<Photos>?> getPhotos(String albumId) async {
    Response? response =
        await MakeRequest.get(route: 'photos', query: {"albumId": albumId});
    if (response != null) {
      List<Photos> ab = photosFromJson(jsonEncode(response.data));
      return ab;
    } else {
      return null;
    }
  }
}
