import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
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
        
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/image_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await file.writeAsBytes(response.data);
        
        await Gal.putImage(file.path);
        
        return true;
      }
      return false; // Permission denied
    } catch (e) {
      return false;
    }
  }
}
