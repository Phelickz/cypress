import 'package:cached_network_image/cached_network_image.dart';
import 'package:cypress/bloc/cubit/album_cubit.dart';
import 'package:cypress/data/locator/locator.dart';
import 'package:cypress/data/models/photos.dart';
import 'package:cypress/data/services/snackBar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_listview/infinite_listview.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../data/models/album.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final InfiniteScrollController _infiniteController = InfiniteScrollController(
    initialScrollOffset: 0.0,
  );
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      BlocProvider.of<AlbumCubit>(context).getAlbumsFromStorage();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: BlocConsumer(
          bloc: BlocProvider.of<AlbumCubit>(context),
          builder: (_, AlbumState state) {
            if (state is AlbumGetAllPhotosSuccess) {
              List<Album> ab = state.albums.take(20).toList();
              List<Photos> ph = state.photos;
              return InfiniteListView.builder(
                  // itemCount: ab.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final i = index % ab.length;
                    return SizedBox(
                      height: 220,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            ab[i].title ?? "",
                            style: GoogleFonts.epilogue(
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 150,
                            width: double.infinity,
                            // width: MediaQuery.of(context).size.width,

                            child: InfiniteListView.builder(
                              controller: _infiniteController,
                              itemCount: ph.length,
                              scrollDirection: Axis.horizontal,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final ii = index % ph.length;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: SizedBox(
                                    height: 100,
                                    width: 150,
                                    child: ph[ii].url != null
                                        ? CachedNetworkImage(
                                            imageUrl: ph[ii].url!,
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                Center(
                                              child: CircularProgressIndicator(
                                                  value: downloadProgress
                                                      .progress),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          )
                                        : Container(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const Divider(
                            color: Colors.black54,
                          )
                        ],
                      ),
                    );
                  }
                  // separatorBuilder: (context, index) {
                  //   return Divider();
                  // },
                  );
            } else {
              return Container();
            }
          },
          listener: (context, AlbumState state) {
            if (state is AlbumGetAllLoading ||
                state is AlbumGetAllPhotosLoading) {
              context.loaderOverlay.show();
            }

            if (state is AlbumGetAllSuccess) {
              context.loaderOverlay.hide();
              BlocProvider.of<AlbumCubit>(context)
                  .getPhotosFromStorage(state.albums);
            }

            if (state is AlbumGetAllPhotosSuccess) {
              context.loaderOverlay.hide();
            }

            if (state is AlbumGetAllPhotosError || state is AlbumGetAllError) {
              context.loaderOverlay.hide();
              locator<SnackBarService>().showSnackBar1("Some error occurred");
            }
          },
        ),
      ),
    );
  }
}
