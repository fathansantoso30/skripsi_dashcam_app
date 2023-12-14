class VideoListModel {
  List<Videos>? videos;

  VideoListModel({this.videos});

  VideoListModel.fromJson(Map<String, dynamic> json) {
    if (json['videos'] != null) {
      videos = <Videos>[];
      json['videos'].forEach((v) {
        videos!.add(Videos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (videos != null) {
      data['videos'] = videos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Videos {
  String? filename;
  String? fileSize;
  String? duration;
  String? creationDate;
  String? path;

  Videos(
      {this.filename,
      this.fileSize,
      this.duration,
      this.creationDate,
      this.path});

  Videos.fromJson(Map<String, dynamic> json) {
    filename = json['filename'];
    fileSize = json['file_size'];
    duration = json['duration'];
    creationDate = json['creation_date'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['filename'] = filename;
    data['file_size'] = fileSize;
    data['duration'] = duration;
    data['creation_date'] = creationDate;
    data['path'] = path;
    return data;
  }
}
