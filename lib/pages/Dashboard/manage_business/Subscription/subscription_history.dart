import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/businessModel/payment_history.dart';
import 'package:localkart/model/businessModel/subscription_list.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';
import 'package:localkart/unit/sub_bot_history_view.dart';

class SubscriptionHistorys extends StatefulWidget {
  SubscriptionHistorys({Key? key}) : super(key: key);

  @override
  _SubscriptionHistorysFormState createState() =>
      _SubscriptionHistorysFormState();
}

class _SubscriptionHistorysFormState extends State<SubscriptionHistorys> {
  @override
  void initState() {
    _paymentHistoryModel.errorCode = 1;
    getSubDetails();
    super.initState();
  }

  late PaymentHistoryModel _paymentHistoryModel = new PaymentHistoryModel();
  late PlanModebottomModel _subscriptionListModel = new PlanModebottomModel();
  bool _isLoading = false;

  getSubDetails() async {
    try {
      var userIndexId = "" + await DBHelper().getLoginSubDB("Id");
      // Map<String, Object> inputs = {"userIndexId": "345"};
      Map<String, Object> inputs = {"userIndexId": userIndexId};
      setState(() {
        _isLoading = true;
      });

      var responces = await ApiClientLocalKart().httpPost(
        inputs,
        urlPaymentHistory,
      );

      try {
        setState(() {
          _isLoading = false;
        });

        var datas = json.decode(responces.body.toString());

        print("datas " + datas.toString());

        if (datas['errorCode'].toString() == "0") {
          _paymentHistoryModel = PaymentHistoryModel.fromJson(datas);
          setState(() {});
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
    }
  }

  getSubDetailsView(
    String pack,
    String date,
    String days,
    String type,
    String index,
  ) async {
    try {
      var userIndexId = "" + await DBHelper().getLoginSubDB("Id");
      Map<String, Object> inputs = {
        "userIndexId": "" + userIndexId,
        "planType": "" + type,
        "indexId": "" + index,
      };
      setState(() {
        _isLoading = true;
      });

      var responces = await ApiClientLocalKart().httpPost(
        inputs,
        urlPaymenthistorydetails,
      );

      try {
        setState(() {
          _isLoading = false;
        });

        var datas = json.decode(responces.body.toString());
        if (datas['errorCode'].toString() == "0") {
          _subscriptionListModel = PlanModebottomModel.fromJson(datas);

          print(
            "_subscriptionListModel " +
                _subscriptionListModel.message.toString(),
          );

          if (pack == "Referral") {
            try {
              var localpack = _subscriptionListModel.result!;
              selectViewPlans(pack, localpack, date);
            } catch (e) {
              print("Referral free plan error is - " + e.toString());
            }
          } else {
            try {
              var localpack = _subscriptionListModel.result!;
              selectViewPlans(pack, localpack, date);
            } catch (e) {
              print("free plan error is - " + e.toString());
            }
          }

          setState(() {});
          // print("local " + localpack![0].validity.toString());
        }
      } catch (e) {
        print(" loading main empty  " + e.toString());
        setState(() {
          _isLoading = false;
        });
        print(" loading rtt  222" + e.toString());
      }
    } catch (e) {
      print(" loading main  " + e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  selectViewPlans(String pack,  plan, date) async {
    try {
      var yy = date.toString().split("-")[2];
      var mm = date.toString().split("-")[1];
      var dd = date.toString().split("-")[0];

      var dates = yy + "-" + mm + "-" + dd;

      DateTime dt = DateTime.parse(dates);
      // var days = int.parse(plan.benifits!.validity!.toString());

      var days = int.parse("12");
      DateTime now1 = dt;
      DateTime now = now1.add(Duration(days: days));
      String endDate =
          now.day.toString() +
          "-" +
          now.month.toString() +
          "-" +
          now.year.toString();

      print("end DATES $endDate");

      var data =
          await showBotPlanHistor(context, pack, plan, date, endDate) as String;
      print("My res " + data.toString());
    } catch (e) {
      print("view plans error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: actionBarTopBottomView(
        "History",
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
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: .5, color: Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        bottomLeft: Radius.circular(15.0),
                        // bottomRight: Radius.circular(15.0),
                        topRight: Radius.circular(15.0),
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Center(
                          child: Column(
                            children: [
                              Table(
                                // border: TableBorder.all(color: Colors.black),
                                border: TableBorder(
                                  horizontalInside: BorderSide(
                                    width: 0.5,
                                    color: Color(0xFFE0E0E0),
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                // border: TableBorder.all(color: Colors.grey),
                                columnWidths: const {
                                  0: FixedColumnWidth(50.0),
                                  1: FixedColumnWidth(100.0),
                                  2: FixedColumnWidth(120.0),
                                  3: FixedColumnWidth(100.0),
                                  4: FixedColumnWidth(100.0),
                                  5: FixedColumnWidth(100.0),
                                  6: FixedColumnWidth(100.0),
                                },
                                children: [
                                  TableRow(
                                    children: [
                                      Container(
                                        height: 50,
                                        decoration: new BoxDecoration(
                                          color: app_theam[100],
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15.0),
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
                                            'PACKAGE',
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
                                            'VALIDITY',
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
                                            'AMOUNT',
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
                                        decoration: new BoxDecoration(
                                          color: app_theam[100],
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(15.0),
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'DETAILS',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xFFe4287c),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (_paymentHistoryModel.errorCode == 0) ...[
                                    for (
                                      int i = 0;
                                      i < _paymentHistoryModel.result!.length;
                                      i++
                                    ) ...[
                                      TableRow(
                                        children: [
                                          Container(
                                            height: 50,
                                            padding: EdgeInsets.all(3),
                                            child: Center(
                                              child: Text((i + 1).toString()),
                                            ),
                                          ),
                                          Container(
                                            height: 50,
                                            padding: EdgeInsets.all(3),
                                            child: Center(
                                              child: Text(
                                                _paymentHistoryModel
                                                    .result![i]
                                                    .paymentDate
                                                    .toString(),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 50,
                                            padding: EdgeInsets.all(3),
                                            child: Center(
                                              child: Text(
                                                _paymentHistoryModel
                                                    .result![i]
                                                    .package
                                                    .toString(),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 50,
                                            padding: EdgeInsets.all(3),
                                            child: Center(
                                              child: Text(
                                                _paymentHistoryModel
                                                        .result![i]
                                                        .validity
                                                        .toString() +
                                                    " Days",
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 50,
                                            padding: EdgeInsets.all(3),
                                            child: Center(
                                              child: Text(
                                                double.parse(
                                                  _paymentHistoryModel
                                                      .result![i]
                                                      .amount
                                                      .toString(),
                                                ).toInt().toString(),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 50,
                                            padding: EdgeInsets.all(3),
                                            child: Center(
                                              child: Text(
                                                _paymentHistoryModel
                                                    .result![i]
                                                    .status
                                                    .toString(),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              getSubDetailsView(
                                                _paymentHistoryModel
                                                    .result![i]
                                                    .package
                                                    .toString(),
                                                _paymentHistoryModel
                                                    .result![i]
                                                    .paymentDate
                                                    .toString(),
                                                _paymentHistoryModel
                                                    .result![i]
                                                    .validity
                                                    .toString(),
                                                _paymentHistoryModel
                                                    .result![i]
                                                    .planType
                                                    .toString(),
                                                _paymentHistoryModel
                                                    .result![i]
                                                    .indexId
                                                    .toString(),
                                              );
                                              // getSubDetailsView(
                                              //   _paymentHistoryModel.result![i],
                                              // );
                                            },
                                            child: Container(
                                              height: 50,
                                              padding: EdgeInsets.all(10),
                                              child: Container(
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  gradient: app_gradient,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
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
                                                    "View",
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
