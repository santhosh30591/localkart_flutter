import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localkart/RoutingSetup/root_data_pass.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/image_zooming.dart';
import 'package:localkart/unit/showing.dart';

class UpdatePostAlerts extends StatefulWidget {
  CreatePostMode localdata;
  int count;

  UpdatePostAlerts({Key? key, required this.localdata, required this.count})
    : super(key: key);

  @override
  _UpdatePostAlerts createState() => _UpdatePostAlerts();
}

class _UpdatePostAlerts extends State<UpdatePostAlerts> {
  int valueHolder = 30;

  var _controller_deal_title = TextEditingController();
  var _controller_deal_desc = TextEditingController();

  var imagePicker;

  late CreatePostMode localdata;
  String imagepath = "";
  var servierImages = "";

  @override
  void initState() {
    localdata = widget.localdata;
    _controller_deal_title.text = localdata.titile;
    _controller_deal_desc.text = localdata.desc;
    servierImages = localdata.images;

    if (servierImages.contains("http")) {
      servierImages = localdata.images;
    } else {
      imagepath = localdata.images;
    }
    print("img urls - " + servierImages);
    super.initState();
  }

  final ImagePicker imgpicker = ImagePicker();

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
        // imagefile = File(imagepath);
        setState(() {});
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
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
                      'Deal ${widget.count + 1}',
                      style: TextStyle(fontSize: 17),
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: TextField(
                        controller: _controller_deal_title,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
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
                    SizedBox(height: 10),
                    Container(
                      child: TextField(
                        controller: _controller_deal_desc,
                        textCapitalization: TextCapitalization.sentences,
                        textAlignVertical: TextAlignVertical.center,
                        maxLines: 6,
                        decoration: InputDecoration(
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
                    SizedBox(height: 10),
                    InkWell(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/logo_with_name1.png"),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(
                            color: Color(0xFFee77ad),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),

                          // child: Text("test"),
                          child: imagepath != ""
                              ? Image.file(
                                  File(imagepath),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  servierImages,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      "assets/logo_with_name1.png",
                                    );
                                  },
                                ),
                        ),
                      ),
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());

                        showBottomSheetCustomeView(
                          context,
                          "Select",
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: new Icon(Icons.photo_outlined),
                                title: new Text('Gallery'),
                                onTap: () {
                                  setState(() {
                                    openFilePath(1);
                                  });
                                  // Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: new Icon(Icons.camera_alt),
                                title: new Text('Camera'),
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
                    SizedBox(height: 10),
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
                                  gradient: LinearGradient(
                                    colors: [app_theam, Color(0xFFf4a4c8)],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(5, 5),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
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
                                CreatePostMode post = new CreatePostMode();

                                post.id = localdata.id;
                                post.titile = _controller_deal_title.text
                                    .toString();
                                post.desc = _controller_deal_desc.text
                                    .toString();
                                post.images = servierImages.toString();

                                if (imagepath != "") {
                                  post.images = imagepath;
                                }

                                if (post.titile.length < 8) {
                                  ShowTost("Please enter Heading min 8 words");
                                } else if (post.desc.length < 20) {
                                  ShowTost(
                                    "Please enter description min 8 words",
                                  );
                                } else if (servierImages == "") {
                                  ShowTost("Please select image");
                                } else {
                                  Navigator.pop(context, post);
                                }
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [app_theam, Color(0xFFf4a4c8)],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(5, 5),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Update",
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
