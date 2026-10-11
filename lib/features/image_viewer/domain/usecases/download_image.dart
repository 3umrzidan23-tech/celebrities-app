import 'package:dio/dio.dart';
import 'image_downloader_stub.dart'
    if (dart.library.io) 'image_downloader_io.dart'
    if (dart.library.html) 'image_downloader_web.dart';

class DownloadImage {
  final Dio dio;

  DownloadImage(this.dio);

  Future<bool> call(String url) async {
    try {
      final response = await dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.statusCode == 200 && response.data != null) {
        return await saveImageBytes(List<int>.from(response.data));
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
