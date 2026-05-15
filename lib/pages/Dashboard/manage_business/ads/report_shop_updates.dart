// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/Api/service.dart';
import 'package:localkart/RoutingSetup/root_data_pass.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/ads_history_reports.dart';
import 'package:localkart/model/businessModel/posting_list.dart';
import 'package:localkart/pages/Dashboard/manage_business/ads/ads_preview.dart';
import 'package:localkart/pages/Dashboard/manage_business/ads/repost_single_view.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';
import 'package:localkart/unit/showingCreatePostAletrs.dart';
import 'package:localkart/unit/showingUpdatePostAletrs.dart';

// ignore: must_be_immutable
class ReportThisShopUpdate extends StatefulWidget {
  AdsGetReportModel adsHistory;
  String postIndexId;

  ReportThisShopUpdate({
    Key? key,
    required this.postIndexId,
    required this.adsHistory,
  }) : super(key: key);

  @override
  _ReportThisShopUpdate createState() => _ReportThisShopUpdate();
}

class _ReportThisShopUpdate extends State<ReportThisShopUpdate> {
  late AdsGetReportModel adsHistory;

  _selectDate(BuildContext context) async {
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: endDate,
    );

    setState(() {
      selectedDate = selected!;
      _controller_txt_startDate.text =
          "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
      _controller_txt_endDate.text = "";

      String month = selectedDate.month.toString().padLeft(2, '0');
      String date = selectedDate.day.toString().padLeft(2, '0');
      str_start_date = "${selectedDate.year}-$month-$date";
    });
  }

  late DateTime endDate = DateTime(2028);

  _selectEndDate(BuildContext context) async {
    if (type == "2") {
      DateTime sdate = DateTime.parse(str_start_date);
      endDate = sdate.add(Duration(days: 6));
    } else if (type == "3") {
      DateTime sdate = DateTime.parse(str_start_date);
      endDate = sdate.add(Duration(days: 24));
    } else {
      endDate = DateTime.now().add(Duration(days: 500));
    }
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: selectedDate,
      lastDate: endDate,
    );
    if (selected != null) {
      setState(() {
        _controller_txt_endDate.text =
            "${selected.day}-${selected.month}-${selected.year}";
        str_end_date = "${selected.year}-${selected.month}-${selected.day}";

        String month = selected.month.toString().padLeft(2, '0');
        String date = selected.day.toString().padLeft(2, '0');

        str_end_date = "${selected.year}-$month-$date";
      });
    }
  }

  bool isFastival = false;
  String postIndexId = "";

  @override
  void initState() {
    adsHistory = widget.adsHistory;
    postIndexId = widget.postIndexId;
    _controller_txt_startDate.text = "";
    _controller_txt_endDate.text = "";
    _controller_txt_post.text = changePostalType(
      adsHistory.result!.postType.toString(),
    );

    if (adsHistory.result!.postType.toString() == "3") {
      type = adsHistory.result!.postType.toString();
      _controller_txt_feastival.text = adsHistory.result!.festivalName
          .toString();
      isFastival = true;
    }

    type = adsHistory.result!.postType.toString();

    for (int i = 0; i < adsHistory.result!.offerImageList!.length; i++) {
      CreatePostMode create = new CreatePostMode();
      create.id = adsHistory.result!.offerImageList![i].offerIndexId.toString();
      create.titile = adsHistory.result!.offerImageList![i].heading.toString();
      create.desc = adsHistory.result!.offerImageList![i].description
          .toString();
      create.images = adsHistory.result!.offerImageList![i].offerImage
          .toString();
      listOfPost.add(create);
    }
    endDate = DateTime.now().add(Duration(days: 500));
    getarraylist();
    super.initState();
  }

  bool _isLoading = false;
  late var userId = "";

  ListPostTypesModel listPostTypesModel = new ListPostTypesModel();

  getarraylist() async {
    listPostTypesModel.errorCode = 1;
    listPostTypesModel.accessOption = [];
    try {
      setState(() {
        _isLoading = true;
      });

      userId = await DBHelper().getLoginSubDB("Id");
      var userTypes = await DBHelper().getLoginDB("type");
      Map<String, Object> tags = {
        "type": userTypes.toString(),
        "userIndexId": userId.toString(),
      };

      var responces = await ApiClientLocalKart().httpPost(tags, urlListarray);

      try {
        setState(() {
          _isLoading = false;
        });

        var datas = json.decode(responces.body.toString());

        print("" + datas.toString());
        if (datas['errorCode'].toString() == "0") {
          try {
            listPostTypesModel = ListPostTypesModel.fromJson(datas);

            for (int i = 0; i < listPostTypesModel.accessOption!.length; i++) {
              if (listPostTypesModel.accessOption![i].keyName.toString() ==
                  adsHistory.result!.accessOptions!.toString()) {
                _controller_txt_opction.text = listPostTypesModel
                    .accessOption![i]
                    .value
                    .toString();

                accessOpction = listPostTypesModel.accessOption![i].keyName
                    .toString();
              }
            }
            setState(() {});
          } catch (e) {
            print("error is - " + e.toString());
          }
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print(" loading rtt " + e.toString());
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(" loading rtt 2 " + e.toString());
    }
  }

  String str_start_date = "";
  String str_end_date = "";
  DateTime selectedDate = DateTime.now();

  var type = "0";
  var accessOpction = "0";

  var _controller_txt_opction = TextEditingController();
  var _controller_txt_post = TextEditingController();
  var _controller_txt_startDate = TextEditingController();
  var _controller_txt_endDate = TextEditingController();

  var _controller_txt_feastival = TextEditingController();

  List<CreatePostMode> listOfPost = [];

  Widget _itemList(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(top: 5, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "DEAL " + (index + 1).toString(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF616161),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Flexible(
                      child: Container(
                        width: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              child: Icon(Icons.edit, color: app_theam),
                              onTap: () {
                                showAlertAddServicesUpdate(
                                  listOfPost[index],
                                  index,
                                );
                              },
                            ),
                            InkWell(
                              child: Icon(
                                Icons.delete_forever,
                                color: app_theam,
                              ),
                              onTap: () {
                                listOfPost.remove(listOfPost[index]);
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/logo_with_name1.png"),
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(
                                color: gradint_start_color,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                              child:
                                  listOfPost[index].images.toString().contains(
                                    "http",
                                  )
                                  ? Image.network(
                                      listOfPost[index].images.toString(),
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Image.asset(
                                              "assets/logo_with_name1.png",
                                            );
                                          },
                                    )
                                  : Image.file(
                                      File(listOfPost[index].images.toString()),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "" +
                                              listOfPost[index].titile
                                                  .toUpperCase(),
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          listOfPost[index].desc.toString(),
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => RepostSinglePrevews(
                                      images:
                                          "" +
                                          listOfPost[index].images.toString(),
                                      title:
                                          "" +
                                          listOfPost[index].titile.toString(),
                                      desc:
                                          "" +
                                          listOfPost[index].desc.toString(),
                                      deal: "" + (index + 1).toString(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  alertsConfirmation() async {
    Widget yesButton = TextButton(
      child: Text("YES"),
      onPressed: () async {
        createPostingValidate();
        Navigator.pop(contextmain);
      },
    );
    Widget noButton = TextButton(
      child: Text("NO"),
      onPressed: () {
        Navigator.pop(contextmain);
        // Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        "Post details cannot be changed once saved. Are you sure you want to save and show this post to customer?",
      ),
      actions: [noButton, yesButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        contextmain = context;
        return alert;
      },
    );
  }

  late BuildContext contextmain;

  showAlertAddServices() async {
    try {
      var result =
          await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return CreatePostsAlerts(count: listOfPost.length + 1);
                },
              )
              as CreatePostMode;

      if (result == null) {
        print("My res - is empty");
      } else {
        listOfPost.add(result);
        print(
          "my listOfPost size - " +
              listOfPost.length.toString() +
              " data is " +
              listOfPost.toString(),
        );
      }
    } catch (e) {
      print("My res alerts error - " + e.toString());
    }
    setState(() {});
  }

  String changePostalType(String type) {
    var dates = "";
    if (type == "1") {
      dates = "Daily";
    } else if (type == "2") {
      dates = "Weekly";
    } else if (type == "3") {
      dates = "Festival";
    }
    return dates;
  }

  showAlertAddServicesUpdate(local, index) async {
    try {
      var result =
          await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return UpdatePostAlerts(localdata: local, count: index);
                },
              )
              as CreatePostMode;

      if (result == null) {
        print("My res - is empty");
      } else {
        if (listOfPost[index].id == result.id) {
          listOfPost[index] = result;
          setState(() {});
          print(
            "my listOfPost size - " +
                listOfPost.length.toString() +
                " data is " +
                listOfPost.toString(),
          );
        }
      }
    } catch (e) {
      print("My res alerts error - " + e.toString());
    }
    setState(() {});
  }

  reportsFunction() async {
    try {
      setState(() {
        _isLoading = true;
      });
      userId = await DBHelper().getLoginSubDB("Id");
      Map<String, Object> tags = {
        "heading": listOfPost[0].titile,
        "offerImage": listOfPost[0].images,
        "description": listOfPost[0].desc,
        "postIndexId": postIndexId,
        "userIndexId": userId.toString(),
        "offerIndexId": listOfPost[0].id.toString(),
      };
      var responces = await ApiClientLocalKart().httpPost(
        tags,
        urlCreaterepostoffers,
      );
      //
      try {
        setState(() {
          _isLoading = false;
        });

        var datas = json.decode(responces.body.toString());

        print("Ropost details res - " + datas.toString());

        if (datas['errorCode'].toString() == "0") {
          try {
            createPosting();
          } catch (e) {
            print("error is - " + e.toString());
          }
        } else {
          ShowToastdur(context, datas['message'].toString());
        }

        ShowToastdur(context, datas['message'].toString());
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print(" loading rtt " + e.toString());
      }
    } catch (e) {
      print(" loading rtt 2 " + e.toString());
    }
  }

  responceAlerts(String msg) async {
    Widget yesButton = TextButton(
      child: Text("Ok"),
      onPressed: () async {
        Navigator.pop(contextmain);
        for (int i = 0; i < listOfPost.length; i++) {
          var title = "" + listOfPost[i].titile;
          var desc = "" + "" + listOfPost[i].desc;
          var images = "" + "" + listOfPost[i].images;

          var isloop = true;
          if (i == listOfPost.length - 1) {
            isloop = false;
          }
          print("create image urls is " + images);
          await createOffers(title, desc, images, isloop, listOfPost[i].id);
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(content: Text(msg), actions: [yesButton]);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        contextmain = context;
        return alert;
      },
    );
  }

  createPostingValidate() async {
    try {
      setState(() {
        _isLoading = true;
      });

      Map<String, Object> tags = {
        "typeId": type,
        "fromDate": str_start_date.toString(),
        "toDate": str_end_date.toString(),
        "count": listPostTypesModel.count.toString(),
        "userIndexId": userId,
      };

      var responces = await ApiClientLocalKart().httpPost(
        tags,
        urlPostvalidation,
      );

      try {
        setState(() {
          _isLoading = false;
        });

        var datas = json.decode(responces.body.toString());

        print("save post details res - " + datas.toString());

        if (datas['errorCode'].toString() == "1") {
          try {
            reportsFunction();
          } catch (e) {
            print("error is - " + e.toString());
          }
        } else {
          ShowToastdur(context, datas['Message'].toString());
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print(" loading rtt " + e.toString());
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(" loading rtt 2 " + e.toString());
    }
  }

  createPosting() async {
    try {
      setState(() {
        _isLoading = true;
      });
      Map<String, Object> tags = {
        "typeId": type,
        "fromDate": str_start_date.toString(),
        "toDate": str_end_date.toString(),
        "accessOptions": accessOpction,
        "festivalName": _controller_txt_feastival.text.toString(),
        "userIndexId": userId,
      };

      var responces = await ApiClientLocalKart().httpPost(tags, urlCreatepost);

      try {
        setState(() {
          _isLoading = false;
        });

        var datas = json.decode(responces.body.toString());

        print("save post details res - " + datas.toString());

        if (datas['errorCode'].toString() == "0") {
          try {
            postIndexId = datas['postIndexId'].toString();
            if (datas['isBoost'].toString() == "Yes" ||
                datas['isBoost'].toString() == "yes") {
              await sendNotifications();
            }

            await responceAlerts("" + datas['message'].toString());
          } catch (e) {
            print("error is - " + e.toString());
          }
        } else {
          ShowToastdur(context, datas['message'].toString());
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print(" loading rtt " + e.toString());
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(" loading rtt 2 " + e.toString());
    }
  }

  sendNotifications() async {
    try {
      setState(() {
        _isLoading = true;
      });

      var shopIndexId = "" + await DBHelper().getLoginDB("shopId");
      var type = "" + await DBHelper().getLoginDB("type");
      Map<String, Object> tags = {
        "postIndexId": postIndexId,
        "shopId": shopIndexId.toString(),
        "shopType": type.toString(),
      };

      var responces = await ApiClientLocalKart().httpPost(tags, urlSendpush);

      var datas = json.decode(responces.body.toString());

      try {
        setState(() {
          _isLoading = false;
        });

        if (datas['errorCode'].toString() == "0") {
        } else {
          ShowToastdur(context, datas['message'].toString());
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print(" loading rtt " + e.toString());
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(" loading rtt 2 " + e.toString());
    }
  }

  createOffers(title, desc, images, isloop, var id) async {
    try {
      setState(() {
        _isLoading = true;
      });
      userId = await DBHelper().getLoginSubDB("Id");
      var base64string = "";
      try {
        if (images.toString().contains("http")) {
          base64string = id;
        } else {
          File imagefile = File(images);
          Uint8List imagebytes = await imagefile
              .readAsBytes(); //convert to bytes
          base64string = base64.encode(imagebytes); //con
        }

        Map<String, Object> tags = {
          "postIndexId": postIndexId,
          "heading": title.toString(),
          "description": desc.toString(),
          "offerImage": base64string.toString(),
          "userIndexId": userId,
        };

        var responces = await ApiClientLocalKart().httpPost(
          tags,
          urlCreateoffers,
        );

        try {
          setState(() {
            _isLoading = false;
          });

          var datas = json.decode(responces.body.toString());
          print("save opfer details res $isloop - " + datas.toString());

          if (datas['errorCode'].toString() == "0") {
            try {
              if (!isloop) {
                // Navigator.pop(context);
                ShowToastdur(context, datas['message'].toString());
                FocusScope.of(context).requestFocus(new FocusNode());

                Navigator.of(context).popUntil(ModalRoute.withName('/home'));
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //     '/home', (Route<dynamic> route) => false);
              }
            } catch (e) {
              print("error is - " + e.toString());
            }
          } else {
            ShowToastdur(context, datas['message'].toString());
          }
        } catch (e) {
          setState(() {
            _isLoading = false;
          });
          print(" loading rtt " + e.toString());
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print(" loading rtt 2 " + e.toString());
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(" loading rtt 2 " + e.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: actionBarTopBottomView(
        "Repost",
        context,
        Scaffold(
          body: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                child: Container(
                  margin: new EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: TextField(
                            enabled: false,
                            controller: _controller_txt_post,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: 'Post Type',
                              labelText: "Post Type",
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.arrow_drop_down_sharp),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {});
                          _controller_txt_startDate.text = "";
                          _controller_txt_endDate.text = "";
                          _controller_txt_opction.text = "Select Access Option";
                          selectedDate = DateTime.now();

                          showBottomSheetCustomeView(
                            context,
                            "Select Post Type",
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                    ListTile(
                                      leading: new Icon(Icons.date_range),
                                      title: new Text('Daily'),
                                      onTap: () {
                                        setState(() {
                                          _controller_txt_post.text = "Daily";
                                          type = "1";
                                          isFastival = false;
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: new Icon(Icons.update),
                                      title: new Text('Weekly'),
                                      onTap: () {
                                        setState(() {
                                          _controller_txt_post.text = "Weekly";
                                          type = "2";
                                          isFastival = false;
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: new Icon(
                                        Icons.add_photo_alternate_outlined,
                                      ),
                                      title: new Text('Festival'),
                                      onTap: () {
                                        setState(() {
                                          _controller_txt_post.text =
                                              "Festival";
                                          type = "3";
                                          isFastival = true;
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                        },
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 10),
                                decoration: new BoxDecoration(
                                  // color: app_theam,
                                  borderRadius: BorderRadius.circular(8),

                                  border: Border.all(
                                    color: Color(0xFFD6D6D6),
                                    width: 2,
                                  ),
                                ),
                                child: InkWell(
                                  child: TextField(
                                    enabled: false,
                                    controller: _controller_txt_startDate,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      hintText: 'From Date',
                                      focusColor: Colors.grey,
                                      border: InputBorder.none,
                                      suffixIcon: Icon(
                                        Icons.date_range,
                                        color: Colors.black45,
                                      ),
                                      fillColor: Colors.grey,
                                    ),
                                  ),
                                  onTap: () {
                                    _selectDate(context);
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 10),
                                decoration: new BoxDecoration(
                                  // color: app_theam,
                                  borderRadius: BorderRadius.circular(8),

                                  border: Border.all(
                                    color: Color(0xFFD6D6D6),
                                    width: 2,
                                  ),
                                ),
                                child: InkWell(
                                  child: TextField(
                                    enabled: false,
                                    style: TextStyle(color: Colors.black),
                                    controller: _controller_txt_endDate,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      focusColor: Colors.grey,
                                      hintText: 'To Date',
                                      border: InputBorder.none,
                                      suffixIcon: Icon(
                                        Icons.date_range,
                                        color: Colors.black45,
                                      ),
                                      fillColor: Colors.grey,
                                    ),
                                  ),
                                  onTap: () {
                                    String start_date =
                                        _controller_txt_startDate.text
                                            .toString();
                                    if (start_date == "From Date") {
                                      ShowTost("Please select Post Type");
                                    } else {
                                      _selectEndDate(context);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      isFastival == true
                          ? InkWell(
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child: TextField(
                                  controller: _controller_txt_feastival,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: InputDecoration(
                                    hintText: 'Festival Name',
                                    labelText: "Festival Name",
                                    hintStyle: TextStyle(
                                      color: Colors
                                          .grey, // Change this to your desired color
                                    ),
                                    labelStyle: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                            )
                          : Container(height: 1, width: 1),
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: TextField(
                            enabled: false,
                            controller: _controller_txt_opction,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: 'Access Option',
                              labelText: "Access Option",
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.arrow_drop_down_sharp),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          showBottomSheetCustomeView(
                            context,
                            "Select Access Option",
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[

                                    for (
                                      int i = 0;
                                      i <
                                          listPostTypesModel
                                              .accessOption!
                                              .length;
                                      i++
                                    ) ...[
                                      ListTile(
                                        leading: new Icon(Icons.smartphone),
                                        title: Text(
                                          listPostTypesModel
                                              .accessOption![i]
                                              .value
                                              .toString(),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            _controller_txt_opction.text =
                                                listPostTypesModel
                                                    .accessOption![i]
                                                    .value
                                                    .toString();
                                            accessOpction = listPostTypesModel
                                                .accessOption![i]
                                                .keyName
                                                .toString();
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ],
                                ),

                          );
                        },
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          showAlertAddServices();
                        },
                        child: Container(
                          margin: EdgeInsets.all(15),
                          height: 40,
                          width: 155,
                          decoration: BoxDecoration(
                            gradient: app_gradient,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(5, 5),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Add Deal / Offer',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                // fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Container(
                          // padding: EdgeInsets.only(top: 5),
                          // height: 300,
                          // width: double.infinity,
                          child: listOfPost.length != 0
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: listOfPost.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                        return _itemList(context, index);
                                      },
                                )
                              : Container(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _isLoading != false ? fullViewLoadingUi(_isLoading) : Container(),
            ],
          ),
          bottomNavigationBar: Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      String start_date = _controller_txt_startDate.text
                          .toString();
                      String end_date = _controller_txt_endDate.text.toString();
                      String post_type = _controller_txt_post.text.toString();
                      if (post_type == "Select Post Type") {
                        ShowToastdur(context, "Please select Post Type");
                      } else if (start_date == "") {
                        ShowToastdur(context, "Please select From Date");
                      } else if (end_date == "") {
                        ShowToastdur(context, "Please select To Date");
                      } else if (isFastival == true &&
                          _controller_txt_feastival.text.toString().length ==
                              0) {
                        ShowToastdur(context, "Please enter Festival Name");
                      } else if (_controller_txt_opction.text.toString() ==
                          "Select Access Option") {
                        ShowToastdur(context, "Please Select Access Option");
                      } else if (listOfPost.length == 0) {
                        ShowToastdur(
                          context,
                          "Please add Deal / Offer details",
                        );
                      } else {
                        Map<String, Object> tagsValidaction = {
                          "typeId": type,
                          "fromDate": str_start_date.toString(),
                          "toDate": str_end_date.toString(),
                          "count": listPostTypesModel.count.toString(),
                          "userIndexId": userId,
                        };

                        var titles = "";
                        if (_controller_txt_feastival.text == "") {
                          titles = listOfPost[0].titile!.toString();
                        } else {
                          titles = "";
                        }

                        Map<String, Object> tagsPost = {
                          "typeId": type,
                          "fromDate": str_start_date.toString(),
                          "toDate": str_end_date.toString(),
                          "accessOptions": accessOpction,
                          "festivalName": titles,
                          "userIndexId": userId,
                        };

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AdsPreviewMoreDetails(
                              dates:
                                  _controller_txt_startDate.text +
                                  " To " +
                                  _controller_txt_endDate.text,
                              types: "" + _controller_txt_opction.text,
                              listOfPost: listOfPost,
                              tabValidation: tagsValidaction,
                              tagPost: tagsPost,
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(gradient: gradient_btn_lift),
                      margin: EdgeInsets.only(right: 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Preview",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      String start_date = _controller_txt_startDate.text
                          .toString();
                      String end_date = _controller_txt_endDate.text.toString();
                      String post_type = _controller_txt_post.text.toString();

                      if (post_type == "Select Post Type") {
                        ShowToastdur(context, "Please select Post Type");
                      } else if (start_date == "") {
                        ShowToastdur(context, "Please select From Date");
                      } else if (end_date == "") {
                        ShowToastdur(context, "Please select To Date");
                      } else if (_controller_txt_opction.text.toString() ==
                          "Select Access Option") {
                        ShowToastdur(context, "Please Select Access Option");
                      } else if (listOfPost.length == 0) {
                        ShowToastdur(
                          context,
                          "Please add Deal / Offer details",
                        );
                      } else {
                        alertsConfirmation();
                      }
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(gradient: gradient_btn_rigth),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Save",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
