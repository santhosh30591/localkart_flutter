import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localkart/Api/service.dart';
import 'package:localkart/RoutingSetup/router-constants.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/dashboard/servicesDetailsModel.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/showing.dart';
import 'package:localkart/unit/showingLocationAletrs.dart';
import 'package:localkart/unit/showingNearMeAletrs.dart';

class DirectoryList extends StatefulWidget {
  dynamic roots;

  DirectoryList({Key? key, required this.roots}) : super(key: key);

  @override
  _DirectoryList createState() => _DirectoryList();
}

class _DirectoryList extends State<DirectoryList> {
  @override
  void initState() {
    loadingdetails();
    super.initState();
  }

  String title = "";
  String type = "";
  String catId = "";
  String subCatId = "";
  String latitude = "";
  String longitude = "";
  String userIndexId = "";
  String stateId = "";
  String districtId = "";
  String radius = "";

  String sub_title = "";

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
    sub_title = widget.roots.sub_title.toString();
    title = widget.roots.title.toString();

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
    print("get details " + widget.roots.title.toString());

    print("directorylist loadingdetails hema " + jsonEncode(inputs));
    getSetvicesList(inputs);
  }

  loadingRadious() async {
    var respons =
        await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return NearMeshowLocationAlerts(titles: '' + sub_title);
              },
            )
            as String;

    try {
      if (respons != "0") {
        print("My res " + respons);
        Map<String, Object> inputs = {
          "type": "" + type.toString(),
          "catId": "" + catId.toString(),
          "subCatId": "" + subCatId.toString(),
          "latitude": "" + latitude.toString(),
          "longitude": "" + longitude.toString(),
          "userIndexId": "" + userIndexId.toString(),
          "stateId": "" + stateId.toString(),
          "districtId": "" + districtId.toString(),
          "radius": "" + respons,
        };
        setState(() {});
        print(" loadingRadious " + jsonEncode(inputs.toString()));
        getSetvicesList(inputs);
      }
    } catch (e) {
      print("My res err " + e.toString());
    }
  }

  checkingLocation() async {
    var respons =
        await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return showLocationAlerts(state: stateId, city: districtId);
              },
            )
            as Map<String, Object>;

    try {
      if (respons['stateId'].toString() != "0") {
        Map<String, Object> inputs = {
          "type": "" + type.toString(),
          "catId": "" + catId.toString(),
          "subCatId": "" + subCatId.toString(),
          "latitude": "" + latitude.toString(),
          "longitude": "" + longitude.toString(),
          "userIndexId": "" + userIndexId.toString(),
          "stateId": "" + respons['stateId'].toString(),
          "districtId": "" + respons['distId'].toString(),
          "radius": "0",
        };
        setState(() {});
        print(" checkingLocation " + inputs.toString());
        getSetvicesList(inputs);
      }
    } catch (e) {
      print("My res err " + e.toString());
    }
  }

  List<ServiceDetailsModel> listSetvices = [];

  bool _isLoading = false;

  late BuildContext contexts;

  getSetvicesList(inputs) async {
    setState(() {
      _isLoading = true;
    });
    var responces = await HttpClients(
      context,
    ).httpServicesTyepe("directorylist", inputs);
    try {
      setState(() {
        _isLoading = false;
      });

      try {
        List<ServiceDetailsModel> localServices = [];
        var responce = "" + responces.body.toString();
        var datas = json.decode(responce);

        if (datas['errorCode'] == 0) {
          var lists = datas['result'] as List;
          for (int i = 0; i < lists.length; i++) {
            ServiceDetailsModel model;
            model = ServiceDetailsModel();
            model.name = "" + lists[i]['name'].toString();
            model.logo = "" + lists[i]['logo'].toString();
            model.distance = "" + lists[i]['distance'].toString();
            model.distanceInt = "" + lists[i]['distanceInt'].toString();

            AccessOptions acc = AccessOptions();
            acc.key = "" + lists[i]['accessOptions']['key'].toString();
            acc.value = "" + lists[i]['accessOptions']['value'].toString();

            model.accessOptions = acc;
            model.description = "" + lists[i]['description'].toString();
            model.shopIndexId = "" + lists[i]['shopIndexId'].toString();
            model.type = "" + lists[i]['type'].toString();
            model.latitude = "" + lists[i]['latitude'].toString();
            model.longitude = "" + lists[i]['longitude'].toString();
            model.isSubscribed = "" + lists[i]['isSubscribed'].toString();
            model.shareUrl = "" + lists[i]['shareUrl'].toString();
            model.isVerify = "" + lists[i]['isVerify'].toString();
            model.viewCount = "" + lists[i]['viewCount'].toString();
            model.averageRating = "" + lists[i]['averageRating'].toString();
            localServices.add(model);
          }
          print("title array list size " + localServices.length.toString());
        }
        setState(() {
          listSetvices = localServices;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  late BuildContext context1;

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
        _apiSubScrition(
          services.type,
          services.shopIndexId,
          services.isSubscribed,
        );
        Navigator.pop(context1);
      },
    );
    Widget noButton = TextButton(
      child: const Text("NO"),
      onPressed: () {
        Navigator.pop(context1);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: services.name.isEmpty
          ? const Text("")
          : RichText(
              text: TextSpan(
                // text: "You'll receive notifications when ",
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  const TextSpan(
                    text: "You'll receive notifications when ",
                    style: TextStyle(fontSize: 16),
                  ),
                  TextSpan(
                    text: services.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: ' posts  Deals and Offer.Are you sure want to $title',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
      actions: [noButton, yesButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        context1 = context;
        return alert;
      },
    );
  }

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

    setState(() {
      _isLoading = true;
    });

    var responces = await HttpClients(
      context,
    ).httpSubscription(updateTypes, inputs);
    try {
      setState(() {
        _isLoading = false;
      });

      try {
        var responce = "" + responces.body.toString();
        var datas = json.decode(responce);

        if (datas['errorCode'] == 0) {
          loadingdetails();
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _itemList(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: double.infinity,
              height: 140,
              // margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [
                  Container(
                    height: 45,
                    padding: const EdgeInsets.only(
                      top: 5,
                      left: 10,
                      bottom: 5,
                      right: 20,
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            // +" lengs "+listSetvices.length.toString()
                            child: Text(
                              listSetvices[index].name.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                color: Colors.black,
                                // fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        InkWell(
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              children: <Widget>[
                                listSetvices[index].averageRating != 0
                                    ? Text(
                                        "" + listSetvices[index].averageRating,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : const Text(
                                        "" + "0",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                const Icon(
                                  Icons.star,
                                  size: 20,
                                  color: Colors.yellow,
                                ),
                              ],
                            ),
                          ),
                          onTap: () {},
                        ),
                        InkWell(
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              children: <Widget>[
                                const Icon(
                                  Icons.remove_red_eye_outlined,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                listSetvices[index].viewCount != 0
                                    ? Text(
                                        " " +
                                            listSetvices[index].viewCount
                                                .toString(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : const Text(
                                        "" + "0",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          onTap: () {},
                        ),
                        listSetvices[index].isSubscribed == "1"
                            ? InkWell(
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  child: const Icon(
                                    Icons.notifications_active,
                                    size: 20,
                                    color: Color(0xFFFBC02D),
                                  ),
                                ),
                                onTap: () {
                                  ShowSubscribeLocal(
                                    context,
                                    listSetvices[index],
                                  );
                                },
                              )
                            : InkWell(
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  child: const Icon(
                                    Icons.notifications,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                                onTap: () {
                                  ShowSubscribeLocal(
                                    context,
                                    listSetvices[index],
                                  );
                                },
                              ),
                        const SizedBox(width: 5),
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.all(3),
                            child: const Icon(
                              Icons.share,
                              size: 20,
                              color: Colors.grey,
                            ),
                          ),
                          onTap: () {
                            shareServicesDetails(
                              '${listSetvices[index].name}\n\nHere is my Digital vCard',
                              listSetvices[index].shareUrl,
                            );
                          },
                        ),
                        const SizedBox(width: 5),
                      ],
                    ),
                  ),
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.only(left: 10, bottom: 5),
                      height: 65,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.all(1),
                            child: Container(
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
                                child: Container(
                                  child: Image.network(
                                    listSetvices[index].logo,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset("assets/load.gif");
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const SizedBox(height: 5),
                                Row(
                                  children: <Widget>[
                                    Flexible(
                                      child: Text(
                                        listSetvices[index].description,
                                        maxLines: 2,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      print("test");
                      showCommonToast(
                        contexts,
                        "" + listSetvices[index].name.toString(),
                        listSetvices[index].description.toString(),
                      );
                    },
                  ),
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: app_colorSecondary,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.directions,
                                    size: 18,
                                    color: app_theam,
                                  ),
                                  Flexible(
                                    child: Text(
                                      " Direction-${listSetvices[index].distance}",
                                      style: TextStyle(
                                        color: app_theam,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              // print("direction - " +
                              //     listSetvices[index].accessOptions);

                              String location =
                                  "" +
                                  listSetvices[index].latitude +
                                  "," +
                                  listSetvices[index].longitude;

                              shareDistaince(location);
                            },
                          ),
                        ),
                        Container(width: 1, color: Colors.white),
                        Expanded(
                          child: InkWell(
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_call,
                                    size: 18,
                                    color: app_theam,
                                  ),
                                  Text(
                                    "  Call",
                                    style: TextStyle(
                                      color: app_theam,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              launchInCall(
                                listSetvices[index].accessOptions.value,
                              );
                            },
                          ),
                        ),
                        Container(width: 1, color: Colors.white),
                        Expanded(
                          child: InkWell(
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.file_present,
                                    size: 18,
                                    color: app_theam,
                                  ),
                                  Text(
                                    "   More Details",
                                    style: TextStyle(
                                      color: app_theam,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                root_services_more_details,
                                arguments: listSetvices[index],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              child: listSetvices[index].isVerify == "1"
                  ? Container(
                      height: 18,
                      width: 18,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(5.0),
                          ),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    )
                  : Container(),
            ),
          ],
        ),
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

  @override
  Widget build(BuildContext context) {
    contexts = context;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        // color: Colors.white,
        child: Row(
          // clipBehavior: Clip.none,
          // alignment: Alignment.topCenter,
          children: [
            if (deviceWidth > 600)
              Container(
                width: deviceWidth * 0.25,
                height: MediaQuery.of(context).size.height,
                // color: Colors.green,
                decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage('sidebanner.png')),
                ),
              ),
            if (_isLoading == false)
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: deviceWidth > 600 ? deviceWidth * 0.5 : deviceWidth,
                child: listSetvices.length != 0
                    ? ListView.builder(
                        itemCount: listSetvices.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _itemList(context, index);
                        },
                      )
                    : Center(
                        child: Container(
                          height: 100,
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Directory list are being updated.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Please check back later.",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            if (_isLoading != false)
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: deviceWidth > 600 ? deviceWidth * 0.5 : deviceWidth,
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
                        margin: const EdgeInsets.only(top: 20),
                        child: const Text(
                          "Loading...",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (deviceWidth > 600)
              Container(
                width: deviceWidth * 0.25,
                height: MediaQuery.of(context).size.height,
                // color: Colors.green,
                decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage('sidebanner.png')),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 45.0, // Set your custom height here
        // padding: EdgeInsets.only(left: 10, right: 10),
        child: BottomAppBar(
          color: Colors.white,

          padding: EdgeInsets.all(0),
          // elevation: 0,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      loadingRadious();
                      print("update datas  ");
                    },
                    child: Container(
                      height: 45,

                      decoration: BoxDecoration(gradient: gradient_btn_lift),
                      margin: EdgeInsets.only(right: 1),

                      // color: const Color(0xFFee77ad),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_searching, color: Colors.white),
                          Text(
                            " Near Me",
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
                      checkingLocation();
                    },
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(gradient: gradient_btn_rigth),
                      margin: EdgeInsets.only(left: 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.not_listed_location, color: Colors.white),
                          Text(
                            "  Location",
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
      ),
    );
  }
}
