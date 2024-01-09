import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skripsi_dashcam_app/features/album/data/models/video_list_model.dart';
import 'package:skripsi_dashcam_app/features/album/data/params/video_params.dart';

abstract class AlbumRemoteDataSource {
  Future<VideoListModel> getVideoList();
  Future<Stream<int>> downloadVideo(VideoParams params);
  Uri playVideo(VideoParams params);
}

class AlbumRemoteDataSourceImpl implements AlbumRemoteDataSource {
  final String baseUrl = 'http://192.168.4.1';

  @override
  Future<VideoListModel> getVideoList() async {
    var response = await http.get(Uri.parse('$baseUrl/videos'));
    debugPrint('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = await json.decode(response.body);
      VideoListModel videoListModel = VideoListModel.fromJson(data);
      return videoListModel;
    } else {
      debugPrint('Error: ${response.statusCode}');
      throw Exception('Failed to load video list');
    }
  }

  @override
  Future<Stream<int>> downloadVideo(VideoParams params) async {
    const String downloadEndpoint = '/download';

    // Combine the base URL, endpoint, and file parameter
    final Uri uri =
        Uri.parse('$baseUrl$downloadEndpoint?file=${params.filePath}');
    // Create an HTTP client
    var httpClient = http.Client();

    // Create an HTTP request with the provided URL
    var request = http.Request('GET', uri);

    // Send the HTTP request and get the response
    var response = httpClient.send(request);

    // Get the application documents directory
    String? dir = (await getTemporaryDirectory()).path;

    // Save the file
    File file = File('$dir/${params.fileName}');

    // List to store file chunks
    List<List<int>> chunks = List.empty(growable: true);

    // Variable to track the downloaded bytes
    int downloaded = 0;

    final controller = StreamController<int>();

    // Listen to the stream of the HTTP response
    response.asStream().listen((http.StreamedResponse r) {
      // Get the content length, handling the nullable value
      final contentLength = r.contentLength ?? 0;
      // Listen to the stream of chunks in the response
      r.stream.listen((List<int> chunk) {
        // Display the percentage of completion
        debugPrint('downloadPercentage: ${downloaded / contentLength * 100}');

        // Add the chunk to the list
        chunks.add(chunk);
        downloaded += chunk.length;

        // Emit the progress percentage to the stream
        controller.add(((downloaded / contentLength) * 100).toInt());
      }, onDone: () async {
        // Display the final percentage of completion
        debugPrint('downloadPercentage: ${downloaded / contentLength * 100}');

        // Complete the stream with the final progress percentage
        controller.add(((downloaded / contentLength) * 100).toInt());
        controller.close();

        final Uint8List bytes = Uint8List(contentLength);
        int offset = 0;

        // Merge chunks into a single byte array
        for (List<int> chunk in chunks) {
          bytes.setRange(offset, offset + chunk.length, chunk);
          offset += chunk.length;
        }

        // Write the byte array to the file
        await file.writeAsBytes(bytes);

        final galleryFile = await ImageGallerySaver.saveFile(file.path);
        debugPrint('Temp File Path: ${file.path}');
        debugPrint('Gallery File Path: $galleryFile');

        return;
      });
    });

    // Return the stream controller's stream as a Future
    return controller.stream;
  }

  @override
  Uri playVideo(VideoParams params) {
    const String downloadEndpoint = '/play';

    // Combine the base URL, endpoint, and file parameter
    final Uri uri =
        Uri.parse('$baseUrl$downloadEndpoint?file=${params.filePath}');
    return uri;
  }
}
