import 'dart:io';
import 'package:flutter/material.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/image_zooming.dart';
import 'package:screenshot/screenshot.dart';

class RepostSinglePrevews extends StatefulWidget {
  String images;
  String title;
  String desc;
  String deal;

  RepostSinglePrevews({
    Key? key,
    required this.images,
    required this.title,
    required this.desc,
    required this.deal,
  }) : super(key: key);

  @override
  State<RepostSinglePrevews> createState() => _RepostSinglePrevews();
}

class _RepostSinglePrevews extends State<RepostSinglePrevews> {
  late String images;
  late String title;
  late String desc;

  @override
  void initState() {
    images = widget.images;
    title = widget.title.toUpperCase();
    desc = widget.desc;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return actionBarTopBottomView(
      "Deal " + widget.deal,
      context,
      Scaffold(
        body: Container(
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Screenshot(
                controller: screenshotController,
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          child: Container(
                            height: 250,
                            color: Colors.white,
                            child: images.contains("http")
                                ? Image.network(
                                    images,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;

                                          return Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  "assets/loading.gif",
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        "assets/logo_with_name1.png",
                                      );
                                    },
                                  )
                                : Image.file(
                                    File(images.toString()),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ZoomingImages(title: title, image: images),
                              ),
                            );
                          },
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          alignment: Alignment.topLeft,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              title.toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: app_theam, width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          alignment: Alignment.topLeft,
                          child: Text(
                            desc,
                            textScaleFactor: 1,
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  var Uint8List = null;
  late ScreenshotController screenshotController = ScreenshotController();
}
