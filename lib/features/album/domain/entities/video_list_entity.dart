class VideoListEntity {
  final List<VideosOE>? videos;

  VideoListEntity({this.videos});
}

class VideosOE {
  String? filename;
  String? fileSize;
  String? duration;
  DateTime? creationDate;
  String? formattedDate;
  String? hourTime;
  String? videoPath;

  VideosOE({
    this.filename,
    this.fileSize,
    this.duration,
    this.creationDate,
    this.formattedDate,
    this.hourTime,
    this.videoPath,
  });
}
