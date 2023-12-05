import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:skripsi_dashcam_app/features/album/presentation/cubit/album_cubit.dart';
import 'package:skripsi_dashcam_app/features/album/presentation/pages/widgets/video_player_view.dart';
import 'package:skripsi_dashcam_app/utils/colors/common_colors.dart';
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
    // TODO: take thumbnail from video asset
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: albumCubit,
      // create: (context) => albumCubit,
      child: SafeArea(
          minimum: const EdgeInsets.all(12),
          //TODO: Make scrollable
          child: BlocConsumer<AlbumCubit, AlbumState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return ListView.builder(
                  itemCount: albumCubit.videoListEntity?.videos?.length,
                  itemBuilder: (context, index) {
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
                                    : albumCubit.videoListEntity?.videos?[index]
                                        .formattedDate,
                          ),
                          _buildCardVideo(
                            filename: albumCubit
                                .videoListEntity?.videos?[index].filename,
                            duration: albumCubit
                                .videoListEntity?.videos?[index].duration,
                            hourTime: albumCubit
                                .videoListEntity?.videos?[index].hourTime,
                          ),
                        ],
                      );
                    } else {
                      // Display only the item card if the date is the same
                      return _buildCardVideo(
                        filename:
                            albumCubit.videoListEntity?.videos?[index].filename,
                        duration:
                            albumCubit.videoListEntity?.videos?[index].duration,
                        hourTime:
                            albumCubit.videoListEntity?.videos?[index].hourTime,
                      );
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
    required String? duration,
    required String? hourTime,
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
              GestureDetector(
                onTap: () {
                  //TODO
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const VideoPlayerView()),
                  );
                },
                child: Container(
                  width: 120,
                  height: 90,
                  color: Colors.black,
                  child: Stack(
                    children: [
                      //TODO: Add image previews or thumbnail
                      Center(child: CommonIcons.play),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 4,
                            bottom: 2,
                          ),
                          child: Text(
                            duration ?? '',
                            style: bodyXSregular.copyWith(
                              color: CommonColors.themeGreysMainSurface,
                            ),
                          ),
                        ),
                      )
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
                    // crossAxisAlignment: CrossAxisAlignment.start,
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
            //TODO: Add ontap function on share icon
            child: GestureDetector(
                onTap: () {
                  //TODO
                },
                child: CommonIcons.share),
          )
        ],
      ),
    );
  }
}
