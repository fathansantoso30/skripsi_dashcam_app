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
      // String formattedDuration = formatDuration(element.duration ?? '');

      data.add(VideosOE(
        filename: element.name,
        fileSize: formattedFileSize,
        // duration: formattedDuration,
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
    // int size = int.parse(fileSize);

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

  // TODO: Get Duration of video using ffmpeg maybe
  static String formatDuration(String duration) {
    List<String> parts = duration.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);

    String formattedDuration = '';

    if (hours > 0) {
      formattedDuration += '${hours}h ';
    }

    if (minutes > 0) {
      formattedDuration += '${minutes}m ';
    }

    if (seconds > 0) {
      formattedDuration += '${seconds}s';
    }

    return formattedDuration
        .trim(); // Remove trailing space if there are no seconds
  }
}
