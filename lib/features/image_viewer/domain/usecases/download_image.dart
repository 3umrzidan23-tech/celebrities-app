import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadImage {
  final Dio dio;

  DownloadImage(this.dio);

  Future<bool> call(String url) async {
    try {
      if (await Permission.storage.request().isGranted ||
          await Permission.photos.request().isGranted) {
        
        final response = await dio.get(
          url,
          options: Options(responseType: ResponseType.bytes),
        );
        
        final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 100,
          name: "image_${DateTime.now().millisecondsSinceEpoch}",
        );

        return result != null && result['isSuccess'] == true;
      }
      return false; // Permission denied
    } catch (e) {
      return false;
    }
  }
}
