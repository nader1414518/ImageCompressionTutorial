import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;

class ImageUtility {
  static Future<XFile?> compressImage(File inputFile) async {
    try {
      final filePath = inputFile.absolute.path;

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

      return result;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
