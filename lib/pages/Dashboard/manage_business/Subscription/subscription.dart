// ignore_for_file: avoid_unnecessary_containers, unnecessary_const

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/RoutingSetup/router-constants.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/businessModel/view_current_plan_details.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';

class SubscriptionPlans extends StatefulWidget {
  const SubscriptionPlans({Key? key}) : super(key: key);

  @override
  _SubscriptionPlansFormState createState() => _SubscriptionPlansFormState();
}

class _SubscriptionPlansFormState extends State<SubscriptionPlans> {
  @override
  void initState() {
    _viewPlans.errorCode = 1;
    getSubPlanDetailsView();

    super.initState();
  }

  bool _isLoading = false;
  var userIndexId = "";

  late ViewPlanDetailsModel _viewPlans = ViewPlanDetailsModel();

  getSubPlanDetailsView() async {
    try {
      userIndexId = "" + await DBHelper().getLoginSubDB("Id");
      Map<String, Object> inputs = {"userIndexId": userIndexId};
      setState(() {
        _isLoading = true;
      });
      var responces = await ApiClientLocalKart().httpPost(
        inputs,
        urlSubViewplandetails,
      );
      try {
        setState(() {
          _isLoading = false;
        });

        var datas = json.decode(responces.body.toString());

        // print(" name is json  " + datas.toString());
        if (datas['errorCode'].toString() == "0") {
          _viewPlans = ViewPlanDetailsModel.fromJson(datas);
        }
        setState(() {});
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

      print(" loading rtt test " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return actionBarTopBottomView(
      "Subscription",
      context,

      Scaffold(
        body: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              color: const Color(0xFFF8F7F7),
              child: _viewPlans.errorCode == 1
                  ? Container(
                      margin: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                        color: Color(0xFFffffff),
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      child: Center(
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Your don't have any active subscription.",
                                style: TextStyle(fontSize: 19),
                              ),
                              const SizedBox(height: 13),
                              InkWell(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "View Plans and Subscribe ",
                                      style: TextStyle(
                                        fontSize: 19,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      size: 22,
                                      color: app_theam,
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  getSubDetails();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.all(15),
                        decoration: const BoxDecoration(
                          color: Color(0xFFffffff),
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        child: Column(
                          // mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: app_theam[100],
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(15.0),
                                  topLeft: Radius.circular(15.0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      title: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Current Plan",
                                          style: TextStyle(
                                            color: app_theam,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                _viewPlans.result!.planName!.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              width: double.infinity,
                              height: 100,
                              margin: const EdgeInsets.only(
                                left: 15,
                                right: 15,
                              ),
                              padding: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFE0E0E0),
                                  width: 1,
                                ),
                                color: const Color(0xFFF8F7F7),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Expanded(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      _viewPlans
                                                          .result!
                                                          .directoryListing!
                                                          .benifits!
                                                          .toString(),
                                                      style: const TextStyle(
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
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Expanded(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      _viewPlans
                                                          .result!
                                                          .directoryListing!
                                                          .daysTotal
                                                          .toString(),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    const Text(
                                                      "Total Days",
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 30,
                                            color: Colors.grey,
                                          ),
                                          Container(
                                            child: Expanded(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      _viewPlans
                                                          .result!
                                                          .directoryListing!
                                                          .daysAvailable
                                                          .toString(),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    const Text(
                                                      "Remaining Days",
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 30,
                                            color: Colors.grey,
                                          ),
                                          Container(
                                            child: Expanded(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      _viewPlans
                                                          .result!
                                                          .directoryListing!
                                                          .daysUsed
                                                          .toString(),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    const Text(
                                                      "Shown Days",
                                                      style: TextStyle(
                                                        fontSize: 11,
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
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              width: double.infinity,
                              height: 100,
                              margin: const EdgeInsets.only(
                                left: 15,
                                right: 15,
                              ),
                              padding: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFE0E0E0),
                                  width: 1,
                                ),
                                color: const Color(0xFFF8F7F7),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Expanded(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      _viewPlans
                                                          .result!
                                                          .dailyPost!
                                                          .benifits
                                                          .toString(),
                                                      style: const TextStyle(
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
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Expanded(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      _viewPlans
                                                          .result!
                                                          .dailyPost!
                                                          .postsTotal
                                                          .toString(),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    const Text(
                                                      "Total",
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 30,
                                            color: Colors.grey,
                                          ),
                                          Container(
                                            child: Expanded(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      _viewPlans
                                                          .result!
                                                          .dailyPost!
                                                          .postsAvailable
                                                          .toString(),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    const Text(
                                                      "Available",
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 30,
                                            color: Colors.grey,
                                          ),
                                          Container(
                                            child: Expanded(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      _viewPlans
                                                          .result!
                                                          .dailyPost!
                                                          .postsUsed
                                                          .toString(),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    const Text(
                                                      "Used",
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 30,
                                            color: Colors.grey,
                                          ),
                                          Container(
                                            child: Expanded(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      _viewPlans
                                                          .result!
                                                          .dailyPost!
                                                          .postsExpired
                                                          .toString(),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    const Text(
                                                      "Expired",
                                                      style: const TextStyle(
                                                        fontSize: 11,
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
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              width: double.infinity,
                              height: 100,
                              margin: const EdgeInsets.only(
                                left: 15,
                                right: 15,
                              ),
                              padding: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFE0E0E0),
                                  width: 1,
                                ),
                                color: const Color(0xFFF8F7F7),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Expanded(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      _viewPlans
                                                          .result!
                                                          .weeklyPost!
                                                          .benifits
                                                          .toString(),
                                                      style: const TextStyle(
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
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Expanded(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      _viewPlans
                                                          .result!
                                                          .weeklyPost!
                                                          .postsTotal
                                                          .toString(),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    const Text(
                                                      "Total",
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 30,
                                            color: Colors.grey,
                                          ),
                                          Container(
                                            child: Expanded(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      _viewPlans
                                                          .result!
                                                          .weeklyPost!
                                                          .postsAvailable
                                                          .toString(),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    const Text(
                                                      "Available",
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 30,
                                            color: Colors.grey,
                                          ),
                                          Container(
                                            child: Expanded(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      _viewPlans
                                                          .result!
                                                          .weeklyPost!
                                                          .postsUsed
                                                          .toString(),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    const Text(
                                                      "Used",
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 30,
                                            color: Colors.grey,
                                          ),
                                          Container(
                                            child: Expanded(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      _viewPlans
                                                          .result!
                                                          .weeklyPost!
                                                          .postsExpired
                                                          .toString(),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    const Text(
                                                      "Expired",
                                                      style: TextStyle(
                                                        fontSize: 11,
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
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              width: double.infinity,
                              height: 100,
                              margin: const EdgeInsets.only(
                                left: 15,
                                right: 15,
                              ),
                              padding: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFE0E0E0),
                                  width: 1,
                                ),
                                color: const Color(0xFFF8F7F7),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Expanded(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      _viewPlans
                                                          .result!
                                                          .festivalPost!
                                                          .benifits
                                                          .toString(),
                                                      style: const TextStyle(
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
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Expanded(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      _viewPlans
                                                          .result!
                                                          .festivalPost!
                                                          .postsTotal
                                                          .toString(),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    const Text(
                                                      "Total",
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 30,
                                            color: Colors.grey,
                                          ),
                                          Container(
                                            child: Expanded(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      _viewPlans
                                                          .result!
                                                          .festivalPost!
                                                          .postsAvailable
                                                          .toString(),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    const Text(
                                                      "Available",
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 30,
                                            color: Colors.grey,
                                          ),
                                          Container(
                                            child: Expanded(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      _viewPlans
                                                          .result!
                                                          .festivalPost!
                                                          .postsUsed
                                                          .toString(),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    const Text(
                                                      "Used",
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 30,
                                            color: Colors.grey,
                                          ),
                                          Container(
                                            child: Expanded(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      _viewPlans
                                                          .result!
                                                          .festivalPost!
                                                          .postsExpired
                                                          .toString(),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    const Text(
                                                      "Expired",
                                                      style: TextStyle(
                                                        fontSize: 11,
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
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: double.infinity,
                              height: 190,
                              margin: const EdgeInsets.only(
                                left: 15,
                                right: 15,
                                top: 10,
                              ),
                              padding: const EdgeInsets.only(bottom: 5, top: 5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFE0E0E0),
                                  width: 1,
                                ),
                                color: const Color(0xFFF8F7F7),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Expanded(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      _viewPlans
                                                          .result!
                                                          .others![0]
                                                          .value
                                                          .toString(),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      _viewPlans
                                                          .result!
                                                          .others![0]
                                                          .keyName
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Expanded(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      _viewPlans
                                                          .result!
                                                          .others![1]
                                                          .value
                                                          .toString(),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      _viewPlans
                                                          .result!
                                                          .others![1]
                                                          .keyName
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 11,
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
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Expanded(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      _viewPlans
                                                          .result!
                                                          .others![2]
                                                          .value
                                                          .toString(),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      _viewPlans
                                                          .result!
                                                          .others![2]
                                                          .keyName
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Expanded(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      _viewPlans
                                                          .result!
                                                          .others![3]
                                                          .value
                                                          .toString(),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      _viewPlans
                                                          .result!
                                                          .others![3]
                                                          .keyName
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 11,
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
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Expanded(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      _viewPlans
                                                          .result!
                                                          .others![4]
                                                          .value
                                                          .toString(),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      _viewPlans
                                                          .result!
                                                          .others![4]
                                                          .keyName
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Expanded(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      _viewPlans
                                                          .result!
                                                          .others![5]
                                                          .value
                                                          .toString(),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      _viewPlans
                                                          .result!
                                                          .others![5]
                                                          .keyName
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 11,
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
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
            ),
            _isLoading != false ? fullViewLoadingUi(_isLoading) : Container(),
          ],
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          child: _isLoading != false
              ? Container(height: 1)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(
                            context,
                          ).pushNamed(business_subscriptin_history);
                        },
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.only(right: 1),
                          decoration: BoxDecoration(
                            gradient: gradient_btn_lift,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "History",
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
                    // SizedBox(width: 1),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          getSubDetails();
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: gradient_btn_rigth,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "View Plans",
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
      ),
    );
  }

  getSubDetails() async {
    try {
      var select_plans =
          await Navigator.of(
                context,
              ).pushNamed(business_digital_subscriptin_list)
              as Map<String, String>;
      print("Select current plans - " + select_plans.toString());

      setState(() {
        if (select_plans['title'] != "") {
          getSubPlanDetailsView();
        }
      });
    } catch (e) {
      print("select select_plans123 - " + e.toString());
    }
  }
}
