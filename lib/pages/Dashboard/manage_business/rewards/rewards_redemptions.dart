import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/Api/provider/manage_business_provider.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/dashboard/manage_business_model.dart';
import 'package:localkart/model/redemption_model.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';
import 'package:provider/provider.dart';

class RewardRedemptionsPage extends StatefulWidget {
  dynamic datas;

  RewardRedemptionsPage({Key? key, this.datas}) : super(key: key);

  @override
  State<RewardRedemptionsPage> createState() => _RewardRedemptionsState();
}

class _RewardRedemptionsState extends State<RewardRedemptionsPage> {
  late BuildContext contextMain;
  bool _isLoading = true;

  RewardsRedemtionsModel redemtionsModel = new RewardsRedemtionsModel();

  loadingServiceDetails() async {
    setState(() {
      _isLoading = true;
    });

    var id = "";

    try {
      id = widget.datas["id"].toString();
    } catch (e) {
      id = "";
    }
    Map<String, Object> inputs = {"reward_id": "" + id};
    var response = await ApiClientLocalKart().httpPost(inputs, redemption);
    setState(() {
      _isLoading = false;
    });
    try {
      var datas = json.decode(response.body.toString());
      redemtionsModel = RewardsRedemtionsModel.fromJson(datas);
    } catch (e) {
      print("Loading RewardsRedemtionsModel error " + e.toString());
    }

    print("response " + response.body);
  }

  @override
  void initState() {
    loadingServiceDetails();
    super.initState();
  }

  String address = "";

  var isWindows = false;

  int select_posication = 0;

  @override
  Widget build(BuildContext context) {
    contextMain = context;

    setState(() {});

    return actionBarTopBottomView(
      "Rewards Scan Details",
      context,
      Scaffold(
        body: Container(
          color: Colors.white,
          child: Consumer<ManageBusinessProvider>(
            builder: (context, provider, child) {
              return _isLoading == true
                  ? fullViewLoadingUi(_isLoading)
                  : redemtionsModel.errorCode != 0
                  ? Center(
                      child: Text(
                        redemtionsModel.message!!,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    )
                  : Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  color: app_colorSecondary,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "#",
                                          style: TextStyle(
                                            color: app_theam,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 160,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Name",
                                          style: TextStyle(
                                            color: app_theam,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 120,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Coupon Code",
                                          style: TextStyle(
                                            color: app_theam,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 130,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Mobile No",
                                          style: TextStyle(
                                            color: app_theam,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 160,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "City",
                                          style: TextStyle(
                                            color: app_theam,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 100,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Date",
                                          style: TextStyle(
                                            color: app_theam,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                for (
                                  int i = 0;
                                  i < redemtionsModel.result!.length;
                                  i++
                                ) ...[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    color: Colors.white,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          alignment: Alignment.center,
                                          child: Text(
                                            (i + 1).toString(),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 160,
                                          alignment: Alignment.center,
                                          child: Text(
                                            textAlign: TextAlign.center,

                                            redemtionsModel.result![i].name ==
                                                    null
                                                ? "-"
                                                : redemtionsModel
                                                      .result![i]
                                                      .name
                                                      .toString(),
                                            style: TextStyle(
                                              color: Colors.black,

                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 120,
                                          alignment: Alignment.center,
                                          child: Text(
                                            redemtionsModel
                                                        .result![i]
                                                        .offerCode ==
                                                    null
                                                ? "-"
                                                : redemtionsModel
                                                      .result![i]
                                                      .offerCode
                                                      .toString(),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 130,
                                          alignment: Alignment.center,
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            redemtionsModel.result![i].mobile ==
                                                    null
                                                ? "-"
                                                : redemtionsModel
                                                      .result![i]
                                                      .mobile
                                                      .toString(),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 160,
                                          alignment: Alignment.center,
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            redemtionsModel.result![i].city ==
                                                    null
                                                ? "-"
                                                : redemtionsModel
                                                      .result![i]
                                                      .city
                                                      .toString(),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 100,
                                          alignment: Alignment.center,
                                          child: Text(
                                            textAlign: TextAlign.center,

                                            redemtionsModel
                                                .result![i]
                                                .redemptionDate!,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(3),
                                    color: billpay_div_line_color,
                                    height: 1,
                                    child: Row(
                                      children: [
                                        Container(width: 60),
                                        Container(width: 160),
                                        Container(width: 120),
                                        Container(width: 130),
                                        Container(width: 160),
                                        Container(width: 100),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
