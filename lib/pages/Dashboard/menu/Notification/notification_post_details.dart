import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/Api/service.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/ads_history_reports.dart';
import 'package:localkart/model/dashboard/servicesDetailsMoreModel.dart';
import 'package:localkart/model/dashboard/todayServicesDetailsModel.dart';
import 'package:localkart/model/notification_list.dart';
import 'package:localkart/pages/Dashboard/DayTypes/moreDetails/report_shop.dart';
import 'package:localkart/pages/Dashboard/DayTypes/moreDetails/service_more_multity_deals.dart';
import 'package:localkart/pages/Dashboard/DayTypes/moreDetails/service_more_single_deal.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';
import 'package:screenshot/screenshot.dart';

class PostNotyDetails extends StatefulWidget {
  String shopIndexId;
  String postIndexId;
  String postType;

  PostNotyDetails({
    Key? key,
    required this.shopIndexId,
    required this.postIndexId,
    required this.postType,
  }) : super(key: key);

  @override
  State<PostNotyDetails> createState() => _PostNotyDetails();
}

class _PostNotyDetails extends State<PostNotyDetails>
    with WidgetsBindingObserver {
  late BuildContext contextMain;
  bool _isLoading = true;
  int selection = 0;
  late TodayServiceMoreModel notificationDetails = TodayServiceMoreModel();

  notifyDetails() async {
    setState(() {
      _isLoading = true;
    });

    String url = '$subBase/viewpostdetails';
    var latitude = "" + await DBHelper().getLocationDetailsDB(true);
    var longitude = "" + await DBHelper().getLocationDetailsDB(false);

    var inputs = {
      'shopIndexId': widget.shopIndexId,
      'postIndexId': widget.postIndexId,
      'shopType': widget.postType,
      'latitude': latitude,
      'longitude': longitude,
    };
    var responces = await ApiClientLocalKart().httpPost(inputs, url);
    try {
      setState(() {
        _isLoading = false;
      });

      try {
        var responce = "" + responces.body.toString();
        var datas = json.decode(responce);
        try {
          if (datas['errorCode'].toString() == "0") {
            notificationDetails = TodayServiceMoreModel.fromJson(datas);
            setState(() {});
          }
        } catch (e) {
          print("services details err  " + e.toString());
        }
        // print(
        //     "adsGetReportModel - " + adsGetReportModel.message.toString());

        // AccessOptions accessOptions = new AccessOptions();

        // for (int i = 0; i <notificationDetails.result!.accessOptions!.length; i++) {
        //   print("ads opction " +
        //      notificationDetails.result!.accessOptions![i].keyName!.toString());

        //   if (i == adsGetReportModel.result!.accessOptions! - 1) {
        //     accessOptions =notificationDetails.result!.accessOptions![i];
        //   } else {
        //     //notificationDetails.result!.accessOptions!.removeAt(i);
        //   }
        // }

        //notificationDetails.result!.accessOptions = [];
        //notificationDetails.result!.accessOptions!.add(accessOptions);
        setState(() {});
      } catch (e) {}
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // updatepostviewcount() async {
  //   var loginProfile = await DBHelper().getLoginAllDB();
  //   print("loginProfile is " + loginProfile.toString());
  //   var data = jsonDecode(loginProfile);
  //   int userId = data['result']['Id'];
  //
  //   var inputs = {
  //     "shop_id": "" + servicesMain.result![selection].shopIndexId.toString(),
  //     "offer_id":
  //     "" + "" + servicesMain.result![selection].postIndexId.toString(),
  //     "user_id": "" + userId.toString(),
  //   };
  //
  //   var responces = await HttpClients(context).httpposthistoryviewcount(inputs);
  //   print("object " + responces.toString());
  // }

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
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Screenshot(
                controller: screenshotController,
                child: notificationDetails.errorCode == 0
                    ? SingleChildScrollView(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Column(
                                    children: [
                                      InkWell(
                                        child: Container(
                                          color: Colors.white,
                                          child: ImageSlideshow(
                                            /// Width of the [ImageSlideshow].
                                            width: double.infinity,

                                            /// Height of the [ImageSlideshow].
                                            height: isWindows ? 600 - 30 : 200,

                                            /// The page to show when first creating the [ImageSlideshow].
                                            initialPage: 0,

                                            /// The color to paint the indicator.
                                            indicatorColor: app_theam,

                                            /// The color to paint behind th indicator.
                                            indicatorBackgroundColor:
                                                Colors.grey,

                                            /// Called whenever the page in the center of the viewport changes.
                                            onPageChanged: (value) {
                                              select_posication = int.parse(
                                                value.toString(),
                                              );
                                              // print(
                                              //   'Page changed s : $select_posication',
                                              // );

                                              setState(() {});
                                            },
                                            autoPlayInterval: 6000,
                                            isLoop: true,

                                            /// The widgets to display in the [ImageSlideshow].
                                            /// Add the sample image file into the images folder
                                            children: [
                                              for (var items
                                                  in notificationDetails
                                                      .result!
                                                      .shopImageList!)
                                                ClipRRect(
                                                  child: Container(
                                                    child: Image.network(
                                                      items.imageUrl.toString(),
                                                      fit: BoxFit.cover,
                                                      loadingBuilder:
                                                          (
                                                            context,
                                                            child,
                                                            loadingProgress,
                                                          ) {
                                                            if (loadingProgress ==
                                                                null)
                                                              return child;

                                                            return Container(
                                                              decoration: BoxDecoration(
                                                                image: DecorationImage(
                                                                  image: AssetImage(
                                                                    "assets/loading.gif",
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                      errorBuilder:
                                                          (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) {
                                                            return Image.asset(
                                                              "assets/logo_with_name1.png",
                                                            );
                                                          },
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          String url = notificationDetails
                                              .result!
                                              .shopImageList![select_posication]
                                              .imageUrl
                                              .toString();
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                color: app_colorSecondary,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  notificationDetails.result!.shopName
                                      .toString()
                                      .toUpperCase(),
                                  style: TextStyle(
                                    color: app_theam,
                                    fontSize: 16,
                                  ),
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
                                      "Date",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Color(0xFF616161),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        notificationDetails.result!.fromDate
                                                .toString() +
                                            " To " +
                                            notificationDetails.result!.toDate
                                                .toString(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
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
                                      "Direction",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Color(0xFF616161),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        notificationDetails.result!.distance
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      child: ListView.builder(
                                        itemCount: 1,
                                        shrinkWrap: true,
                                        primary: false,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                              return _itemListAccess(
                                                context,
                                                index,
                                              );
                                            },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              notificationDetails
                                          .result!
                                          .shopOfferList!
                                          .length ==
                                      0
                                  ? Container(width: 1, height: 1)
                                  : Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          left: 10,
                                          bottom: 5,
                                        ),
                                        child: Text(
                                          "DEAL",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: app_theam,
                                          ),
                                        ),
                                      ),
                                    ),
                              Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    notificationDetails
                                                .result!
                                                .shopOfferList!
                                                .length ==
                                            0
                                        ? Container(width: 1, height: 1)
                                        : Container(
                                            child: ListView.builder(
                                              itemCount: notificationDetails
                                                  .result!
                                                  .shopOfferList!
                                                  .length,
                                              shrinkWrap: true,
                                              primary: false,
                                              itemBuilder:
                                                  (
                                                    BuildContext context,
                                                    int index,
                                                  ) {
                                                    return _itemListDeals(
                                                      context,
                                                      index,
                                                    );
                                                  },
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      )
                    : Container(),
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
                  // child: Loader(loadingTxt: 'Loading...'))
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  late BuildContext contexts;

  Widget _itemListAccess(BuildContext context, int index) {
    return Container(
      child: InkWell(
        child: Container(
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                notificationDetails.result!.accessOptions!.key!.toString(),
                style: TextStyle(fontSize: 15, color: Color(0xFF616161)),
              ),
              Flexible(
                child: Text(
                  notificationDetails.result!.accessOptions!.value.toString(),
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          if (notificationDetails.result!.accessOptions!.key!.toString() ==
              "Phone") {
            launchInCall(
              notificationDetails.result!.accessOptions!.value.toString(),
            );
          } else if (notificationDetails.result!.accessOptions!.key!
                  .toString() ==
              "Alternate Number") {
            launchInCall(
              notificationDetails.result!.accessOptions!.value.toString(),
            );
          } else if (notificationDetails.result!.accessOptions!.key!
                  .toString() ==
              "Mobile") {
            launchInCall(
              notificationDetails.result!.accessOptions!.value.toString(),
            );
          } else if (notificationDetails.result!.accessOptions!.key!
                  .toString() ==
              "WhatsApp") {
            launchInWhatsapp(
              notificationDetails.result!.accessOptions!.value.toString(),
              "",
            );
          } else if (notificationDetails.result!.accessOptions!.key!
                  .toString() ==
              "Website") {
            var url = notificationDetails.result!.accessOptions!.value
                .toString();
            launchInBrowser(url);
          } else if (notificationDetails.result!.accessOptions!.key!
                  .toString() ==
              "Facebook") {
            var url = notificationDetails.result!.accessOptions!.value
                .toString();
            launchInBrowser(url);
          } else if (notificationDetails.result!.accessOptions!.key!
                  .toString() ==
              "Email") {
            launchInMail(
              notificationDetails.result!.accessOptions!.value.toString(),
            );
          }

          // launchInBrowser(notificationDetails.result!.shopWebsite.toString());
        },
      ),
    );
  }

  Widget _itemListDeals(BuildContext context, int index) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(left: 5, right: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Flexible(
              child: Card(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.grey, Colors.grey],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                          child: Image.network(
                            notificationDetails
                                .result!
                                .shopOfferList![index]
                                .offerImage
                                .toString(),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset("assets/logo_with_name.png");
                            },
                          ),
                        ),
                      ),
                      Expanded(
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
                                    notificationDetails
                                        .result!
                                        .shopOfferList![index]
                                        .heading
                                        .toString()
                                        .toUpperCase(),
                                    maxLines: 1,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    notificationDetails
                                        .result!
                                        .shopOfferList![index]
                                        .description
                                        .toString(),
                                    maxLines: 2,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
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
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        print(
          "repor details " +
              notificationDetails.result!.shopOfferList!.length.toString(),
        );
        if (notificationDetails.result!.shopOfferList!.length == 1) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TodayMoreDetails2(
                index: index,
                services: notificationDetails,
                isJob: false,
              ),
            ),
          );
        } else {
          // Navigator.of(context).pushReplacement(MaterialPageRoute(
          //     builder: (context) =>
          //         DelarMoreDetails( index: index ,services: services)));
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DelarMoreDetails(
                index: index,
                services: notificationDetails,
                isJob: false,
              ),
            ),
          );
        }
      },
    );
  }

  var Uint8List = null;
  late ScreenshotController screenshotController = ScreenshotController();
}
