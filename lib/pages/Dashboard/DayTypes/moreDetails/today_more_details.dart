import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:screenshot/screenshot.dart';

import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:localkart/model/dashboard/todayServicesDetailsModel.dart';
import 'package:localkart/model/dashboard/todayServicesListModel.dart';
import 'package:localkart/pages/Dashboard/DayTypes/moreDetails/service_more_multity_deals.dart';
import 'package:localkart/pages/Dashboard/DayTypes/moreDetails/service_more_single_deal.dart';
import 'package:screenshot/screenshot.dart';
import 'package:localkart/Api/service.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/pages/Dashboard/DayTypes/moreDetails/report_shop.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/showing.dart';

class TodayMoreDetails extends StatefulWidget {
  TodayServiceListModel result;
  int indexs;

  TodayMoreDetails({Key? key, required this.result, required this.indexs})
    : super(key: key);

  @override
  _TodayMoreDetails createState() => _TodayMoreDetails();
}

class _TodayMoreDetails extends State<TodayMoreDetails> {
  late TodayServiceListModel servicesMain;

  late BuildContext contextMain;
  var selection = 0;
  bool _isLoading = false;

  late TodayServiceMoreModel services = new TodayServiceMoreModel();

  loadingServiceDetails() async {
    setState(() {
      _isLoading = true;
    });

    var latitude = "" + await DBHelper().getLocationDetailsDB(true);
    var longitude = "" + await DBHelper().getLocationDetailsDB(false);
    Map<String, Object> inputs = {
      "shopIndexId":
          "" + servicesMain.result![selection].shopIndexId.toString(),
      "shopType": "" + "" + servicesMain.result![selection].type.toString(),
      "postIndexId":
          "" + "" + servicesMain.result![selection].postIndexId.toString(),
      "latitude": latitude,
      "longitude": longitude,
    };
    print("viewpostdetails --" + jsonEncode(inputs));
    var responces = await HttpClients(
      context,
    ).httpServicesTyepe("viewpostdetails", inputs);
    try {
      setState(() {
        _isLoading = false;
      });

      try {
        var responce = "" + responces.body.toString();
        var datas = json.decode(responce);
        try {
          if (datas['errorCode'].toString() == "0") {
            services = TodayServiceMoreModel.fromJson(datas);

            try {
              if (services.result!.shopOfferList!.length == 0) {
                services.result!.shopOfferList = [];
              } else {
                services.result!.shopOfferList = services.result!.shopOfferList;
              }

              print(
                "service images loading success hema2- " +
                    services.result!.shopOfferList!.length.toString(),
              );
            } catch (ex) {
              print("service images loading error - " + ex.toString());
              services.result!.shopOfferList = [];

              print(
                "service images loading" +
                    services.result!.shopOfferList!.length.toString(),
              );
            }

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

  updatepostviewcount() async {
    var loginProfile = await DBHelper().getLoginAllDB();
    print("loginProfile is " + loginProfile.toString());
    var data = jsonDecode(loginProfile);
    int userId = data['result']['Id'];

    var inputs = {
      "shop_id": "" + servicesMain.result![selection].shopIndexId.toString(),
      "offer_id":
          "" + "" + servicesMain.result![selection].postIndexId.toString(),
      "user_id": "" + userId.toString(),
    };

    var responces = await HttpClients(context).httpposthistoryviewcount(inputs);
    print("object " + responces.toString());
  }

  @override
  void initState() {
    servicesMain = widget.result;
    services.errorCode = 1;
    selection = widget.indexs;

    loadingServiceDetails();
    updatepostviewcount();
    super.initState();
  }

  var isWindows = false;
  int select_posication = 0;

  @override
  Widget build(BuildContext context) {
    contextMain = context;
    setState(() {});
    return actionBarTopBottomView(
      "More Details",
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
                                            height: isWindows ? 600 - 30 : 200,

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
                                              // print(
                                              //   'Page changed s : $select_posication',
                                              // );

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

                                          // Navigator.of(context).push(
                                          //   MaterialPageRoute(
                                          //     builder: (context) => ZoomingImages(
                                          //       title:
                                          //           "" +
                                          //           services.result!.shopName!
                                          //               .toString(),
                                          //       image: services
                                          //           .result!
                                          //           .shopImageList![select_posication]
                                          //           .imageUrl
                                          //           .toString(),
                                          //     ),
                                          //   ),
                                          // );
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
                                        services.result!.fromDate.toString() +
                                            " To " +
                                            services.result!.toDate.toString(),
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
                                        services.result!.distance.toString(),
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
                              services.result!.shopOfferList!.length == 0
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
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                              Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    services.result!.shopOfferList!.length == 0
                                        ? Container(width: 1, height: 1)
                                        : Container(
                                            child: ListView.builder(
                                              itemCount: services
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
                              InkWell(
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    "Report This Shop",
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ReportThisShop(
                                        type:
                                            "" +
                                            servicesMain.result![selection].type
                                                .toString(),
                                        shopIndexId:
                                            "" +
                                            servicesMain
                                                .result![selection]
                                                .shopIndexId
                                                .toString(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 15),
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
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(gradient: gradient_btn_lift),
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        servicesMain.result![selection].isSubscribed
                                    .toString() ==
                                "1"
                            ? Icon(
                                Icons.notifications_active,
                                color: Colors.white,
                                size: 22,
                              )
                            : Icon(
                                Icons.notifications,
                                color: Colors.white,
                                size: 22,
                              ),
                        servicesMain.result![selection].isSubscribed
                                    .toString() ==
                                "1"
                            ? Text(
                                "  Unsubscribe",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              )
                            : Text(
                                "  Subscribe",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                      ],
                    ),
                    onTap: () {
                      ShowSubscribeLocal(context);
                    },
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (services.result!.shopOfferList!.length == 0) {
                      shareServicesDetails(
                        services.result!.shopName.toString() +
                            "\n\n" +
                            "Valid From " +
                            services.result!.fromDate!.toString() +
                            " To " +
                            services.result!.toDate!.toString(),
                        "https://bit.ly/3Bo6WNb",
                      );
                    } else if (services.result!.shopOfferList!.length == 1) {
                      shareServicesDetails(
                        services.result!.shopName.toString() +
                            "\n\n" +
                            "Valid From " +
                            services.result!.fromDate!.toString() +
                            " To " +
                            services.result!.fromDate!.toString() +
                            "\n\n" +
                            services.result!.shopOfferList![0].heading
                                .toString() +
                            "\n\n " +
                            services.result!.shopOfferList![0].description
                                .toString(),
                        "https://bit.ly/3Bo6WNb",
                      );
                    } else {
                      shareServicesDetails(
                        services.result!.shopName.toString() +
                            "\n\n" +
                            "Valid From " +
                            services.result!.fromDate!.toString() +
                            " To " +
                            services.result!.fromDate!.toString() +
                            "\n\n" +
                            services.result!.shopOfferList![0].heading
                                .toString() +
                            "\n\n " +
                            services.result!.shopOfferList![0].description
                                .toString() +
                            "\n\n and  " +
                            (services.result!.shopOfferList!.length - 1)
                                .toString() +
                            " more deals",
                        "https://bit.ly/3Bo6WNb",
                      );
                    }
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(gradient: gradient_btn_rigth),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.share, color: Colors.white, size: 24),
                        Text(
                          " Share",
                          style: TextStyle(color: Colors.white, fontSize: 15),
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

  ShowSubscribeLocal(BuildContext context) {
    String title = "";

    if (servicesMain.result![selection].isSubscribed.toString() == "0") {
      title = "Subscribe!";
    } else {
      title = "UnSubscribe!";
    }

    Widget yesButton = TextButton(
      child: Text("YES"),
      onPressed: () {
        // _apiSubScrition(
        //     services.type, services.shopIndexId, services.isSubscribed);
        Navigator.pop(contexts);

        _apiSubScrition(
          servicesMain.result![selection].type.toString(),
          servicesMain.result![selection].shopIndexId.toString(),
          servicesMain.result![selection].isSubscribed.toString(),
        );
      },
    );
    Widget noButton = TextButton(
      child: Text("NO"),
      onPressed: () {
        Navigator.pop(contexts);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: servicesMain.result![selection].name.toString().isEmpty
          ? Text("")
          : RichText(
              text: TextSpan(
                text: "You'll receive notifications when ",
                style: TextStyle(fontSize: 15, color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: "" + servicesMain.result![selection].name.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        '  posts new Deals and Offer.Are you sure want to $title',
                  ),
                ],
              ),
            ),
      actions: [noButton, yesButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        contexts = context;
        return alert;
      },
    );
  }

  late BuildContext contexts;

  _apiSubScrition(String types, String shopId, String isSub) async {
    var user_id = await DBHelper().getLoginSubDB("Id");

    String updateTypes = "savesubscribers";

    Map<String, String> inputs;
    if (isSub == "0") {
      updateTypes = "savesubscribers";
      inputs = {
        "userIndexId": "" + user_id,
        "shopId": shopId,
        "shopType": types,
      };
    } else {
      updateTypes = "unsubscribe";
      inputs = {
        "userIndexId": "" + user_id,
        "shopId": shopId,
        "shopType": types,
      };
    }

    var responces = await HttpClients(
      context,
    ).httpSubscription(updateTypes, inputs);
    try {
      try {
        var responce = "" + responces.body.toString();
        var datas = json.decode(responce);
        print("myres - " + datas.toString());

        if (datas['errorCode'] == 0) {
          setState(() {
            if (servicesMain.result![selection].isSubscribed.toString() ==
                "0") {
              servicesMain.result![selection].isSubscribed = 1;
            } else {
              servicesMain.result![selection].isSubscribed = 0;
            }

            print(
              " servicesMain.result![selection].isSubscribed " +
                  servicesMain.result![selection].isSubscribed.toString(),
            );
          });
        }
      } catch (e) {}
    } catch (e) {}
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
                services.result!.accessOptions!.key!.toString(),
                style: TextStyle(fontSize: 15, color: Color(0xFF616161)),
              ),
              Flexible(
                child: Text(
                  services.result!.accessOptions!.value.toString(),
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          if (services.result!.accessOptions!.key!.toString() == "Phone") {
            launchInCall(services.result!.accessOptions!.value.toString());
          } else if (services.result!.accessOptions!.key!.toString() ==
              "Alternate Number") {
            launchInCall(services.result!.accessOptions!.value.toString());
          } else if (services.result!.accessOptions!.key!.toString() ==
              "Mobile") {
            launchInCall(services.result!.accessOptions!.value.toString());
          } else if (services.result!.accessOptions!.key!.toString() ==
              "WhatsApp") {
            launchInWhatsapp(
              services.result!.accessOptions!.value.toString(),
              "",
            );
          } else if (services.result!.accessOptions!.key!.toString() ==
              "Website") {
            var url = services.result!.accessOptions!.value.toString();
            launchInBrowser(url);
          } else if (services.result!.accessOptions!.key!.toString() ==
              "Facebook") {
            var url = services.result!.accessOptions!.value.toString();
            launchInBrowser(url);
          } else if (services.result!.accessOptions!.key!.toString() ==
              "Email") {
            launchInMail(services.result!.accessOptions!.value.toString());
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
                            services.result!.shopOfferList![index].offerImage
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
                                    services
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
                                    services
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
          "repor details " + services.result!.shopOfferList!.length.toString(),
        );
        if (services.result!.shopOfferList!.length == 1) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TodayMoreDetails2(
                index: index,
                services: services,
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
                services: services,
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
