import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;

class ImageUtility {
  static Future<XFile?> compressImage(File inputFile) async {
    try {
      final filePath = inputFile.absolute.path;

      print(">>>>>>>> Size before compression: " +
          (await getFileSizeInMB(filePath)).toString() +
          " MBs");

      // Create output file path
      var baseName = path.basename(filePath);
      var extension = path.extension(filePath);
      final outPath =
          "${filePath.replaceAll(baseName, '')}_out_${baseName.replaceAll(extension, '.webp')}";
      var result = await FlutterImageCompress.compressAndGetFile(
        inputFile.absolute.path,
        outPath,
        quality: 1,
        format: CompressFormat.webp,
      );

      print(">>>>>>>>>> Size after compression: " +
          (await getFileSizeInMB(result!.path)).toString() +
          " MBs");

      return result;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<int> getFileSize(String filePath) async {
    File file = File(filePath);
    int size = await file.length();
    return size; // Size in bytes
  }

  static Future<double> getFileSizeInMB(String filePath) async {
    File file = File(filePath);
    int sizeInBytes = await file.length();
    double sizeInMB = sizeInBytes / (1024 * 1024); // Convert bytes to MB
    return sizeInMB;
  }
}
