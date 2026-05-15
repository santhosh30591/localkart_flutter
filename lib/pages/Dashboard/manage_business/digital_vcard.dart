import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:localkart/Api/service.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/dashboard/servicesDetailsMoreModel.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/image_zooming.dart';
import 'package:localkart/unit/showing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class DigitalVcardDetails extends StatefulWidget {
  DigitalVcardDetails({Key? key}) : super(key: key);

  @override
  State<DigitalVcardDetails> createState() => _DigitalVcardDetails();
}

class _DigitalVcardDetails extends State<DigitalVcardDetails> {
  late BuildContext contextMain;
  bool _isLoading = true;

  late ServiceDetailsMoreModel services = ServiceDetailsMoreModel();

  loadingServiceDetails() async {
    var shopIndexId = "" + await DBHelper().getLoginDB("shopId");
    var type = "" + await DBHelper().getLoginDB("type");

    // shopIndexId="1791";

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
        print("services details " + datas.toString());
        try {
          if (datas['errorCode'].toString() == "0") {
            services = ServiceDetailsMoreModel.fromJson(datas);

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
    services.errorCode = 1;
    loadingServiceDetails();
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
      "Digital Vcard",
      context,
      Scaffold(
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
                                            color: app_colorSecondary,
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
                              InkWell(
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: app_colorSecondary,
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
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                "Adderss",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                address + ".",
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
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                          child: Container(
                                            width: 70,
                                            height: 70,
                                            child: Image.network(
                                              'https://developers.google.com/static/maps/images/landing/react-codelab-thumbnail.png',
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
          ),
        ),
        bottomNavigationBar: Container(
          height: 50,
          child: Row(
            children: [
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
                            leading: const Icon(Icons.text_fields),
                            title: const Text('Text'),
                            onTap: () {
                              setState(() {
                                shareServicesDetails(
                                  services.result!.shopName.toString() +
                                      '\n\nHere is my Digital vCard',
                                  services.result!.shareUrl.toString(),
                                );
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.image_sharp),
                            title: Text('Image'),
                            onTap: () {
                              setState(() {
                                takescrshot(Uint8List);
                              });
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(height: 55),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(gradient: app_gradient),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.share, color: Colors.white),
                        Text(
                          " Share Digital Vcard",
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

  Widget _itemListAccess(BuildContext context, int index) {
    return Container(
      child: InkWell(
        child: Container(
          color: index % 2 == 0 ? app_colorSecondary : Colors.white,
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
        style: const TextStyle(color: Colors.black, fontSize: 16),
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
}
