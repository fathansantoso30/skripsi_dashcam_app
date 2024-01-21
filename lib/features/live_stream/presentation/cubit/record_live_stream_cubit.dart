import 'dart:io';
import 'dart:typed_data';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

part 'record_live_stream_state.dart';

class RecordLiveStreamCubit extends Cubit<RecordLiveStreamState> {
  RecordLiveStreamCubit() : super(RecordLiveStreamInitial());

  static String? workPath;
  static String? appTempDir;
  bool isRecording = false;
  int frameNum = 0;

  //TODO:
  Future<void> startStopRecording() async {
    emit(RecordLiveStreamTrue());
    isRecording = !isRecording;

    if (!isRecording && frameNum > 0) {
      emit(RecordLiveStreamStopped());
      frameNum = 0;
      await _makeVideoWithFFMpeg();
      emit(RecordLiveStreamFalse());
    }
  }

  //TODO:
  Future<void> _saveToGallery(String path, String name) async {
    ImageGallerySaver.saveFile(path, name: name).then((result) {
      print("Video Save result : $result");

      final bool isSuccess = result['isSuccess'] ?? false;
      final String errorMessage = result['errorMessage'] ?? "Unknown error";

      _deleteTempDirectory();

      emit(RecordLiveStreamSaved());
      Fluttertoast.showToast(
          msg: isSuccess
              ? "Video Saved to Gallery"
              : "Video Failure: $errorMessage",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 16.0);
    });
  }

  // must be called on initState
  Future<void> getAppTempDirectory() async {
    appTempDir = '${(await getTemporaryDirectory()).path}/$workPath';
  }

  static Future<void> _deleteTempDirectory() async {
    Directory(appTempDir!).deleteSync(recursive: true);
  }

  Future<void> saveImageFileToDirectory(
      Uint8List byteData, String localName) async {
    await Directory(appTempDir!).create();
    final file = File('$appTempDir/$localName');
    await file.writeAsBytes(byteData);
    print("filePath : ${file.path}");
  }

  static String generateEncodeVideoScript(String videoCodec, String fileName) {
    String outputPath = "$appTempDir/$fileName";
    return "-hide_banner -y -i '$appTempDir/image_%d.jpg' -c:v $videoCodec -r 12 $outputPath";
  }

  Future<void> _makeVideoWithFFMpeg() async {
    final String tempVideofileName =
        "${DateFormat('dMMMyyyyHHmmss').format(DateTime.now())}.mp4";
    print(tempVideofileName);
    FFmpegKit.execute(generateEncodeVideoScript("mpeg4", tempVideofileName))
        .then((session) async {
      final returnCode = await session.getReturnCode();
      if (ReturnCode.isSuccess(returnCode)) {
        print("Video complete");

        String outputPath = "$appTempDir/$tempVideofileName";
        _saveToGallery(outputPath, tempVideofileName);
      } else if (ReturnCode.isCancel(returnCode)) {
        // CANCEL
      } else {
        // ERROR
      }
    });
  }
}
