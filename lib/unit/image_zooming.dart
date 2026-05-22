import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:localkart/theams_colors.dart';
import 'package:shimmer/shimmer.dart';

class ZoomingImages extends StatefulWidget {
  String title;
  String image;

  ZoomingImages({Key? key, required this.title, required this.image})
    : super(key: key);

  @override
  _ZoomingImages createState() => _ZoomingImages();
}

class _ZoomingImages extends State<ZoomingImages> {
  @override
  void initState() {
    print("testing 123");
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: InteractiveViewer(
        child: Container(
          color: Colors.white,
          height: double.infinity,
          width: double.infinity,
          child: widget.image.contains("http")
              ? Image.network(
                  widget.image,
                  // fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;

                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/loading.gif"),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset("assets/logo_with_name1.png");
                  },
                )
              : Image.file(
                  File(widget.image),
                  // fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}

Future<String> cropImage(String path) async {
  try {
    CroppedFile? croppedfile = await ImageCropper().cropImage(
      sourcePath: path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: gradint_start_color,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
      ],
    );
    if (croppedfile != null) {
      print("Cropped without file saved: " + path);
      print("Cropped file saved: " + croppedfile.path);
      return croppedfile.path;
    } else {
      print("Image is not cropped.");
      print("Cropped without file saved: " + path);
      return path;
    }
  } catch (e) {
    print("Image is not cropped. $e");
    print("Cropped without file  error path : " + path);
    return path;
  }
}

Widget eventImageLoading(imageUrl, bookingAllow) {
  return Image.network(
    imageUrl.toString(),
    fit: BoxFit.cover,

    color: bookingAllow == 0 ? Colors.grey : null,
    colorBlendMode: bookingAllow == 0 ? BlendMode.saturation : null,

    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return Container(
        height: 160,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/loading.gif"),
            fit: BoxFit.cover,
          ),
        ),
      );
    },
    errorBuilder: (context, error, stackTrace) {
      return Container(
        height: 160,
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            children: [
              Container(
                height: 160,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(10),
                  ),
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
