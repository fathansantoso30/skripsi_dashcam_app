import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:skripsi_dashcam_app/features/album/data/models/video_list_model.dart';

abstract class AlbumLocalDataSource {
  Future<VideoListModel> getVideoList();
}

class AlbumLocalDataSourceImpl implements AlbumLocalDataSource {
  @override
  Future<VideoListModel> getVideoList() async {
    var response =
        await rootBundle.loadString('assets/json/get_video_list.json');
    final Map<String, dynamic> data = await json.decode(response);
    VideoListModel videoListModel = VideoListModel.fromJson(data);
    return videoListModel;
  }
}
