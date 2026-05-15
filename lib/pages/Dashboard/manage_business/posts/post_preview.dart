import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/ads_history_reports.dart';
import 'package:localkart/model/dashboard/servicesDetailsMoreModel.dart';
import 'package:localkart/pages/Dashboard/manage_business/ads/repost_single_view.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/image_zooming.dart';
import 'package:localkart/unit/showing.dart';
import 'package:screenshot/screenshot.dart';

class PreviewMoreDetails extends StatefulWidget {
  String postIndexId;

  PreviewMoreDetails({Key? key, required this.postIndexId}) : super(key: key);

  @override
  State<PreviewMoreDetails> createState() => _PreviewMoreDetails();
}

class _PreviewMoreDetails extends State<PreviewMoreDetails>
    with WidgetsBindingObserver {
  late BuildContext contextMain;
  bool _isLoading = true;

  late ServiceDetailsMoreModel services = ServiceDetailsMoreModel();

  late AdsGetReportModel adsGetReportModel = AdsGetReportModel();

  loadingServiceDetails() async {
    var shopIndexId = "" + await DBHelper().getLoginDB("shopId");
    var type = "" + await DBHelper().getLoginDB("type");
    var latitude = "" + await DBHelper().getLocationDetailsDB(true);
    var longitude = "" + await DBHelper().getLocationDetailsDB(false);
    setState(() {
      _isLoading = true;
    });
    Map<String, Object> inputs = {
      "shopIndexId": "" + shopIndexId,
      "shopType": "" + type.toString(),
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
            services = ServiceDetailsMoreModel.fromJson(datas);

            setState(() {});
            loadingGetRepostDetails();
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
      "oldPostIndexId": "" + widget.postIndexId.toString(),
    };

    var responces = await ApiClientLocalKart().httpPost(inputs, urlGetReports);

    try {
      setState(() {
        _isLoading = false;
      });

      try {
        var responce = "" + responces.body.toString();
        var datas = json.decode(responce);
        try {
          if (datas['errorCode'].toString() == "0") {
            adsGetReportModel = AdsGetReportModel.fromJson(datas);
            print(
              "adsGetReportModel - " + adsGetReportModel.message.toString(),
            );
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
    services.errorCode = 1;
    adsGetReportModel.errorCode = 1;
    loadingServiceDetails();

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

  @override
  Widget build(BuildContext context) {
    contextMain = context;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: app_theam,
        leading: IconButton(
          color: app_theam,
          icon: Icon(Icons.arrow_back_sharp, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Post Details"),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Screenshot(
            controller: screenshotController,
            child: adsGetReportModel.errorCode == 0
                ? SingleChildScrollView(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            children: [
                              InkWell(
                                child: Container(
                                  height: 200,
                                  width: double.infinity,
                                  child: Image.network(
                                    services.result!.shopImageList![0].imageUrl
                                        .toString(),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ZoomingImages(
                                        title: services.result!.shopName
                                            .toString(),
                                        image:
                                            "" +
                                            services
                                                .result!
                                                .shopImageList![0]
                                                .imageUrl
                                                .toString(),
                                      ),
                                    ),
                                  );
                                },
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
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.all(2),
                                      child: Container(
                                        child: Image.network(
                                          services.result!.shopLogo.toString(),
                                          fit: BoxFit.cover,
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
                              style: TextStyle(color: app_theam, fontSize: 16),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    itemCount:
                                        services.result!.accessOptions!.length,
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
                                    services.result!.shopLongitude.toString(),
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
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  child: ListView.builder(
                                    itemCount: adsGetReportModel
                                        .result!
                                        .offerImageList!
                                        .length,
                                    shrinkWrap: true,
                                    primary: false,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                          return _itemListDeals(context, index);
                                        },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            child: isWindows
                                ? Container(
                                    margin: EdgeInsets.only(
                                      top: 10,
                                      left: 15,
                                      right: 15,
                                      bottom: 5,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              height: 50,
                                              color: app_theam[400],
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.arrow_back,
                                                    color: Colors.white,
                                                    size: 24,
                                                  ),
                                                  Text(
                                                    " Back",
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
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              shareServicesDetails(
                                                services.result!.shopName
                                                        .toString() +
                                                    "\n\n"
                                                        "Valid From " +
                                                    changeDateFormate(
                                                      adsGetReportModel
                                                          .result!
                                                          .fromDate
                                                          .toString(),
                                                    ) +
                                                    " To " +
                                                    changeDateFormate(
                                                      adsGetReportModel
                                                          .result!
                                                          .toDate
                                                          .toString(),
                                                    ),
                                                "https://bit.ly/3Bo6WNb",
                                              );
                                              // Navigator.pop(context);
                                            },
                                            child: Container(
                                              height: 45,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    app_theam,
                                                    Color(0xFFf4a4c8),
                                                  ],
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    offset: Offset(5, 5),
                                                    blurRadius: 10,
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.share,
                                                    color: Colors.white,
                                                  ),
                                                  Text(
                                                    "  Share ",
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
                                  )
                                : Container(child: Text("")),
                          ),
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
                            style: TextStyle(color: Colors.black, fontSize: 18),
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

      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: isWindows == true
            ? Container(height: 1)
            : Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        shareServicesDetails(
                          services.result!.shopName.toString() +
                              "\n\n"
                                  "Valid From " +
                              changeDateFormate(
                                adsGetReportModel.result!.fromDate.toString(),
                              ) +
                              " To " +
                              changeDateFormate(
                                adsGetReportModel.result!.toDate.toString(),
                              ),
                          "https://bit.ly/3Bo6WNb",
                        );
                      },
                      child: Container(
                        height: 50,
                        color: app_theam[400],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.share,
                              color: Colors.white,
                              size: 24,
                            ),
                            Text(
                              " Share",
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
    );
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
                child: InkWell(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                            child: Image.network(
                              adsGetReportModel
                                  .result!
                                  .offerImageList![index]
                                  .offerImage
                                  .toString(),
                              fit: BoxFit.cover,
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
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RepostSinglePrevews(
                          images:
                              "" +
                              adsGetReportModel
                                  .result!
                                  .offerImageList![index]
                                  .offerImage
                                  .toString(),
                          title:
                              "" +
                              adsGetReportModel
                                  .result!
                                  .offerImageList![index]
                                  .heading
                                  .toString(),
                          desc:
                              "" +
                              adsGetReportModel
                                  .result!
                                  .offerImageList![index]
                                  .description
                                  .toString(),
                          deal: "" + (index + 1).toString(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        // if (adsGetReportModel.result!.offerImageList!.length == 1) {
        //   // Navigator.of(context).push(MaterialPageRoute(
        //   //     builder: (context) => NotificationDetailsMore(
        //   //         index: index,
        //   //         postIndexId: int.parse(widget.postIndexId.toString()))));
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
