import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/Api/service.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/ads_history_reports.dart';
import 'package:localkart/model/dashboard/servicesDetailsMoreModel.dart';
import 'package:localkart/model/notification_list.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';
import 'package:screenshot/screenshot.dart';

class NotificationDetails extends StatefulWidget {
  String notificationId;

  NotificationDetails({Key? key, required this.notificationId})
    : super(key: key);

  @override
  State<NotificationDetails> createState() => _NotificationDetails();
}

class _NotificationDetails extends State<NotificationDetails>
    with WidgetsBindingObserver {
  late BuildContext contextMain;
  bool _isLoading = true;

  late NotificationDetailModel notificationDetails = NotificationDetailModel();

  notifyDetails() async {
    setState(() {
      _isLoading = true;
    });

    String url =
        '$subBase/notificationinfo?userIndexId=' +
        await DBHelper().getLoginSubDB("Id") +
        "&id=" +
        widget.notificationId.toString();

    var responces = await ApiClientLocalKart().httpGet(url);
    try {
      setState(() {
        _isLoading = false;
      });

      try {
        var responce = "" + responces.body.toString();
        var datas = json.decode(responce);
        try {
          if (datas['errorCode'].toString() == "0") {
            notificationDetails = NotificationDetailModel.fromJson(datas);
            // print(
            //     "adsGetReportModel - " + adsGetReportModel.message.toString());

            // AccessOptions accessOptions = new AccessOptions();

            // for (int i = 0; i < services.result!.accessOptions!.length; i++) {
            //   print("ads opction " +
            //       services.result!.accessOptions![i].keyName!.toString());

            //   if (i == adsGetReportModel.result!.accessOptions! - 1) {
            //     accessOptions = services.result!.accessOptions![i];
            //   } else {
            //     // services.result!.accessOptions!.removeAt(i);
            //   }
            // }

            // services.result!.accessOptions = [];
            // services.result!.accessOptions!.add(accessOptions);
            setState(() {});
          }
        } catch (e) {
          print("services details err  " + e.toString());
        }
      } catch (e) {}
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    notificationDetails.errorCode = 1;
    // loadingServiceDetails();

    notifyDetails();
    print("reloading intro");
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    print("page close ");
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("reloading 1");

    if (state == AppLifecycleState.resumed) {
      //do your stuff
      print("reloading ");
    }
  }

  String changeDateFormate(String date) {
    var dates = "";

    try {
      var yy = date.toString().split("-")[0];
      var mm = date.toString().split("-")[1];
      var dd = date.toString().split("-")[2];

      dates = dd + "-" + mm + "-" + yy;
    } catch (e) {}
    return dates;
  }

  var isWindows = false;

  int select_posication = 0;

  @override
  Widget build(BuildContext context) {
    contextMain = context;

    setState(() {});

    return actionBarTopBottomView(
      "Notification Details",
      context,
      Scaffold(
        body: Container(
          color: Colors.white,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              _isLoading == true
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
                              decoration: new BoxDecoration(
                                image: new DecorationImage(
                                  image: new AssetImage("assets/load.gif"),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Text(
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
                  : notificationDetails.errorCode == 0
                  ? Screenshot(
                      controller: screenshotController,
                      child: Container(
                        // height: 230,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            Container(
                              // height: 220,
                              child: Image.network(
                                notificationDetails.result!.image.toString(),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset("assets/load.gif");
                                },
                              ),
                            ),

                            Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.only(top: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${notificationDetails.result!.content_type}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      // color: Color(0xFF616161),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      "${notificationDetails.result!.scheduled_date} ${notificationDetails.result!.time}",

                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              padding: EdgeInsets.all(10),
                              color: app_colorSecondary,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                notificationDetails.result!.title.toString(),
                                style: TextStyle(
                                  color: app_theam,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            Expanded(
                              child: SingleChildScrollView(
                                child: Container(

                                  margin: EdgeInsets.only(
                                    left: 12,
                                    right: 12,
                                    top: 10,
                                    bottom: 10,
                                  ),

                                  alignment: Alignment.topLeft,
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      notificationDetails.result!.description
                                          .toString(),

                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Center(child: Text("No Data Found.")),
            ],
          ),
        ),

        // bottomNavigationBar: Container(
        //   height: 50,
        //   decoration: BoxDecoration(gradient: app_gradient),
        //   child: BottomAppBar(
        //     padding: EdgeInsets.all(0),
        //     elevation: 0,
        //     child: isWindows == true
        //         ? Container(height: 1)
        //         : Row(
        //             children: [
        //               Expanded(
        //                 child: InkWell(
        //                   onTap: () {
        //                     print(
        //                       "details " +
        //                           notificationDetails.toJson().toString(),
        //                     );
        //                     // shareServicesDetails(
        //                     //   services.result!.shopName.toString() +
        //                     //       "\n\n"
        //                     //           "Valid From " +
        //                     //       changeDateFormate(
        //                     //         adsGetReportModel.result!.fromDate
        //                     //             .toString(),
        //                     //       ) +
        //                     //       " To " +
        //                     //       changeDateFormate(
        //                     //         adsGetReportModel.result!.toDate.toString(),
        //                     //       ),
        //                     //   "https://bit.ly/3Bo6WNb",
        //                     // );
        //                   },
        //                   child: Container(
        //                     height: 50,
        //                     decoration: BoxDecoration(gradient: app_gradient),
        //                     child: Row(
        //                       mainAxisAlignment: MainAxisAlignment.center,
        //                       children: [
        //                         const Icon(
        //                           Icons.share,
        //                           color: Colors.white,
        //                           size: 24,
        //                         ),
        //                         Text(
        //                           " Share",
        //                           style: TextStyle(
        //                             color: Colors.white,
        //                             fontSize: 15,
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //   ),
        // ),
      ),
    );
  }

  shareDistaince(location) async {
    String localLat =
        await DBHelper().getLocationDetailsDB(true) +
        "," +
        await DBHelper().getLocationDetailsDB(false);

    print("current location local " + location);

    var url =
        "https://www.google.com/maps/dir/$localLat/$location/@$localLat,11z";

    print("current location " + url);

    launchInBrowser(url);
  }

  var Uint8List = null;
  late ScreenshotController screenshotController = ScreenshotController();
}
