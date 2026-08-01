// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/RoutingSetup/router-constants.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/ads_history.dart';
import 'package:localkart/pages/Dashboard/manage_business/ads/ads_more_details.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';

class AdsHostory extends StatefulWidget {
  AdsHostory({Key? key}) : super(key: key);

  @override
  _AdsHostoryFormState createState() => _AdsHostoryFormState();
}

class _AdsHostoryFormState extends State<AdsHostory> {
  @override
  void initState() {
    _adsHistoryModel.errorCode = 1;
    getAdsHistory();
    super.initState();
  }

  bool magaSale = false;
  bool image = false;

  bool activeStates = true;

  PostingStatus(param0) {
    Widget yesButton = TextButton(
      child: Text("Yes"),
      onPressed: () async {
        Navigator.pop(context1);
        updatePostDetails(param0.postIndexId);
      },
    );
    Widget noButton = TextButton(
      child: Text("No"),
      onPressed: () async {
        Navigator.pop(context1);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Delete Post"),
      content: const Text(
        "Are you sure you want to Deleting this post details?",
      ),
      actions: [noButton, yesButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        context1 = context;
        return alert;
      },
    );
  }

  late BuildContext context1;
  late AdsHistoryModel _adsHistoryModel = AdsHistoryModel();
  bool _isLoading = false;

  getAdsHistory() async {
    try {
      var userIndexId = "" + await DBHelper().getLoginSubDB("Id");
      Map<String, Object> inputs = {"userIndexId": userIndexId};
      setState(() {
        _isLoading = true;
        _adsHistoryModel = AdsHistoryModel();
      });

      var responces = await ApiClientLocalKart().httpPost(
        inputs,
        urlAdsHistory,
      );
      try {
        setState(() {
          _isLoading = false;
        });

        var datas = json.decode(responces.body.toString());

        _adsHistoryModel = AdsHistoryModel.fromJson(datas);
        print("_adsHistoryModel " + datas.toString());

        setState(() {});
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print(" loading rtt " + e.toString());
      }
    } catch (e) {
      print(" loading rtt 2" + e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  updatePostDetails(var postalIndex) async {
    try {
      Map<String, Object> inputs = {"postIndexId": postalIndex.toString()};
      setState(() {
        _adsHistoryModel = AdsHistoryModel();
        _isLoading = true;
      });

      var responces = await ApiClientLocalKart().httpPost(
        inputs,
        urlAdsHistoryDelete,
      );

      try {
        setState(() {
          _isLoading = false;
        });

        var datas = json.decode(responces.body.toString());

        if (datas['errorCode'].toString() == "0") {
          getAdsHistory();
          setState(() {});
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print(" loading rtt " + e.toString());
      }
    } catch (e) {
      print(" loading rtt  3 " + e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: actionBarTopBottomView(
        "Post History" + _adsHistoryModel.errorCode.toString(),
        context,

        Scaffold(
          body: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Container(
                    height: double.infinity,
                    // ignore: unnecessary_new
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: .5, color: Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(15.0),
                        bottomLeft: Radius.circular(15.0),
                        // bottomRight: Radius.circular(15.0),
                        topRight: Radius.circular(15.0),
                      ),
                    ),
                    child: _adsHistoryModel.errorCode == 1
                        ? Container(
                            child: const Center(
                              child: Text(
                                "No history avable.",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Center(
                                child: Column(
                                  children: [
                                    Table(
                                      // border: TableBorder.all(color: Colors.black),
                                      border: const TableBorder(
                                        horizontalInside: BorderSide(
                                          width: 0.5,
                                          color: Color(0xFFE0E0E0),
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                      // border: TableBorder.all(color: Colors.grey),
                                      columnWidths: const {
                                        0: FixedColumnWidth(50.0),
                                        1: FixedColumnWidth(90.0),
                                        2: FixedColumnWidth(80.0),
                                        3: FixedColumnWidth(80.0),
                                        4: FixedColumnWidth(120.0),
                                        5: FixedColumnWidth(25.0),
                                        6: FixedColumnWidth(80.0),
                                        7: FixedColumnWidth(100.0),
                                        8: FixedColumnWidth(100.0),
                                        9: FixedColumnWidth(100.0),
                                      },
                                      children: [
                                        TableRow(
                                          children: [
                                            Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: app_theam[100],
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(
                                                    15.0,
                                                  ),
                                                ),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  '  S.No',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color(0xFFe4287c),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 50,
                                              color: app_theam[100],
                                              child: const Center(
                                                child: Text(
                                                  'DATE',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color(0xFFe4287c),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 50,
                                              color: app_theam[100],
                                              child: const Center(
                                                child: Text(
                                                  'ID',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color(0xFFe4287c),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 50,
                                              color: app_theam[100],
                                              child: const Center(
                                                child: Text(
                                                  'TYPE',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color(0xffe4287c),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 50,
                                              color: app_theam[100],
                                              child: const Center(
                                                child: Text(
                                                  'POST',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color(0xFFe4287c),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 50,
                                              color: app_theam[100],
                                              child: const Center(
                                                child: Text(
                                                  '',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color(0xFFe4287c),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 50,
                                              color: app_theam[100],
                                              child: const Center(
                                                child: Text(
                                                  'STATUS',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color(0xFFe4287c),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: app_theam[100],
                                                // borderRadius:
                                                //     const BorderRadius
                                                //             .only(
                                                //         topRight: Radius
                                                //             .circular(
                                                //                 15.0)),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  'Action',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color(0xFFe4287c),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: app_theam[100],
                                                // borderRadius:
                                                //     const BorderRadius
                                                //             .only(
                                                //         topRight: Radius
                                                //             .circular(
                                                //                 15.0)),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  'Option',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color(0xFFe4287c),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: app_theam[100],
                                                borderRadius:
                                                    const BorderRadius.only(
                                                      topRight: Radius.circular(
                                                        15.0,
                                                      ),
                                                    ),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  'Views',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color(0xFFe4287c),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (_adsHistoryModel.errorCode ==
                                            0) ...[
                                          for (
                                            int i = 0;
                                            i < _adsHistoryModel.result!.length;
                                            i++
                                          ) ...[
                                            TableRow(
                                              children: [
                                                Container(
                                                  height: 50,
                                                  padding: EdgeInsets.all(3),
                                                  child: Center(
                                                    child: Text(
                                                      (i + 1).toString(),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 50,
                                                  padding: EdgeInsets.all(3),
                                                  child: Center(
                                                    child: Text(
                                                      _adsHistoryModel
                                                          .result![i]
                                                          .postDate
                                                          .toString(),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 50,
                                                  padding: EdgeInsets.all(3),
                                                  child: Center(
                                                    child: Text(
                                                      _adsHistoryModel
                                                          .result![i]
                                                          .postCode
                                                          .toString(),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 50,
                                                  padding: EdgeInsets.all(3),
                                                  child: Center(
                                                    child: Text(
                                                      _adsHistoryModel
                                                          .result![i]
                                                          .type
                                                          .toString(),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 50,
                                                  padding: EdgeInsets.all(3),
                                                  child: Center(
                                                    child: Text(
                                                      _adsHistoryModel
                                                          .result![i]
                                                          .heading
                                                          .toString(),
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ),
                                                _adsHistoryModel
                                                                .result![i]
                                                                .count ==
                                                            "1" ||
                                                        _adsHistoryModel
                                                                .result![i]
                                                                .count ==
                                                            "0"
                                                    ? Container()
                                                    : Container(
                                                        height: 25,
                                                        margin:
                                                            const EdgeInsets.only(
                                                              top: 15,
                                                            ),
                                                        alignment:
                                                            Alignment.center,
                                                        decoration: BoxDecoration(
                                                          color: app_theam[100],
                                                          // border: Border.all(
                                                          //
                                                          //   width: 1,
                                                          // ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                3,
                                                              ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            "+" +
                                                                _adsHistoryModel
                                                                    .result![i]
                                                                    .count
                                                                    .toString(),
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                      ),
                                                Container(
                                                  height: 50,
                                                  padding: EdgeInsets.all(3),
                                                  child: Center(
                                                    child: Text(
                                                      _adsHistoryModel
                                                          .result![i]
                                                          .status
                                                          .toString(),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            AdsMoreDetails(
                                                              adsHistoryModel:
                                                                  _adsHistoryModel
                                                                      .result![i],
                                                            ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    height: 50,
                                                    padding:
                                                        const EdgeInsets.all(
                                                          10,
                                                        ),
                                                    child: Container(
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        gradient: app_gradient,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      child: const Center(
                                                        child: Text(
                                                          "View",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                _adsHistoryModel
                                                            .result![i]
                                                            .status
                                                            .toString() ==
                                                        "Pending"
                                                    ? InkWell(
                                                        onTap: () {
                                                          PostingStatus(
                                                            _adsHistoryModel
                                                                .result![i],
                                                          );
                                                        },
                                                        child: Container(
                                                          height: 50,
                                                          padding:
                                                              const EdgeInsets.all(
                                                                10,
                                                              ),
                                                          child: Icon(
                                                            Icons.delete,
                                                            color:
                                                                gradint_start_color,
                                                            size: 24,
                                                          ),
                                                        ),
                                                      )
                                                    : InkWell(
                                                        onTap: () {},
                                                        child: Container(
                                                          height: 50,
                                                          width: 100,
                                                          alignment:
                                                              Alignment.center,
                                                          padding:
                                                              const EdgeInsets.all(
                                                                10,
                                                              ),
                                                          child: Text(
                                                            "-",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                InkWell(
                                                  onTap: () {
                                                    Map<String, String> roots =
                                                        {
                                                          "id": _adsHistoryModel
                                                              .result![i]
                                                              .postIndexId
                                                              .toString(),
                                                        };
                                                    Navigator.of(
                                                      context,
                                                    ).pushNamed(
                                                      business_lead,
                                                      arguments: roots,
                                                    );

                                                    // Navigator.of(context).push(
                                                    //   MaterialPageRoute(
                                                    //     builder: (context) =>
                                                    //         AdsMoreDetails(
                                                    //           adsHistoryModel:
                                                    //           _adsHistoryModel
                                                    //               .result![i],
                                                    //         ),
                                                    //   ),
                                                    // );
                                                  },
                                                  child: Container(
                                                    height: 50,
                                                    padding:
                                                        const EdgeInsets.all(
                                                          10,
                                                        ),
                                                    child: Container(
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        gradient: app_gradient,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "" +
                                                              _adsHistoryModel
                                                                  .result![i]
                                                                  .viewCount
                                                                  .toString(),
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              _isLoading != false ? fullViewLoadingUi(_isLoading) : Container(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
