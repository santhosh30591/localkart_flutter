import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:localkart/Api/service.dart';
import 'package:localkart/RoutingSetup/router-constants.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/dashboard/servicesDetailsModel.dart';
import 'package:localkart/model/dashboard/servicesDetailsMoreModel.dart';
import 'package:localkart/pages/Dashboard/DayTypes/moreDetails/report_shop.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class ServicesMoreDetails extends StatefulWidget {
  dynamic setviceDetails;

  ServicesMoreDetails({Key? key, required this.setviceDetails})
    : super(key: key);

  @override
  _ServicesMoreDetails createState() => _ServicesMoreDetails();
}

class _ServicesMoreDetails extends State<ServicesMoreDetails> {
  late ServiceDetailsModel servicesMain;

  late BuildContext contextMain;
  bool _isLoading = true;
  late ServiceDetailsMoreModel services = new ServiceDetailsMoreModel();

  loadingServiceDetails() async {
    setState(() {
      _isLoading = true;
    });

    var latitude = "" + await DBHelper().getLocationDetailsDB(true);
    var longitude = "" + await DBHelper().getLocationDetailsDB(false);
    Map<String, Object> inputs = {
      "shopIndexId": "" + servicesMain.shopIndexId,
      "shopType": "" + servicesMain.type,
      "latitude": "" + latitude,
      "longitude": "" + longitude,
    };

    var responces = await HttpClients(
      context,
    ).httpServicesTyepe("directorymoredetails", inputs);
    try {
      setState(() {
        _isLoading = false;
      });

      try {
        var responce = "" + responces.body.toString();
        var datas = json.decode(responce);
        print("body json " + jsonEncode(inputs));

        print("directorymoredetails details " + responce.toString());
        try {
          if (datas['errorCode'].toString() == "0") {
            print("inside directorymoredetails 1 ");

            services = ServiceDetailsMoreModel.fromJson(datas);
            print("inside directorymoredetails ");
            address =
                "" +
                services.result!.shopDoorNo.toString() +
                ", " +
                services.result!.shopArea.toString() +
                ",\n" +
                services.result!.shopLocality.toString() +
                ", " +
                services.result!.shopPost.toString() +
                ",\n" +
                services.result!.shopLandmark.toString() +
                ",\n" +
                services.result!.shopDistrict.toString() +
                ", " +
                services.result!.shopPincode.toString() +
                ",\n" +
                services.result!.shopState.toString();
            print("adds " + address);
            address = address.replaceAll(".,", "");

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

  viewCountUpdate() async {
    print("viewCountUpdate ");
    var user_id = await DBHelper().getLoginSubDB("Id");

    if (servicesMain.type == "Shopping") {
      print("Calling shop viewcount");

      try {
        // shopviewcount
        var body = {"user_id": user_id, "shop_id": servicesMain.shopIndexId};
        print("sending body " + body.toString());
        var responces = await HttpClients(
          context,
        ).httpShopViewCountUpdate(body);
      } catch (e) {
        print("shop err--" + e.toString());
      }
    } else if (servicesMain.type == "Services") {
      print("Calling shop viewcount");

      try {
        // serviceviewcount
        var body = {"user_id": user_id, "service_id": servicesMain.shopIndexId};
        print("sending body " + body.toString());
        var responces = await HttpClients(
          context,
        ).httpServiceViewCountUpdate(body);
      } catch (e) {
        print("services err--" + e.toString());
      }
    }
  }

  @override
  void initState() {
    viewCountUpdate();
    services.errorCode = 1;
    servicesMain = widget.setviceDetails;
    loadingServiceDetails();
    RatingListing();
    super.initState();
  }

  var isWindows = false;
  int select_posication = 0;
  String address = "";

  @override
  Widget build(BuildContext context) {
    contextMain = context;

    setState(() {});

    return actionBarTopBottomView(
      "More Details",
      context,
      SafeArea(
        child: Scaffold(
          body: Container(
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                services.errorCode == 0
                    ? SingleChildScrollView(
                        child: Screenshot(
                          controller: screenshotController,
                          child: Container(
                            color: Colors.white,
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
                                            child: ImageSlideshow(
                                              /// Width of the [ImageSlideshow].
                                              width: double.infinity,

                                              /// Height of the [ImageSlideshow].
                                              height: isWindows
                                                  ? 600 - 30
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
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Color(
                                                            0xFFee77ad,
                                                          ),
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              6,
                                                            ),
                                                      ),
                                                      child: Image.network(
                                                        items.imageUrl
                                                            .toString(),
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
                                                                decoration: const BoxDecoration(
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
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    services.result!.shopDesc.toString(),
                                    style: TextStyle(fontSize: 16),
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
                                              (
                                                BuildContext context,
                                                int index,
                                              ) {
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
                                        const Text(
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
                                InkWell(
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color(0xFFee77ad),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 210,
                                          child: Column(
                                            children: [
                                              const Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  "Adderss",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  address + ".",
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Container(
                                            margin: EdgeInsets.only(right: 5),
                                            padding: EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.grey,
                                                  Colors.grey,
                                                ],
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Container(
                                              width: 70,
                                              height: 70,
                                              child: Image.network(
                                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvBfxs3AtpU2uJ26jzel7TDp5UFlyfSch40g&s',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
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
                                services.result!.shopServiceList!.length != 0
                                    ? Container(
                                        margin: EdgeInsets.only(left: 15),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(height: 10),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                "SERVICES OFFERED",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Container(
                                              child: ListView.builder(
                                                itemCount: services
                                                    .result!
                                                    .shopServiceList!
                                                    .length,
                                                shrinkWrap: true,
                                                primary: false,
                                                itemBuilder:
                                                    (
                                                      BuildContext context,
                                                      int index,
                                                    ) {
                                                      return _itemList(
                                                        context,
                                                        index,
                                                      );
                                                    },
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                SizedBox(height: 10),
                                Container(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: SingleChildScrollView(
                                    child: Row(
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 204,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              InkWell(
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                    right: 20,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        child: RatingBar.builder(
                                                          itemSize: 21.5,
                                                          initialRating:
                                                              double.parse(
                                                                services
                                                                    .result!
                                                                    .averageRating!,
                                                              ),
                                                          minRating: 0.1,
                                                          direction:
                                                              Axis.horizontal,
                                                          allowHalfRating: true,
                                                          tapOnlyMode: false,
                                                          ignoreGestures: true,
                                                          itemCount: 5,
                                                          itemPadding:
                                                              EdgeInsets.symmetric(
                                                                horizontal: 0.0,
                                                              ),
                                                          itemBuilder:
                                                              (
                                                                context,
                                                                _,
                                                              ) => Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .amber,
                                                                size: 1.0,
                                                              ),
                                                          onRatingUpdate: (rating) {
                                                            print(
                                                              "over all $rating ," +
                                                                  double.parse(
                                                                    services
                                                                        .result!
                                                                        .averageRating!,
                                                                  ).toString(),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      Text(
                                                        "${services.result!.averageRating}",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onTap: () {},
                                              ),
                                              SizedBox(height: 5),
                                              InkWell(
                                                child: Container(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "Rate This Shop ",
                                                        style: TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          fontSize: 16,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      // addRatingView(),
                                                    ],
                                                  ),
                                                ),
                                                onTap: () {
                                                  rating_dialog();
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Align(
                                              child: InkWell(
                                                child: Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // Text(""),
                                                      Text(
                                                        "${services.result!.viewCount} ",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Container(
                                                        // margin: EdgeInsets.only(bottom: 20),
                                                        child: Icon(
                                                          Icons.remove_red_eye,
                                                          size: 25,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onTap: () {},
                                              ),
                                            ),
                                            SizedBox(height: 5),

                                            InkWell(
                                              child: Container(
                                                // padding: EdgeInsets.all(5),
                                                child: const Text(
                                                  "Report This Shop",
                                                  style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    fontSize: 16,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ReportThisShop(
                                                          type:
                                                              "${servicesMain.type}",
                                                          shopIndexId:
                                                              servicesMain
                                                                  .shopIndexId,
                                                        ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        //
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(),
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
          bottomNavigationBar: Container(
            height: 45.0, // Set your custom height here
            // padding: EdgeInsets.only(left: 10, right: 10),
            child: Container(
              height: 45.0, // Set your custom height here
              // padding: EdgeInsets.only(left: 10, right: 10),
              child: BottomAppBar(
                height: 45.0, // Set your custom height here
                padding: EdgeInsets.all(0),
                elevation: 0,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          ShowAlertsToast(
                            "Subscribe!",
                            "" + widget.setviceDetails.title,
                          );
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: gradient_btn_lift,
                          ),
                          child: InkWell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                servicesMain.isSubscribed == "1"
                                    ? const Icon(
                                        Icons.notifications_active,
                                        size: 20,
                                        color: Colors.white,
                                      )
                                    : const Icon(
                                        Icons.notifications,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                servicesMain.isSubscribed == "1"
                                    ? const Text(
                                        "  Unsubscribe",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      )
                                    : const Text(
                                        "  Subscribe",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                              ],
                            ),
                            onTap: () {
                              ShowSubscribeLocal(context, servicesMain);
                            },
                          ),
                        ),
                      ),
                    ),
                    Container(height: 50, width: 2, color: Colors.white),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          showBottomSheetCustomeView(
                            context,
                            "Share Via",
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: new Icon(Icons.text_fields),
                                  title: new Text('Text'),
                                  onTap: () {
                                    setState(() {
                                      shareServicesDetails(
                                        '${services.result!.shopName}\n\nHere is my Digital vCard',
                                        services.result!.shareUrl.toString(),
                                      );
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: new Icon(Icons.image_sharp),
                                  title: new Text('Image'),
                                  onTap: () {
                                    setState(() {
                                      print(
                                        "images urls is ${services.result!.shareUrl}",
                                      );
                                      takescrshot(Uint8List);
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                                SizedBox(height: 80),
                              ],
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
                            children: [
                              const Icon(Icons.share, color: Colors.white),
                              Text(
                                "  Share  ",
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
          ),
        ),
      ),
    );
  }

  double UserRatings = 0;

  RatingListing() async {
    if (servicesMain.type == "Shopping") {
      var user_id = await DBHelper().getLoginSubDB("Id");
      var body = {"user_id": user_id, "shop_id": servicesMain.shopIndexId};
      print("Usershopratings body " + body.toString());
      var responces = await HttpClients(context).httpShopRatingListing(body);
      print("Usershop " + responces.body.toString());
      var res = jsonDecode(responces.body);
      print('res $res');
      if (res[0]['userRating'] != null) {
        setState(() {
          UserRatings = double.parse(res[0]['userRating'].toString());
        });
      } else if (res[0]['userRating'] == null) {
        setState(() {
          UserRatings = 0;
        });
      }
      setState(() {});

      print("ShopRatings " + UserRatings.toString());
    } else if (servicesMain.type == "Services") {
      var user_id = await DBHelper().getLoginSubDB("Id");
      var body = {"user_id": user_id, "service_id": servicesMain.shopIndexId};
      print("Userserviceratings body " + body.toString());
      var responces = await HttpClients(
        context,
      ).httpServicesRatingListing(body);
      print("Userservices  " + responces.body.toString());
      var res = jsonDecode(responces.body);
      if (res[0]['userRating'] != null) {
        setState(() {
          UserRatings = double.parse(res[0]['userRating'].toString());
        });
        //  return UserRatings =res[0]['userRating'];
      } else if (res[0]['userRating'] == null) {
        setState(() {
          UserRatings = 0;
        });
        //  return UserRatings =0;
      }

      print("SerRatings " + UserRatings.toString());
    }
  }

  rating_dialog() async {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double screenWidth = mediaQueryData.size.width;
    var userRating;
    // print("rating_dialog " +
    //     UserRatings.toString() +
    //     " " +
    //     UserRatings.toString());
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Rate this shop",
              style: TextStyle(color: Colors.black54),
            ),
          ),
          content: SizedBox(
            width: screenWidth * 0.7,
            child: RatingBar.builder(
              initialRating: userRating == 0 ? 0 : UserRatings,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) =>
                  Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {
                userRating = rating;
                print("submit rating " + rating.toString());
              },
            ),
          ),
          // addRatingView(),
          actions: [
            TextButton(
              child: Text("Cancel", style: TextStyle(color: Colors.black54)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Submit", style: TextStyle(color: Colors.black54)),
              onPressed: () async {
                print("Service type : " + servicesMain.type.toString());
                if (servicesMain.type == "Shopping") {
                  var user_id = await DBHelper().getLoginSubDB("Id");
                  var body = {
                    "user_id": user_id,
                    "shop_id": servicesMain.shopIndexId,
                    "rating": userRating,
                  };
                  print("shopratings body " + body.toString());
                  var responces = await HttpClients(
                    context,
                  ).httpShopRatingsUpdate(body);

                  // UserRatings=3.0;
                  UserRatings = await double.parse(userRating.toString());
                  setState(() {});

                  Navigator.of(context).pop();
                } else if (servicesMain.type == "Services") {
                  var user_id = await DBHelper().getLoginSubDB("Id");
                  var body = {
                    "user_id": user_id,
                    "service_id": servicesMain.shopIndexId,
                    "rating": userRating,
                  };
                  print("serviceratings body " + body.toString());
                  var responces = await HttpClients(
                    context,
                  ).httpServicesRatingsUpdate(body);

                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed(
                    root_services_more_details,
                    arguments: servicesMain,
                  );
                }

                Navigator.of(context).pushReplacementNamed(
                  root_services_more_details,
                  arguments: servicesMain,
                );
              },
            ),
          ],
        );
      },
    );
  }

  int _rating = 0;

  Widget addRatingView() {
    List<Widget> array = [];
    var filled = app_theam;
    var empty = Colors.grey;
    for (var i = 1; i <= 5; i++) {
      array.add(
        IconButton(
          icon: Icon(Icons.star),
          color: (_rating < i ? empty : filled),
          onPressed: () {
            setState(() {
              _rating = i;
              print("_rating " + _rating.toString());
            });
          },
        ),
      );
    }
    return Row(children: array, mainAxisAlignment: MainAxisAlignment.center);
  }

  int overall_rating = 3;

  Widget OverallRating() {
    List<Widget> array = [];
    var filled = app_theam;
    var empty = Colors.grey;
    for (var i = 1; i <= 5; i++) {
      array.add(
        IconButton(
          icon: Icon(Icons.star),
          color: (overall_rating < i ? empty : filled),
          onPressed: () {
            // setState(() {
            //   overall_rating = i;
            //   print("overall_rating " + overall_rating.toString());
            // });
          },
        ),
      );
    }
    return Container(
      // padding: EdgeInsets.all(2),
      child: Row(children: array, mainAxisAlignment: MainAxisAlignment.center),
    );
  }

  Widget _itemListAccess(BuildContext context, int index) {
    return Container(
      child: InkWell(
        child: Container(
          color: index % 2 == 0 ? const Color(0xFFf9d2e4) : Colors.white,
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

  Widget _itemList(BuildContext context, int index) {
    return Container(
      height: 35,
      child: Text(
        // services.result!.shopServiceList![index].serviceName.toString(),
        "  ${(index + 1)}) " +
            services.result!.shopServiceList![index].serviceName.toString(),
        style: TextStyle(color: Colors.black, fontSize: 16),
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

  takescrshot(Uint8List) async {
    ShowTost("Please wait....");
    screenshotController
        .capture()
        .then((image) async {
          // print("file path  image" + image.toString());
          Uint8List = image;
          Directory? directory;
          if (Platform.isAndroid) {
            directory = await getExternalStorageDirectory();
          } else {
            directory = await getApplicationDocumentsDirectory();
          }
          await takePicture(directory?.path.toString(), image);
          setState(() {});
        })
        .catchError((onError) {
          print(onError);
        });
  }

  ShowSubscribeLocal(BuildContext context, ServiceDetailsModel services) {
    String title = "";

    if (services.isSubscribed == "0") {
      title = "Subscribe!";
    } else {
      title = "UnSubscribe!";
    }

    Widget yesButton = TextButton(
      child: Text("YES"),
      onPressed: () {
        // _apiSubScrition(
        //     services.type, services.shopIndexId, services.isSubscribed);

        _apiSubScrition(
          services.type,
          services.shopIndexId,
          services.isSubscribed,
        );
        Navigator.pop(contexts);
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
      content: services.name.isEmpty
          ? const Text("")
          : RichText(
              text: TextSpan(
                text: "You'll receive notifications when ",
                style: TextStyle(fontSize: 15, color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: "" + services.name.toString(),
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
            if (servicesMain.isSubscribed == "0") {
              servicesMain.isSubscribed = "1";
            } else {
              servicesMain.isSubscribed = "0";
            }
          });
        }
      } catch (e) {}
    } catch (e) {}
  }

  void ShowAlertsToast(String title, String msg) {
    Widget yesButton = TextButton(
      child: const Text("YES"),
      onPressed: () async {
        Navigator.pop(context2, true);
      },
    );
    Widget noButton = TextButton(
      child: const Text("NO"),
      onPressed: () {
        Navigator.pop(context2, true);
        // Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(
        "sYou'll receive notifications when $msg posts new Deals and Offer.Are you sure want to Subscribe?",
      ),
      actions: [noButton, yesButton],
    );
    showDialog(
      context: context,
      builder: (BuildContext context1) {
        context2 = context1;
        return alert;
      },
    );
  }

  late BuildContext context2;
}
