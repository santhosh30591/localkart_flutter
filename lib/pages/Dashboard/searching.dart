import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/Api/service.dart';
import 'package:localkart/RoutingSetup/router-constants.dart';
import 'package:localkart/data_base/db_config.dart';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'dart:convert' as convert;

import 'package:localkart/model/dashboard/servicesDetailsModel.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';
import 'package:localkart/unit/showingLocationAletrs.dart';
import 'package:localkart/unit/showingNearMeAletrs.dart';

class ServicesSerching extends StatefulWidget {
  ServicesSerching({Key? key}) : super(key: key);

  @override
  _ServicesSerching createState() => _ServicesSerching();
}

class _ServicesSerching extends State<ServicesSerching> {
  @override
  void initState() {
    getStateetails();
    super.initState();
  }

  getStateetails() async {
    latitude = "" + await DBHelper().getLocationDetailsDB(true);
    longitude = "" + await DBHelper().getLocationDetailsDB(false);
    userIndexId = "" + await DBHelper().getLoginSubDB("Id");
    stateId = "" + await DBHelper().getLoginSubDB("stateId");
    districtId = "" + await DBHelper().getLoginSubDB("districtId");
  }

  bool _isLoading = false;

  List<ServiceDetailsModel> listSetvices = [];

  String title = "";

  String latitude = "";
  String longitude = "";
  String userIndexId = "";
  String stateId = "";
  String districtId = "";
  String radius = "";

  String urls = "search";

  loadingdetails() async {
    latitude = "" + await DBHelper().getLocationDetailsDB(true);
    longitude = "" + await DBHelper().getLocationDetailsDB(false);
    userIndexId = "" + await DBHelper().getLoginSubDB("Id");
    stateId = "" + await DBHelper().getLoginSubDB("stateId");
    districtId = "" + await DBHelper().getLoginSubDB("districtId");
    radius = "0";

    setState(() {});

    Map<String, Object> inputs = {
      "searchText": "" + title.toString(),
      "latitude": "" + latitude.toString(),
      "longitude": "" + longitude.toString(),
      "userIndexId": "" + userIndexId.toString(),
      "stateId": "" + stateId.toString(),
      "districtId": "" + districtId.toString(),
      "radius": "" + radius.toString(),
    };

    print("" + inputs.toString());
    urls = "search";
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
          "searchText": "" + title.toString(),
          "latitude": "" + latitude.toString(),
          "longitude": "" + longitude.toString(),
          "userIndexId": "" + userIndexId.toString(),
          "stateId": "" + stateId.toString(),
          "districtId": "" + districtId.toString(),
          "radius": "" + respons,
        };
        setState(() {});
        print(" test " + inputs.toString());
        urls = "search_nearme";
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
          "searchText": "" + title.toString(),
          "latitude": "" + latitude.toString(),
          "longitude": "" + longitude.toString(),
          "userIndexId": "" + userIndexId.toString(),
          "stateId": "" + respons['stateId'].toString(),
          "districtId": "" + respons['distId'].toString(),
          "radius": "0",
        };
        setState(() {});
        urls = "search";
        print(" test " + inputs.toString());
        getSetvicesList(inputs);
      }
    } catch (e) {
      print("My res err " + e.toString());
    }
  }

  getSetvicesList(inputs) async {
    setState(() {
      listSetvices = [];
    });
    Response responces = await post(
      Uri.parse(urlServiceTypes + urls),
      body: inputs,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: convert.Encoding.getByName("utf-8"),
    );

    try {
      List<ServiceDetailsModel> localServices = [];
      var responce = "" + responces.body.toString();
      var datas = json.decode(responce);

      print("my results - " + datas.toString());

      if (datas['errorCode'] == 0) {
        var lists = datas['resut_array'] as List;
        for (int i = 0; i < lists.length; i++) {
          ServiceDetailsModel model;
          model = new ServiceDetailsModel();
          model.name = "" + lists[i]['name'].toString();
          model.logo = "" + lists[i]['logo'].toString();
          model.distance = "" + lists[i]['distance'].toString();
          model.distanceInt = "" + lists[i]['distanceInt'].toString();

          AccessOptions acc = new AccessOptions();
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
          localServices.add(model);
        }
        // print("title array list size " + localServices.length.toString());
        print("res localServices -= " + localServices.length.toString());
      }

      setState(() {
        listSetvices = localServices;
      });
    } catch (e) {}
  }

  var _controllerSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: actionBarTopBottomView(
        "Search",
        context,
        Scaffold(
          body: Stack(

            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                color: Colors.white,
                padding: new EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      child: TextField(
                        controller: _controllerSearch,
                        maxLength: 30,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          counterText: '',
                          focusColor: Colors.grey,
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(6.0),
                            ),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(6.0),
                            ),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          suffixIcon: InkWell(
                            child: Icon(
                              _controllerSearch.text.length == 0
                                  ? Icons.search
                                  : Icons.clear,
                              color: Colors.black45,
                            ),
                            onTap: () {
                              _controllerSearch.text = "";
                              listSetvices = [];
                              setState(() {});
                            },
                          ),
                          hintText: "Type here...",
                          fillColor: Colors.grey,
                        ),
                        onChanged: (str) {
                          title = str;

                          print("title $title");

                          title = _controllerSearch.text.toString();

                          if (_controllerSearch.text.toString().length <= 1) {
                            listSetvices = [];
                          } else {
                            loadingdetails();
                          }

                          setState(() {});

                          // To do
                        },
                        onSubmitted: (str) {
                          if (_controllerSearch.text.toString().length <= 1) {
                            listSetvices = [];
                          } else {
                            loadingdetails();
                          }

                          setState(() {});
                        },
                      ),
                    ),
                    Flexible(
                      child: listSetvices.length == 0
                          ? Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width,
                                child: Image.asset("assets/no_data_found.gif"),
                              ),
                            )
                          : ListView.builder(
                              itemCount: listSetvices.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _itemList(context, index);
                              },
                            ),
                    ),
                  ],
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
          bottomNavigationBar: Container(
            height: 50,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (_controllerSearch.text.toString().length == 0) {
                        ShowTost("Enter search keyword");
                      } else {
                        loadingRadious();
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 1),
                      height: 50,
                      decoration: BoxDecoration(gradient: gradient_btn_lift),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
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
                      if (_controllerSearch.text.toString().length == 0) {
                        ShowTost("Enter search keyword");
                      } else {
                        checkingLocation();
                      }
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(gradient: gradient_btn_rigth),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.not_listed_location, color: Colors.white),
                          Text(
                            " Location",
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
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
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

              // margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      top: 5,
                      left: 10,
                      bottom: 5,
                      right: 10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Text(
                              listSetvices[index].name.toUpperCase(),
                              maxLines: 2,
                              style: const TextStyle(
                                color: Colors.black,
                                // fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        listSetvices[index].isSubscribed == "1"
                            ? InkWell(
                                child: Container(
                                  padding: EdgeInsets.all(3),
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
                                  padding: EdgeInsets.all(3),
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
                            margin: EdgeInsets.only(right: 5),
                            padding: EdgeInsets.all(3),
                            child: Icon(
                              Icons.share,
                              size: 18,

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
                        const SizedBox(width: 3),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10, bottom: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFFee77ad),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Image.network(
                              listSetvices[index].logo,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  "assets/logo_with_name1.png",
                                );
                              },
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
                                        fontSize: 14,
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
                              String location =
                                  "${listSetvices[index].latitude},${listSetvices[index].longitude}";

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
                              setState(() {});
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
                        decoration: new BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(5.0),
                          ),
                        ),
                        child: Icon(Icons.check, color: Colors.white, size: 15),
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
        Navigator.pop(contextMain);
      },
    );
    Widget noButton = TextButton(
      child: Text("NO"),
      onPressed: () {
        Navigator.pop(contextMain);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: services.name.isEmpty
          ? Text("")
          : RichText(
              text: TextSpan(
                // text: "You'll receive notifications when ",
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
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
                    text:
                        ' posts new Deals and Offer.Are you sure want to $title',
                    style: TextStyle(fontSize: 16),
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
        contextMain = context;
        return alert;
      },
    );
  }

  late BuildContext contextMain;
}
