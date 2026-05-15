import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/ads_history.dart';
import 'package:localkart/model/ads_history_reports.dart';
import 'package:localkart/model/dashboard/servicesDetailsMoreModel.dart';
import 'package:localkart/pages/Dashboard/manage_business/ads/report_shop_updates.dart';
import 'package:localkart/pages/Dashboard/manage_business/ads/repost_single_view.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/image_zooming.dart';
import 'package:localkart/unit/showing.dart';
import 'package:screenshot/screenshot.dart';

class AdsMoreDetails extends StatefulWidget {
  Result adsHistoryModel;

  AdsMoreDetails({Key? key, required this.adsHistoryModel}) : super(key: key);

  @override
  State<AdsMoreDetails> createState() => _AdsMoreDetails();
}

class _AdsMoreDetails extends State<AdsMoreDetails> {
  late BuildContext contextMain;
  bool _isLoading = true;

  late ServiceDetailsMoreModel services = new ServiceDetailsMoreModel();

  late AdsGetReportModel adsGetReportModel = new AdsGetReportModel();

  loadingServiceDetails() async {
    var shopIndexId = "" + await DBHelper().getLoginDB("shopId");
    var type = "" + await DBHelper().getLoginDB("type");

    String latitude = await DBHelper().getLocationDetailsDB(true);
    String longitude = await DBHelper().getLocationDetailsDB(false);

    setState(() {
      _isLoading = true;
    });
    Map<String, Object> inputs = {
      "shopIndexId": "" + shopIndexId,
      "shopType": "" + type,
      "latitude": "" + latitude,
      "longitude": "" + longitude,
    };

    var responces = await ApiClientLocalKart().httpPost(
      inputs,
      urlDirectoryMore,
    );

    try {
      setState(() {
        _isLoading = false;
      });

      try {
        var responce = "" + responces.body.toString();
        var datas = json.decode(responce);

        try {
          if (datas['errorCode'].toString() == "0") {
            print("accrss " + datas.toString());
            services = ServiceDetailsMoreModel.fromJson(datas);
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

  loadingGetRepostDetails() async {
    setState(() {
      _isLoading = true;
    });
    Map<String, Object> inputs = {
      "oldPostIndexId": "" + widget.adsHistoryModel.postIndexId.toString(),
    };

    var responces = await ApiClientLocalKart().httpPost(inputs, urlGetReports);
    try {
      setState(() {
        _isLoading = false;
      });

      try {
        var responce = "" + responces.body.toString();
        var datas = json.decode(responce);
        print(" adsGetReportModel " + datas.toString());
        try {
          if (datas['errorCode'].toString() == "0") {
            adsGetReportModel = AdsGetReportModel.fromJson(datas);
            print(
              "adsGetReportModel - " + adsGetReportModel.message.toString(),
            );
            setState(() {});
            loadingServiceDetails();
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
    services.errorCode = 1;
    adsGetReportModel.errorCode = 1;
    loadingGetRepostDetails();
    super.initState();
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

    setState(() {
      // if (MediaQuery.of(context).size.width < check_windows_size) {
      //   isWindows = false;
      // } else {
      //   isWindows = true;
      // }
    });
    return actionBarTopBottomView(
      "Ads More Details",
      context,

      Scaffold(
        body: Container(
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Screenshot(
                controller: screenshotController,
                child: services.errorCode == 0
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
                                            height: isWindows
                                                ? MediaQuery.of(
                                                        context,
                                                      ).size.width -
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.height -
                                                      30
                                                : 200,

                                            /// The page to show when first creating the [ImageSlideshow].
                                            initialPage: 0,

                                            /// The color to paint the indicator.
                                            indicatorColor: app_theam,

                                            /// The color to paint behind th indicator.
                                            indicatorBackgroundColor:
                                                Colors.grey,

                                            /// The widgets to display in the [ImageSlideshow].
                                            /// Add the sample image file into the images folder
                                            children: [
                                              for (var items
                                                  in services
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

                                            /// Called whenever the page in the center of the viewport changes.
                                            onPageChanged: (value) {
                                              select_posication = int.parse(
                                                value.toString(),
                                              );
                                              print(
                                                'Page changed s : $select_posication',
                                              );

                                              setState(() {});
                                            },
                                            autoPlayInterval: 6000,
                                            isLoop: true,
                                          ),
                                        ),
                                        onTap: () {
                                          String url = services
                                              .result!
                                              .shopImageList![select_posication]
                                              .imageUrl
                                              .toString();

                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => ZoomingImages(
                                                title:
                                                    "" +
                                                    services.result!.shopName!
                                                        .toString(),
                                                image: services
                                                    .result!
                                                    .shopImageList![select_posication]
                                                    .imageUrl
                                                    .toString(),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    left: 10,
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10),
                                      padding: EdgeInsets.all(1),
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color(0xFFee77ad),
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Container(
                                          // margin: EdgeInsets.all(.5),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                            child: Container(
                                              child: Image.network(
                                                services.result!.shopLogo
                                                    .toString(),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                color: app_theam[100],
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  services.result!.shopName
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
                                        changeDateFormate(
                                              adsGetReportModel.result!.fromDate
                                                  .toString(),
                                            ) +
                                            " To " +
                                            changeDateFormate(
                                              adsGetReportModel.result!.toDate
                                                  .toString(),
                                            ),
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
                                        itemCount: services
                                            .result!
                                            .accessOptions!
                                            .length,
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
                              InkWell(
                                child: Container(
                                  padding: EdgeInsets.all(10),
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
                                      Text(
                                        services.result!.distance.toString(),
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  shareDistaince(
                                    services.result!.shopLatitude.toString() +
                                        "," +
                                        services.result!.shopLongitude
                                            .toString(),
                                  );
                                },
                              ),
                              SizedBox(height: 5),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  padding: EdgeInsets.only(left: 10, bottom: 5),
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
                                  children: [_columnOrListView()],
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
        bottomNavigationBar: repostOption == false
            ? Container(height: 1, width: 1)
            : Container(
                color: Colors.white,
                child: Row(
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
                          ),
                          margin: EdgeInsets.only(right: 1),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                " Back ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(height: 45, width: 1, color: Colors.grey[200]),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ReportThisShopUpdate(
                                postIndexId: widget.adsHistoryModel.postIndexId
                                    .toString(),
                                adsHistory: adsGetReportModel,
                              ),
                            ),
                          );
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
                                " Repost ",
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

  bool repostOption = false;

  Widget _columnOrListView() {
    try {
      repostOption = true;
      return ListView.builder(
        itemCount: adsGetReportModel.result!.offerImageList!.length,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (BuildContext context, int index) {
          return _itemListDeals(context, index);
        },
      );
    } catch (e) {
      repostOption = false;
      return Container(height: 1, width: 1);
    }
  }

  Widget _itemListAccess(BuildContext context, int index) {
    return Container(
      child: InkWell(
        child: Container(
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                services.result!.accessOptions![index].keyName.toString(),
                style: TextStyle(fontSize: 15, color: Color(0xFF616161)),
              ),
              Flexible(
                child: Text(
                  services.result!.accessOptions![index].value.toString(),
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          print(
            "sandy mobile " +
                services.result!.accessOptions![index].keyName.toString(),
          );

          if (services.result!.accessOptions![index].keyName.toString() ==
              "Phone") {
            launchInCall(
              services.result!.accessOptions![index].value.toString(),
            );
          } else if (services.result!.accessOptions![index].keyName
                  .toString() ==
              "Alternate Number") {
            launchInCall(
              services.result!.accessOptions![index].value.toString(),
            );
          } else if (services.result!.accessOptions![index].keyName
                  .toString() ==
              "Mobile") {
            launchInCall(
              services.result!.accessOptions![index].value.toString(),
            );
          } else if (services.result!.accessOptions![index].keyName
                  .toString() ==
              "WhatsApp") {
            launchInWhatsapp(
              services.result!.accessOptions![index].value.toString(),
              "",
            );
          } else if (services.result!.accessOptions![index].keyName
                  .toString() ==
              "Website") {
            var url = services.result!.accessOptions![index].value.toString();
            launchInBrowser(url);
          } else if (services.result!.accessOptions![index].keyName
                  .toString() ==
              "Facebook") {
            var url = services.result!.accessOptions![index].value.toString();
            launchInBrowser(url);
          } else if (services.result!.accessOptions![index].keyName
                  .toString() ==
              "Email") {
            launchInMail(
              services.result!.accessOptions![index].value.toString(),
            );
          }

          // launchInBrowser(services.result!.shopWebsite.toString());
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
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/logo_with_name1.png"),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(color: gradint_start_color, width: 1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          child: Image.network(
                            adsGetReportModel
                                .result!
                                .offerImageList![index]
                                .offerImage
                                .toString(),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset("assets/logo_with_name1.png");
                            },
                          ),
                        ),
                      ),

                      // Expanded(
                      //     child: Container(
                      //         color: Colors.grey, child: Text("teste ")))
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
                                    adsGetReportModel
                                        .result!
                                        .offerImageList![index]
                                        .heading
                                        .toString()
                                        .toUpperCase(),
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
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
                                    adsGetReportModel
                                        .result!
                                        .offerImageList![index]
                                        .description
                                        .toString(),
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
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RepostSinglePrevews(
              images:
                  "" +
                  adsGetReportModel.result!.offerImageList![index].offerImage
                      .toString(),
              title:
                  "" +
                  adsGetReportModel.result!.offerImageList![index].heading
                      .toString(),
              desc: adsGetReportModel.result!.offerImageList![index].description
                  .toString(),
              deal: "" + (index + 1).toString(),
            ),
          ),
        );

        // if (adsGetReportModel.result!.offerImageList!.length == 1) {
        //   // Navigator.of(context).push(MaterialPageRoute(
        //   //     builder: (context) => NotificationDetailsMore(
        //   //         index: index,
        //   //         postIndexId: int.parse(
        //   //             widget.adsHistoryModel.postIndexId.toString()))));
        //
        //   Navigator.of(context).push(
        //     MaterialPageRoute(
        //       builder: (context) => PageViewDemo(
        //         adsGetReportModel: adsGetReportModel,
        //         index: index,
        //       ),
        //     ),
        //   );
        // } else {
        //   Navigator.of(context).push(
        //     MaterialPageRoute(
        //       builder: (context) => PageViewDemo(
        //         adsGetReportModel: adsGetReportModel,
        //         index: index,
        //       ),
        //     ),
        //   );
        // }
      },
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
