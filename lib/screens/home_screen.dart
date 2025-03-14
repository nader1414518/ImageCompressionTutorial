import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_compression/controllers/storage_controller.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;

  List<Map<String, dynamic>> photos = [];

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var res = await StorageController.getPhotos();

      setState(() {
        photos = res;
      });
    } catch (e) {
      print(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Home Screen",
        ),
        actions: [
          IconButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });

              try {
                var imagePicker = ImagePicker();

                var file = await imagePicker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 50,
                );

                if (file != null) {
                  var res = await StorageController.uploadPhoto(
                    File(
                      file.path,
                    ),
                  );

                  if (res["result"] == true) {
                    await getData();
                  } else {
                    Fluttertoast.showToast(
                      msg: res["message"].toString(),
                    );
                  }
                }
              } catch (e) {
                print(e.toString());
              }

              setState(() {
                isLoading = false;
              });
            },
            icon: const Icon(
              Icons.camera,
            ),
          ),
          IconButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });

              try {
                var imagePicker = ImagePicker();

                var file = await imagePicker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 50,
                );

                if (file != null) {
                  var res = await StorageController.uploadPhoto(
                    File(
                      file.path,
                    ),
                  );

                  if (res["result"] == true) {
                    await getData();
                  } else {
                    Fluttertoast.showToast(
                      msg: res["message"].toString(),
                    );
                  }
                }
              } catch (e) {
                print(e.toString());
              }

              setState(() {
                isLoading = false;
              });
            },
            icon: const Icon(
              Icons.photo_library_outlined,
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                ...photos.map(
                  (photo) => Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            photo["url"].toString(),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
