class VideoListModel {
  List<Data>? data;

  VideoListModel({this.data});

  VideoListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? name;
  String? path;
  int? size;
  int? lastWrite;

  Data({this.name, this.path, this.size, this.lastWrite});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    path = json['path'];
    size = json['size'];
    lastWrite = json['lastWrite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['path'] = path;
    data['size'] = size;
    data['lastWrite'] = lastWrite;
    return data;
  }
}
