import 'dart:io';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> saveImageBytes(List<int> bytes) async {
  try {
    if (await Permission.storage.request().isGranted ||
        await Permission.photos.request().isGranted) {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/image_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await file.writeAsBytes(bytes);
      await Gal.putImage(file.path);
      return true;
    }
    return false;
  } catch (e) {
    return false;
  }
}
