class VideoParams {
  final String filePath;
  final String fileName;

  VideoParams({
    this.filePath = "",
    this.fileName = "",
  });

  Map<String, dynamic> toJson() => {
        "filePath": filePath,
        "fileName": fileName,
      };
}
