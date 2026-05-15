import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/RoutingSetup/root_data_pass.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/dashboard/servicesDetailsMoreModel.dart';
import 'package:localkart/pages/Dashboard/manage_business/ads/repost_single_view.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/image_zooming.dart';
import 'package:localkart/unit/showing.dart';
import 'package:screenshot/screenshot.dart';

// ignore: must_be_immutable
class AdsPreviewMoreDetails extends StatefulWidget {
  String dates;
  String types;

  List<CreatePostMode> listOfPost;

  Map<String, Object> tabValidation;
  Map<String, Object> tagPost;

  AdsPreviewMoreDetails({
    Key? key,
    required this.dates,
    required this.types,
    required this.listOfPost,
    required this.tabValidation,
    required this.tagPost,
  }) : super(key: key);

  @override
  _AdsPreviewMoreDetails createState() => _AdsPreviewMoreDetails();
}

class _AdsPreviewMoreDetails extends State<AdsPreviewMoreDetails>
    with WidgetsBindingObserver {
  late BuildContext contextMain;
  bool _isLoading = true;
  List<CreatePostMode> listOfPost = [];
  late ServiceDetailsMoreModel services = ServiceDetailsMoreModel();

  loadingServiceDetails() async {
    var shopIndexId = "" + await DBHelper().getLoginDB("shopId");
    var type = "" + await DBHelper().getLoginDB("type");

    setState(() {
      _isLoading = true;
    });

    String latitude = await DBHelper().getLocationDetailsDB(true);
    String longitude = await DBHelper().getLocationDetailsDB(false);

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
        var datass = json.decode(responce);
        try {
          if (datass['errorCode'].toString() == "0") {
            services = ServiceDetailsMoreModel.fromJson(datass);
            for (int i = 0; i < services.result!.accessOptions!.length; i++) {
              if (services.result!.accessOptions![i].keyName.toString() ==
                  types) {
                values = services.result!.accessOptions![i].value.toString();
              }
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

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    services.errorCode = 1;

    types = widget.types;
    values = "";
    dates = widget.dates.toString();

    listOfPost = widget.listOfPost;
    loadingServiceDetails();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
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

  String dates = "";
  String types = "";
  String values = "";

  @override
  Widget build(BuildContext context) {
    contextMain = context;

    int select_posication = 0;

    return actionBarTopBottomView(
      "Post Details",
      context,

      Scaffold(
        body: Container(
          child: Container(
            child: Stack(
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
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) => ZoomingImages(
                                                  title:
                                                      "${services.result!.shopName!}",
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
                                        margin: const EdgeInsets.only(
                                          right: 10,
                                        ),
                                        padding: const EdgeInsets.all(1),
                                        child: Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: const Color(0xFFee77ad),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Container(
                                            // margin: EdgeInsets.all(.5),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                    const Radius.circular(5.0),
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
                                  padding: const EdgeInsets.all(10),
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
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(top: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Date",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Color(0xFF616161),
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          dates,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Direction",
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: const Color(0xFF616161),
                                          ),
                                        ),
                                        Text(
                                          services.result!.distance.toString(),
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    // shareDistaince(services.result!.shopLatitude
                                    //         .toString() +
                                    //     "," +
                                    //     services.result!.shopLongitude.toString());
                                  },
                                ),
                                InkWell(
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          types,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: const Color(0xFF616161),
                                          ),
                                        ),
                                        Text(
                                          values,
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const SizedBox(height: 5),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      bottom: 5,
                                    ),
                                    child: const Text(
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
                                      Container(
                                        child: ListView.builder(
                                          // padding: EdgeInsets.symmetric(vertical: 16.0), // Gap at start and end
                                          itemCount: listOfPost.length,
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
                                const SizedBox(height: 10),
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
                                margin: const EdgeInsets.only(top: 20),
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
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(gradient: gradient_btn_lift),
                    margin: EdgeInsets.only(right: 1),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Back",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    alertsConfirmation();
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(gradient: gradient_btn_rigth),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Post",
                          style: const TextStyle(
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

  alertsConfirmation() async {
    Widget yesButton = TextButton(
      child: const Text("YES"),
      onPressed: () async {
        createPostingValidate();
        Navigator.pop(contexts);
      },
    );
    Widget noButton = TextButton(
      child: const Text("NO"),
      onPressed: () {
        Navigator.pop(contexts);
        // Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: const Text(
        "Post details cannot be changed once saved. Are you sure you want to save and show this post to customer?",
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

  createPostingValidate() async {
    try {
      setState(() {
        _isLoading = true;
      });

      var responces = await ApiClientLocalKart().httpPost(
        widget.tabValidation,
        urlPostvalidation,
      );

      try {
        setState(() {
          _isLoading = false;
        });

        var datas = json.decode(responces.body.toString());
        print("save post details res - " + datas.toString());
        if (datas['errorCode'].toString() == "1") {
          try {
            createPosting();
          } catch (e) {
            print("error is - " + e.toString());
          }
        } else {
          ShowToastdur(context, datas['Message'].toString());
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
      print(" loading rtt 2 " + e.toString());
    }
  }

  var postIndexId = "";

  createPosting() async {
    try {
      setState(() {
        _isLoading = true;
      });

      var responces = await ApiClientLocalKart().httpPost(
        widget.tagPost,
        urlCreatepost,
      );

      try {
        setState(() {
          _isLoading = false;
        });

        var datas = json.decode(responces.body.toString());

        print("save post details res - " + datas.toString());

        if (datas['errorCode'].toString() == "0") {
          try {
            postIndexId = datas['postIndexId'].toString();
            await responceAlerts("" + datas['message'].toString());
            if (datas['isBoost'].toString() == "Yes" ||
                datas['isBoost'].toString() == "yes") {
              await sendNotifications();
            }
          } catch (e) {
            print("error is - " + e.toString());
          }
        } else {
          ShowToastdur(context, datas['message'].toString());
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
      print(" loading rtt 2 " + e.toString());
    }
  }

  responceAlerts(String msg) async {
    Widget yesButton = TextButton(
      child: const Text("Ok"),
      onPressed: () async {
        Navigator.pop(contexts);
        for (int i = 0; i < listOfPost.length; i++) {
          var title = "" + listOfPost[i].titile;
          var desc = "" + "" + listOfPost[i].desc;
          var images = "" + "" + listOfPost[i].images;
          var id = "" + "" + listOfPost[i].id;

          var isloop = true;
          if (i == listOfPost.length - 1) {
            isloop = false;
          }

          createOffers(title, desc, images, isloop, id);
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(content: Text(msg), actions: [yesButton]);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        contexts = context;
        return alert;
      },
    );
  }

  late BuildContext contexts;

  sendNotifications() async {
    try {
      setState(() {
        _isLoading = true;
      });

      var shopIndexId = "" + await DBHelper().getLoginDB("shopId");
      var type = "" + await DBHelper().getLoginDB("type");
      Map<String, Object> tags = {
        "postIndexId": postIndexId,
        "shopId": shopIndexId.toString(),
        "shopType": type.toString(),
      };

      var responces = await ApiClientLocalKart().httpPost(tags, urlSendpush);
      try {
        setState(() {
          _isLoading = false;
        });

        var datas = json.decode(responces.body.toString());

        print("save post details res - " + datas.toString());

        if (datas['errorCode'].toString() == "0") {
        } else {
          ShowToastdur(context, datas['message'].toString());
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
      print(" loading rtt 2 " + e.toString());
    }
  }

  createOffers(title, desc, images, isloop, id) async {
    try {
      setState(() {
        _isLoading = true;
      });
      var userId = await DBHelper().getLoginSubDB("Id");
      var base64string = "";
      try {
        if (images.toString().contains("http")) {
          base64string = id;
        } else {
          File imagefile = File(images);
          var imagebytes = await imagefile.readAsBytes(); //convert to bytes
          base64string = base64.encode(imagebytes); //con
        }

        Map<String, Object> tags = {
          "postIndexId": postIndexId,
          "heading": title.toString(),
          "description": desc.toString(),
          "offerImage": base64string.toString(),
          "userIndexId": userId,
        };

        var responces = await ApiClientLocalKart().httpPost(
          tags,
          urlCreateoffers,
        );

        try {
          setState(() {
            _isLoading = false;
          });

          var datas = json.decode(responces.body.toString());
          if (datas['errorCode'].toString() == "0") {
            try {
              if (!isloop) {
                Navigator.of(
                  contextMain,
                ).popUntil(ModalRoute.withName('/business'));
                ShowToastdur(context, datas['message'].toString());
              }
            } catch (e) {
              print("error is - " + e.toString());
            }
          } else {
            ShowToastdur(context, datas['message'].toString());
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
        print(" loading rtt 2 " + e.toString());
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(" loading rtt 2 " + e.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }

  bool isFastival = false;

  Widget _itemListDeals(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 10, bottom: 10),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Card(
              child: InkWell(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: const AssetImage(
                              "assets/logo_with_name1.png",
                            ),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(
                            color: gradint_start_color,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(5.0),
                          ),
                          child:
                              listOfPost[index].images.toString().contains(
                                "http",
                              )
                              ? Image.network(
                                  listOfPost[index].images.toString(),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      "assets/logo_with_name1.png",
                                    );
                                  },
                                )
                              : Image.file(
                                  File(listOfPost[index].images.toString()),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),

                      // Expanded(
                      //     child: Container(
                      //         color: Colors.grey, child: Text("teste ")))
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topLeft,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    listOfPost[index].titile
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
                                    listOfPost[index].desc.toString(),
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
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => RepostSinglePrevews(
                        images: "" + listOfPost[index].images.toString(),
                        title: "" + listOfPost[index].titile.toString(),
                        desc: "" + listOfPost[index].desc.toString(),
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
