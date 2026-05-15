import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localkart/Api/service.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/dashboard/servicesDetailsModel.dart';
import 'package:localkart/model/dashboard/todayServicesListModel.dart';
import 'package:localkart/pages/Dashboard/DayTypes/moreDetails/today_more_details.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/showing.dart';
import 'package:localkart/unit/showingLocationAletrs.dart';
import 'package:localkart/unit/showingNearMeAletrs.dart';

class TodayList extends StatefulWidget {
  dynamic roots;

  TodayList({Key? key, required this.roots}) : super(key: key);

  @override
  _TodayList createState() => _TodayList();
}

class _TodayList extends State<TodayList> {
  @override
  void initState() {
    result.errorCode = 1;
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
    getSetvicesList(inputs);
  }

  loadingRadious() async {
    var respons =
        await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return NearMeshowLocationAlerts(titles: '' + title);
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
        getSetvicesList(inputs);
      }
    } catch (e) {
      print("My res err " + e.toString());
    }
  }

  late TodayServiceListModel result = TodayServiceListModel();

  bool _isLoading = false;

  late BuildContext contexts;

  getSetvicesList(inputs) async {
    setState(() {
      _isLoading = true;
    });
    var responces = await HttpClients(
      context,
    ).httpServicesTyepe("todaylist", inputs);
    try {
      setState(() {
        _isLoading = false;
      });

      try {
        List<ServiceDetailsModel> localServices = [];
        var responce = "" + responces.body.toString();
        var datas = json.decode(responce);

        if (datas['errorCode'] == 0) {
          // print("title array list size " + localServices.length.toString());
          setState(() {
            result = TodayServiceListModel.fromJson(datas);
          });
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

  late BuildContext context1;

  ShowSubscribeLocal(BuildContext context, index) {
    String title = "";

    if (result.result![index].isSubscribed!.toString() == "0") {
      title = "Subscribe!";
    } else {
      title = "UnSubscribe!";
    }

    Widget yesButton = TextButton(
      child: Text("YES"),
      onPressed: () {
        _apiSubScrition(
          result.result![index].type.toString(),
          result.result![index].shopIndexId!.toString(),
          result.result![index].isSubscribed.toString(),
        );
        Navigator.pop(context1);
      },
    );
    Widget noButton = TextButton(
      child: Text("NO"),
      onPressed: () {
        Navigator.pop(context1);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: result.result![index].name!.isEmpty
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
                    text: result.result![index].name.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text:
                        ' posts new Deals and Offer.Are you sure want to $title',
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
              height: 155,
              // margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [
                  Container(
                    height: 30,
                    padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Text(
                              result.result![index].fromDate.toString() +
                                  ' To ' +
                                  result.result![index].toDate.toString(),
                              style: const TextStyle(
                                color: Colors.grey,
                                // fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        //eye hema
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
                                result.result![index].viewCount != 0
                                    ? Text(
                                        " " +
                                            result.result![index].viewCount
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
                        const SizedBox(width: 3),
                        InkWell(
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            child: const Icon(
                              Icons.share,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ),
                          onTap: () {
                            shareServicesDetails(
                              '${result.result![index].name.toString()}'
                                      '\n\n ${result.result![index].offerHeading.toString()}'
                                      '\n\n ${result.result![index].description.toString()}'
                                      '\n\n Valid From ' +
                                  result.result![index].fromDate.toString() +
                                  ' To ' +
                                  result.result![index].toDate.toString(),
                              "https://bit.ly/3Bo6WNb",
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 30,
                    padding: const EdgeInsets.only(
                      left: 10,
                      bottom: 5,
                      right: 10,
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Text(
                              result.result![index].name!.toUpperCase(),
                              maxLines: 1,
                              style: const TextStyle(
                                color: Colors.black,
                                // fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
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
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFee77ad),
                                  width: .5,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
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
                                      '${result.result![index].logo.toString()}',
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Image.asset(
                                              "assets/load.gif",
                                            );
                                          },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  alignment: AlignmentDirectional.center,
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Row(
                                    children: <Widget>[
                                      const SizedBox(height: 50),
                                      Expanded(
                                        child: Container(
                                          child: Text(
                                            '${result.result![index].offerHeading.toString()}',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              // fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                            maxLines: 2,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '+ ${result.result![index].count.toString()} Deal',
                                        style: TextStyle(
                                          color: app_theam,
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      showCommonToast(
                        contexts,
                        "" + result.result![index].name!.toUpperCase(),
                        result.result![index].description!,
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
                                      " Direction- ${result.result![index].distance.toString()}",
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
                                  '${result.result![index].latitude.toString()}' +
                                  "," +
                                  '${result.result![index].longitude.toString()}';

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
                              if (result.result![index].accessOptions!.key
                                      .toString() ==
                                  "Phone") {
                                launchInCall(
                                  result.result![index].accessOptions!.value
                                      .toString(),
                                );
                              } else if (result
                                      .result![index]
                                      .accessOptions!
                                      .key
                                      .toString() ==
                                  "Alternate Number") {
                                launchInCall(
                                  result.result![index].accessOptions!.value
                                      .toString(),
                                );
                              } else if (result
                                      .result![index]
                                      .accessOptions!
                                      .key
                                      .toString() ==
                                  "Email") {
                                launchInMail(
                                  result.result![index].accessOptions!.value
                                      .toString(),
                                );
                              } else if (result
                                      .result![index]
                                      .accessOptions!
                                      .key
                                      .toString() ==
                                  "Mobile") {
                                launchInCall(
                                  result.result![index].accessOptions!.value
                                      .toString(),
                                );
                              } else if (result
                                      .result![index]
                                      .accessOptions!
                                      .key
                                      .toString() ==
                                  "WhatsApp") {
                                launchInWhatsapp(
                                  result.result![index].accessOptions!.value
                                      .toString(),
                                  "",
                                );
                              } else if (result
                                      .result![index]
                                      .accessOptions!
                                      .key
                                      .toString() ==
                                  "Website") {
                                var url = result
                                    .result![index]
                                    .accessOptions!
                                    .value
                                    .toString();
                                launchInBrowser(url);
                              } else if (result
                                      .result![index]
                                      .accessOptions!
                                      .key
                                      .toString() ==
                                  "Facebook") {
                                var url = result
                                    .result![index]
                                    .accessOptions!
                                    .value
                                    .toString();
                                launchInBrowser(url);
                              }
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
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => TodayMoreDetails(
                                    result: result,
                                    indexs: index,
                                  ),
                                ),
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
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: result.errorCode == 0
                  ? ListView.builder(
                      itemCount: result.result?.length,
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
                              "Deals and Offers are being updated.",
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
