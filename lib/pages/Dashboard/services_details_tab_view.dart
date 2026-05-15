import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localkart/Api/service.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/dashboard/todayServicesListModel.dart';
import 'package:localkart/pages/Dashboard/DayTypes/directorylist.dart';
import 'package:localkart/pages/Dashboard/DayTypes/falsh_sale.dart';
import 'package:localkart/pages/Dashboard/DayTypes/festivallist.dart';
import 'package:localkart/pages/Dashboard/DayTypes/job_list.dart';
import 'package:localkart/pages/Dashboard/DayTypes/todayList.dart';
import 'package:localkart/pages/Dashboard/DayTypes/weeklylist.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:provider/provider.dart';

class ServicesDetails extends StatefulWidget {
  dynamic roots;

  ServicesDetails({Key? key, required this.roots}) : super(key: key);

  @override
  State<ServicesDetails> createState() => _ServicesDetails();
}

class _ServicesDetails extends State<ServicesDetails> {
  String title = "";
  bool megaSale = false;

  String magasaleId = "0";
  String magaSaleTitle = "0";

  dynamic localRoots;

  late TodayServiceListModel result = new TodayServiceListModel();

  @override
  void initState() {
    title = widget.roots.sub_title.toString();
    localRoots = widget.roots;
    super.initState();
    loadingdetails();
  }

  String type = "";
  String catId = "";
  String subCatId = "";
  String latitude = "";
  String longitude = "";
  String userIndexId = "";
  String stateId = "";
  String districtId = "";
  String radius = "";

  loadingdetails() async {
    type = widget.roots.title.toString();
    catId = "" + widget.roots.services_id;
    subCatId = widget.roots.sub_services_id;
    latitude = "" + await DBHelper().getLocationDetailsDB(true);
    longitude = "" + await DBHelper().getLocationDetailsDB(false);
    userIndexId = "" + await DBHelper().getLoginSubDB("Id");
    stateId = "" + await DBHelper().getLoginSubDB("stateId");
    districtId = "" + await DBHelper().getLoginSubDB("districtId");
    radius = "0";

    setState(() {});

    Map<String, Object> inputs = {
      "type": "" + type.toString(),
      "catId": "" + catId.toString(),
      "subCatId": "" + subCatId.toString(),
      "latitude": "" + latitude.toString(),
      "longitude": "" + longitude.toString(),
      "userIndexId": "" + userIndexId.toString(),
      "stateId": "" + stateId.toString(),
      "districtId": "" + districtId.toString(),
      "radius": "" + radius.toString(),
    };
    await getSetvicesList(inputs);
  }

  getSetvicesList(inputs) async {
    var responces = await HttpClients(
      context,
    ).httpServicesTyepe("currentmegasales", inputs);
    try {
      try {
        var responce = "" + responces.body.toString();

        print("currentmegasales " + responce);
        var datas = json.decode(responce);

        if (datas['errorCode'].toString() == "0") {
          setState(() {
            megaSale = true;
            magasaleId = datas['result']['megasalesIndexId'].toString();
            magaSaleTitle = datas['result']['offerTitle'].toString();
          });
        }
      } catch (e) {}
    } catch (e) {}
  }

  late BuildContext context1;

  @override
  Widget build(BuildContext context) {
    return actionBarTopBottomView(
      title,
      context,
      DefaultTabController(
        length: megaSale == false ? 5 : 6,
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              width: double.infinity,
              constraints: BoxConstraints.expand(height: 45),
              child: TabBar(
                labelStyle: TextStyle(
                  fontSize: 12.0,
                  // fontFamily: 'Family Name',
                  color: app_theam,
                ),
                //For Selected tab
                isScrollable: true,
                tabAlignment: TabAlignment.start,

                // Forces alignment to the left edge
                unselectedLabelStyle: TextStyle(fontSize: 12.0),
                unselectedLabelColor: Colors.grey,
                labelColor: app_theam,
                tabs: [
                  if (megaSale == true) ...[
                    Tab(
                      child: Text(
                        magaSaleTitle.toString().toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                  const Tab(
                    child: Text(
                      "DIRECTORY",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Tab(
                    child: Text(
                      "TODAY",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Tab(
                    child: Text(
                      "WEEKLY",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Tab(
                    child: Text(
                      "FESTIVAL",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Tab(
                    child: Text(
                      "JOB OPENINGS",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Container(
            //   color: Color(0xFFD0CFCF),
            //   width: double.infinity,
            //   height: .3,
            // ),
            Expanded(
              child: TabBarView(
                children: [
                  if (megaSale == true) ...[
                    FleshSale(roots: localRoots, magasaleId: magasaleId),
                  ],
                  DirectoryList(roots: localRoots),
                  TodayList(roots: localRoots),
                  WeeklyListing(roots: localRoots),
                  FestivalList(roots: localRoots),
                  JobList(roots: localRoots),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
