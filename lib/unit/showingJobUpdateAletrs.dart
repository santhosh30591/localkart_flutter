import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localkart/RoutingSetup/root_data_pass.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/showing.dart';

class JobUpdateAlerts extends StatefulWidget {
  CreatePostMode localdata;
  int count;

  JobUpdateAlerts({Key? key, required this.localdata, required this.count})
    : super(key: key);

  @override
  _JobUpdateAlerts createState() => _JobUpdateAlerts();
}

class _JobUpdateAlerts extends State<JobUpdateAlerts> {
  int valueHolder = 30;

  var _controller_deal_title = TextEditingController();
  var _controller_deal_desc = TextEditingController();

  late CreatePostMode localdata;

  @override
  void initState() {
    localdata = widget.localdata;
    _controller_deal_title.text = localdata.titile;
    _controller_deal_desc.text = localdata.desc;

    super.initState();
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
                          hintText: "Job Title",
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
                          hintText: "Job Description",
                          fillColor: Colors.grey,
                        ),
                        onChanged: (str) {
                          // To do
                        },
                      ),
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
                                  gradient: gradient_btn_lift,
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

                                if (post.titile.length < 3) {
                                  ShowTost(
                                    "Please enter job title min 5 words",
                                  );
                                } else if (post.desc.length < 10) {
                                  ShowTost(
                                    "Please enter description min 10 words",
                                  );
                                } else {
                                  Navigator.pop(context, post);
                                }
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: gradient_btn_rigth,
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
