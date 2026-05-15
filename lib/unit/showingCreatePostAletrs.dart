import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localkart/RoutingSetup/root_data_pass.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/image_zooming.dart';
import 'package:localkart/unit/showing.dart';

class CreatePostsAlerts extends StatefulWidget {
  int count;

  CreatePostsAlerts({Key? key, required this.count}) : super(key: key);

  @override
  _CreatePostsAlerts createState() => _CreatePostsAlerts();
}

class _CreatePostsAlerts extends State<CreatePostsAlerts> {
  int valueHolder = 30;

  var _controller_deal_title = TextEditingController();
  var _controller_deal_desc = TextEditingController();

  final ImagePicker imgpicker = ImagePicker();
  String imagepath = "";

  // late File imagefile;

  openFilePath(type) async {
    try {
      var pickedFile = null;
      if (type == 1) {
        pickedFile = await imgpicker.pickImage(source: ImageSource.gallery);
      } else {
        pickedFile = await imgpicker.pickImage(source: ImageSource.camera);
      }
      if (pickedFile != null) {
        imagepath = await cropImage(pickedFile.path);
        Navigator.pop(context, imagepath);
        setState(() {});
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }

  saveImages(croppedfile) async {
    Uint8List bytes = await croppedfile.readAsBytes();
    var result = await ImageGallerySaver.saveImage(
      bytes,
      quality: 60,
      name: "new_mage.jpg",
    );
    print(result);
    if (result["isSuccess"] == true) {
      print("Image saved successfully.");
    } else {
      print(result["errorMessage"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                margin: EdgeInsets.only(top: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Deal ${widget.count}',
                      style: TextStyle(fontSize: 17),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      child: TextField(
                        controller: _controller_deal_title,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          focusColor: Colors.grey,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(6.0),
                            ),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(6.0),
                            ),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          hintText: "Heading (Not exceeding 8 words)",
                          fillColor: Colors.grey,
                        ),
                        onChanged: (str) {
                          // To do
                        },
                        onSubmitted: (str) {
                          print("submit");
                          // To do
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      child: TextField(
                        controller: _controller_deal_desc,
                        textCapitalization: TextCapitalization.sentences,
                        textAlignVertical: TextAlignVertical.center,
                        maxLines: 6,
                        decoration: const InputDecoration(
                          focusColor: Colors.grey,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(6.0),
                            ),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(6.0),
                            ),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          hintText: "Description (Not exceeding 20 words)",
                          fillColor: Colors.grey,
                        ),
                        onChanged: (str) {
                          // To do
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      child: Container(
                        alignment: Alignment.center,
                        width: 100,
                        height: 100,
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        // child: Text("test"),
                        child: imagepath != ""
                            ? Image.file(
                                File(imagepath),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            : Center(
                                child: Container(
                                  height: 90,
                                  width: 90,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(3),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.image_sharp,
                                        color: Colors.grey,
                                        size: 50,
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "Upload Image",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());

                        showBottomSheetCustomeView(
                          context,
                          "Select Image Source",
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                                  ListTile(
                                    leading: Icon(Icons.photo_outlined),
                                    title: Text('Gallery'),
                                    onTap: () {
                                      setState(() {
                                        openFilePath(1);
                                      });
                                      // Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.camera_alt),
                                    title: Text('Camera'),
                                    onTap: () {
                                      setState(() {
                                        openFilePath(2);
                                      });

                                      // Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },

                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: gradient_btn_lift,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(5, 5),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      " Cancel",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(height: 50, width: 10),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                CreatePostMode post = CreatePostMode();

                                post.id = widget.count;
                                post.titile = _controller_deal_title.text
                                    .toString();
                                post.desc = _controller_deal_desc.text
                                    .toString();

                                post.images = imagepath.toString();

                                if (post.titile.length < 8) {
                                  ShowTost("Please enter Heading min 8 words");
                                } else if (post.desc.length < 20) {
                                  ShowTost(
                                    "Please enter description min 8 words",
                                  );
                                } else if (imagepath == "") {
                                  ShowTost("Please select image");
                                } else {
                                  Navigator.pop(context, post);
                                }
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: gradient_btn_rigth,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(5, 5),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Add",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Positioned(
              //     top: -40,
              //     child: CircleAvatar(
              //       backgroundColor: Colors.white,
              //       radius: 35,
              //       child: Image.asset(
              //         "assets/localkart_empty_bg.png",
              //         height: 50,
              //         width: 50,
              //       ),
              //     )),
            ],
          ),
        ),
      ),
    );
  }
}
