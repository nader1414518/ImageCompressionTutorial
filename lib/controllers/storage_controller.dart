import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_compression/utils/image_utility.dart';

class StorageController {
  static Future<Map<String, dynamic>> uploadPhoto(
    File file,
  ) async {
    try {
      var filename =
          "${DateTime.now().toIso8601String().replaceAll(" ", "").replaceAll(":", "").replaceAll(".", "").replaceAll("T", "").replaceAll("Z", "")}.webp";

      var compressedFile = await ImageUtility.compressImage(file);

      var res = await FirebaseStorage.instance
          .ref("Photos")
          .child(
            filename,
          )
          .putFile(
            File(
              compressedFile!.path,
            ),
          );

      await FirebaseFirestore.instance.collection("Photos").add({
        "filename": filename,
        "url": await res.ref.getDownloadURL(),
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

  static Future<List<Map<String, dynamic>>> getPhotos() async {
    try {
      var res = await FirebaseFirestore.instance.collection("Photos").get();

      return res.docs
          .map(
            (doc) => {
              ...doc.data(),
              "id": doc.id,
            },
          )
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
