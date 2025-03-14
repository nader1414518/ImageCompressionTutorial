import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageController {
  static Future<Map<String, dynamic>> uploadPhoto(
    File file,
  ) async {
    try {
      var filename =
          "${DateTime.now().toIso8601String().replaceAll(" ", "").replaceAll(":", "").replaceAll(".", "").replaceAll("T", "").replaceAll("Z", "")}.webp";

      var res = await FirebaseStorage.instance.ref("Photos").child(
            filename,
          );

      await FirebaseFirestore.instance.collection("Photos").add({
        "filename": filename,
        "url": await res.getDownloadURL(),
        "dateAdded": DateTime.now().toIso8601String(),
      });

      return {
        "result": true,
        "message": "Uploaded successfully ... ",
      };
    } catch (e) {
      print(e.toString());
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }
}
