import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:localkart/Api/provider/manage_business_provider.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/dashboard/manage_business_model.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:provider/provider.dart';

class CustomerLeardsPage extends StatefulWidget {
  dynamic datas;

  CustomerLeardsPage({Key? key, this.datas}) : super(key: key);

  @override
  State<CustomerLeardsPage> createState() => _CustomerLeardsState();
}

class _CustomerLeardsState extends State<CustomerLeardsPage> {
  late BuildContext contextMain;
  bool _isLoading = true;

  late ManageBusinessProvider provider;

  late BusinessLeadsModel businessLeadsModel = BusinessLeadsModel();

  loadingServiceDetails() async {
    var shopIndexId = "" + await DBHelper().getLoginDB("shopId");
    var dbhelper = await DBHelper();

    var userIndexId = await dbhelper.getLoginSubDB('Id');
    var type = await dbhelper.getLoginDB('type');

    setState(() {
      _isLoading = true;
    });

    var id = "";

    try {
      id = widget.datas["id"].toString();
    } catch (e) {
      id = "";
    }
    Map<String, Object> inputs = {
      "shopIndexId": "" + shopIndexId,
      "userIndexId": "" + userIndexId,
      "type": "" + type,
    };
    if (id.isEmpty || id.length == 0) {
      inputs = {
        "shopIndexId": "" + shopIndexId,
        "userIndexId": "" + userIndexId,
        "type": "" + type,
      };
    } else {
      inputs = {
        "userIndexId": "" + userIndexId,
        "shopIndexId": "" + shopIndexId,
        "offerId": "" + id,
        "type": "offers",
      };
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      provider = Provider.of<ManageBusinessProvider>(context, listen: false);
      provider.updateContext(contexts: context);
      provider.getLead(inputs);
    });
  }

  @override
  void initState() {
    businessLeadsModel.errorCode = 1;
    businessLeadsModel.message = "";
    loadingServiceDetails();

    print("datas  " + widget.datas["id"].toString());
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
      "Lead Generation",
      context,
      Scaffold(
        body: Container(
          color: Colors.white,
          child: Consumer<ManageBusinessProvider>(
            builder: (context, provider, child) {
              _isLoading = provider.isLoading;
              businessLeadsModel = provider.businessLeadsModel;

              return Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  businessLeadsModel.errorCode == 0
                      ? Container(
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
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
                                              width: 160,
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Mobile",
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
                                                "District",
                                                style: TextStyle(
                                                  color: app_theam,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 80,
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Views",
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
                                                "Last Visited",
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
                                        i < businessLeadsModel.results!.length;
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

                                                  businessLeadsModel
                                                              .results![i]
                                                              .name ==
                                                          null
                                                      ? "-"
                                                      : businessLeadsModel
                                                            .results![i]
                                                            .name
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
                                                  businessLeadsModel
                                                              .results![i]
                                                              .mobile ==
                                                          null
                                                      ? "-"
                                                      : businessLeadsModel
                                                            .results![i]
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
                                                  businessLeadsModel
                                                              .results![i]
                                                              .district ==
                                                          null
                                                      ? "-"
                                                      : businessLeadsModel
                                                            .results![i]
                                                            .district
                                                            .toString(),
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 80,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  textAlign: TextAlign.center,
                                                  businessLeadsModel
                                                              .results![i]
                                                              .leads ==
                                                          null
                                                      ? "-"
                                                      : businessLeadsModel
                                                            .results![i]
                                                            .leads
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

                                                  businessLeadsModel
                                                              .results![i]
                                                              .time!
                                                              .toString() ==
                                                          ""
                                                      ? businessLeadsModel
                                                            .results![i]
                                                            .date!
                                                      : "${businessLeadsModel.results![i].date!}\n${businessLeadsModel.results![i].time!}",
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
                                              Container(width: 160),
                                              Container(width: 160),
                                              Container(width: 80),
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
                          ),
                        )
                      : Center(
                          child: Text(
                            businessLeadsModel.message!,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                  _isLoading != false
                      ? Container(
                          color: Colors.white,
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 80,
                                  height: 80,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(top: 10),
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("assets/load.gif"),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: const Text(
                                    "Loading...",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      // child: Loader(loadingTxt: 'Loading...'))
                      : Container(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
