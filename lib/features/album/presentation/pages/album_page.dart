import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:skripsi_dashcam_app/features/album/presentation/cubit/album_cubit.dart';
import 'package:skripsi_dashcam_app/features/album/presentation/pages/widgets/video_player_view.dart';
import 'package:skripsi_dashcam_app/utils/icons/common_icons.dart';
import 'package:skripsi_dashcam_app/utils/text_style/common_text_style.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({super.key});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  late AlbumCubit albumCubit;
  @override
  void initState() {
    albumCubit = GetIt.instance<AlbumCubit>();
    albumCubit.getVideoList();
    albumCubit.getCurrentDate();
    super.initState();
  }

  @override
  void dispose() {
    albumCubit.videoPath.clear();
    albumCubit.thumbnailFile.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: albumCubit,
      child: SafeArea(
          minimum: const EdgeInsets.all(12),
          //TODO: Make scrollable
          child: BlocConsumer<AlbumCubit, AlbumState>(
            listener: (context, state) {
              //TODO: make realtime progress dialog widget based on state.progress value
            },
            builder: (context, state) {
              return ListView.builder(
                  itemCount: albumCubit.videoListEntity?.videos?.length,
                  itemBuilder: (context, index) {
                    if (state is AlbumLoaded) {
                      albumCubit.videoListEntity?.videos?.forEach((element) {
                        albumCubit.getPlayVideo(element.videoPath);
                      });
                    }

                    if (albumCubit.videoListEntity?.videos?.length ==
                            albumCubit.videoPath.length &&
                        state is PlayVideoLoaded) {
                      albumCubit.getThumbnailVideo();
                    }
                    if (state is ThumbnailLoaded) {
                      albumCubit.emitAllCompleted();
                    }
                    if (state is AllDataCompleted) {
                      print(albumCubit.videoPath);

                      if (index == 0 ||
                          albumCubit.videoListEntity?.videos?[index]
                                  .formattedDate !=
                              albumCubit.videoListEntity?.videos?[index - 1]
                                  .formattedDate) {
                        // Display date header if it's the first item or the date changes

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDate(
                              creationDate: albumCubit.videoListEntity
                                          ?.videos?[index].formattedDate ==
                                      albumCubit.todayDate
                                  ? 'Today'
                                  : albumCubit.videoListEntity?.videos?[index]
                                              .formattedDate ==
                                          albumCubit.yesterdayDate
                                      ? 'Yesterday'
                                      : albumCubit.videoListEntity
                                          ?.videos?[index].formattedDate,
                            ),
                            _buildCardVideo(
                              filename: albumCubit
                                  .videoListEntity?.videos?[index].filename,
                              hourTime: albumCubit
                                  .videoListEntity?.videos?[index].hourTime,
                              videoPath: albumCubit.videoPath[index],
                              downloadFunction: () {
                                albumCubit.getDownloadVideo(
                                    filePath: albumCubit.videoListEntity
                                        ?.videos?[index].videoPath,
                                    fileName: albumCubit.videoListEntity
                                        ?.videos?[index].filename);
                              },
                              thumbnailPath:
                                  albumCubit.thumbnailFile[index].path,
                            ),
                          ],
                        );
                      } else {
                        // Display only the item card if the date is the same
                        return _buildCardVideo(
                          filename: albumCubit
                              .videoListEntity?.videos?[index].filename,
                          hourTime: albumCubit
                              .videoListEntity?.videos?[index].hourTime,
                          videoPath: albumCubit.videoPath[index],
                          downloadFunction: () {
                            albumCubit.getDownloadVideo(
                                filePath: albumCubit
                                    .videoListEntity?.videos?[index].videoPath,
                                fileName: albumCubit
                                    .videoListEntity?.videos?[index].filename);
                          },
                          thumbnailPath: albumCubit.thumbnailFile[index].path,
                        );
                      }
                    }
                  });
            },
          )),
    );
  }

  Widget _buildDate({required String? creationDate}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 12,
      ),
      child: Text(
        creationDate ?? '',
        style: bodyLmedium,
      ),
    );
  }

  Widget _buildCardVideo({
    required String? filename,
    required String? hourTime,
    required Uri? videoPath,
    required VoidCallback downloadFunction,
    required String? thumbnailPath,
  }) {
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (videoPath != null)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VideoPlayerView(
                                videoPath: videoPath,
                              )),
                    );
                  },
                  child: Container(
                    width: 120,
                    height: 90,
                    color: Colors.black,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(File(thumbnailPath!), fit: BoxFit.fitHeight),
                        Center(child: CommonIcons.play),
                      ],
                    ),
                  ),
                ),
              const SizedBox(
                width: 24,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    filename ?? '',
                    style: bodySregular,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 2, 2, 0),
                        child: CommonIcons.time,
                      ),
                      Text(
                        hourTime ?? '',
                        style: bodySmedium,
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
          Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: downloadFunction,
                child: CommonIcons.download,
              ))
        ],
      ),
    );
  }
}
