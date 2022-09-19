import 'dart:io';

import 'package:cypress/bloc/cubit/album_cubit.dart';
import 'package:cypress/data/models/album.dart';
import 'package:cypress/data/models/photos.dart';
import 'package:cypress/ui/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';

import 'bloc/bloc.dart';
import 'data/locator/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();

  setupLocator();

  Directory document = await getApplicationDocumentsDirectory();

  Hive
    ..init(document.path)
    ..registerAdapter(AlbumAdapter())
    ..registerAdapter(PhotosAdapter());

  await Hive.openBox<Album>(albumBox);
  await Hive.openBox<Photos>(photoBox);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cypress',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoaderOverlay(
          child: BlocProvider(
        create: (context) => AlbumCubit(),
        // child: MyHome(),
        child: const MyHomePage(title: 'Cypress'),
      )),
    );
  }
}
