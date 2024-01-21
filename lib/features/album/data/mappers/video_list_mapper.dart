import 'package:intl/intl.dart';
import 'package:skripsi_dashcam_app/features/album/data/models/video_list_model.dart';
import 'package:skripsi_dashcam_app/features/album/domain/entities/video_list_entity.dart';

class VideoListMapper {
  const VideoListMapper();

  static VideoListEntity map(VideoListModel? dto) {
    List<VideosOE> data = [];

    dto?.data?.forEach((element) {
      String formattedFileSize = formatFileSize(element.size);
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(element.lastWrite! * 1000);
      String formattedDate = DateFormat('d MMM yyyy').format(dateTime);
      String hourTime = DateFormat.Hm().format(dateTime);

      data.add(VideosOE(
        filename: element.name,
        fileSize: formattedFileSize,
        creationDate: dateTime,
        formattedDate: formattedDate,
        hourTime: hourTime,
        videoPath: element.path,
      ));

      // Sort videos by creation date
      data.sort((a, b) => b.creationDate!.compareTo(a.creationDate!));
    });

    return VideoListEntity(videos: data);
  }

  static String formatFileSize(int? size) {
    if (size! < 1024) {
      return '$size B';
    } else if (size < 1024 * 1024) {
      double kbSize = size / 1024;
      return '${kbSize.toStringAsFixed(2)} KB';
    } else if (size < 1024 * 1024 * 1024) {
      double mbSize = size / (1024 * 1024);
      return '${mbSize.toStringAsFixed(2)} MB';
    } else {
      double gbSize = size / (1024 * 1024 * 1024);
      return '${gbSize.toStringAsFixed(2)} GB';
    }
  }
}
