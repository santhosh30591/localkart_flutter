import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/Api/service.dart';
import 'package:localkart/RoutingSetup/root_data_pass.dart';
import 'package:localkart/RoutingSetup/router-constants.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/dashboard_model.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';

class ServicesList extends StatefulWidget {
  dynamic datas;

  ServicesList({Key? key, required this.datas}) : super(key: key);

  @override
  State<ServicesList> createState() => _ServicesList();
}

class _ServicesList extends State<ServicesList> {
  bool selectTab_shopping = false;
  late BuildContext contextMain;

  @override
  void initState() {
    print("id " + widget.datas["services_id"]);
    getServicesDetails(widget.datas["services_id"]);
    // getServicesDetails("70");
    super.initState();
  }

  List<Services> listServices = [];

  getServicesDetails(String id) async {
    listServices = [];
    var responces;

    print("widget.datas.title is $id" + {widget.datas["title"]}.toString());
    var url = "";
    if (widget.datas["title"] == "Shopping") {
      url = "shopsubcat";
      responces = await HttpClients(context).httpSubServices(id, url);
    } else if (widget.datas["title"] == "Services") {
      url = "servicesubcat";
      responces = await HttpClients(context).httpSubServices(id, url);
    } else {
      url = "rechargesubcat";
      // var abd = "rechargesubcat";
      // Navigator.of(contextMain).pushNamed(MobileContacts.routeName);

      // responces = await HttpClients(context).httpRechargeSubServices(id, url);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (_) => MobileContacts()));
      });
    }

    List<Services> localdata = [];
    var responce = "" + responces.body.toString();
    var datas = json.decode(responce);

    if (datas['errorCode'] == 0) {
      var lists = datas['result'] as List;
      for (int i = 0; i < lists.length; i++) {
        localdata.add(
          Services(
            id: lists[i]['Id'].toString(),
            title: lists[i]['subCategoryName'].toString(),
            images: lists[i]['Image'].toString(),
          ),
        );
      }
    }
    var loginProfile = await DBHelper().getLoginAllDB();

    var data = jsonDecode(loginProfile);
    var stateId = data['result']['stateId'];
    var districtId = data['result']['districtId'];

    widget.datas["state_id"] = stateId;
    widget.datas["state_id"] = districtId;

    setState(() {
      listServices = localdata;
      _isLoading = false;
      slidePageReloadings(
        widget.datas["state_id"],
        widget.datas["dist_id"],
        widget.datas["title"],
        widget.datas["services_id"],
      );
    });
  }

  bool _isLoading = true;

  // String url = "https://www.localkart.app/";//production
  String url = "$BaseURL/";

  List<DashboardSlider> listDashboard = [];
  late DashboardSlider currentSlider;

  slidePageReloadings(
    String sid,
    String dId,
    String type,
    String cate_id,
  ) async {
    print(
      "slidePageReloadings state " +
          sid.toString() +
          " distr " +
          dId.toString() +
          " type " +
          type.toString() +
          " " +
          cate_id.toString(),
    );

    var responces = await HttpClients(
      context,
    ).httpDashSubSlider(sid, dId, type, cate_id);
    try {
      setState(() {
        _isLoading = false;
      });
      List<DashboardSlider> local = [];

      var responce = "" + responces.body.toString();
      print(
        "length sid " +
            sid.toString() +
            " " +
            dId.toString() +
            " " +
            type.toString() +
            " " +
            cate_id.toString(),
      );

      print("length Shopping is hema" + responce.toString());
      var datas = json.decode(responce);
      var lists = datas['result'] as List;
      for (int i = 0; i < lists.length; i++) {
        local.add(
          DashboardSlider(
            image: lists[i]['Image'].toString(),
            dataLink: lists[i]['dataLink'].toString(),
            actionType: lists[i]['actionType'].toString(),
          ),
        );
      }
      setState(() {
        listDashboard = local;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("encode err - " + e.toString());
    }
  }

  var isWindows = false;

  @override
  Widget build(BuildContext context) {
    setState(() {});

    return actionBarTopBottomView(
      widget.datas["title"],
      context,
      Scaffold(
        backgroundColor: Colors.transparent,

        body: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 235,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          listDashboard.length == 0
                              ? Container(
                                  alignment: Alignment.center,
                                  height: 200,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(20.0),
                                      bottomLeft: Radius.circular(20.0),
                                    ),
                                    child: Image.asset(
                                      "assets/logo_with_name1.png",
                                    ),
                                  ),
                                )
                              : Container(
                                  child: Column(
                                    children: [
                                      InkWell(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              style: BorderStyle.solid,
                                              color: billpay_div_line_color,
                                            ),
                                            color: Colors.white,
                                          ),

                                          child: ImageSlideshow(
                                            /// Width of the [ImageSlideshow].
                                            width: double.infinity,

                                            height: isWindows ? 550 : 200,

                                            /// The page to show when first creating the [ImageSlideshow].
                                            initialPage: 0,

                                            /// The color to paint the indicator.
                                            indicatorColor: app_theam,

                                            /// The color to paint behind th indicator.
                                            indicatorBackgroundColor:
                                                Colors.grey,
                                            children: [
                                              for (var items in listDashboard)
                                                ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                        bottomRight:
                                                            Radius.circular(
                                                              0.0,
                                                            ),
                                                        bottomLeft:
                                                            Radius.circular(
                                                              0.0,
                                                            ),
                                                      ),
                                                  child: Container(
                                                    child: Image.network(
                                                      items.image.toString(),
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
                                              setState(() {
                                                currentSlider =
                                                    listDashboard[value];
                                              });
                                            },

                                            autoPlayInterval: 6000,
                                            isLoop: true,
                                          ),
                                        ),
                                        onTap: () {
                                          slideOnclick(1);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                          Positioned(
                            child: Container(
                              alignment: Alignment.center,
                              // width: 128,
                              height: 50,
                              margin: EdgeInsets.all(10),

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.center,

                                    height: 45,
                                    padding: EdgeInsets.only(
                                      left: 15,
                                      right: 15,
                                    ),

                                    decoration: BoxDecoration(
                                      gradient: app_gradient,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      widget.datas["sub_title"],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
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
                    listServices.length == 0
                        ? Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width,
                              child: Image.asset("assets/no_data_found.gif"),
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.only(left: 5, right: 5),
                            child: GridView.count(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 4,
                              crossAxisSpacing: 2.0,
                              mainAxisSpacing: 2.0,
                              children: List.generate(listServices.length, (
                                index,
                              ) {
                                return Center(
                                  child: InkWell(
                                    onTap: () {
                                      checkingLogin(
                                        listServices[index],
                                        "" + widget.datas["title"],
                                      );
                                    },
                                    child: SelectCard(
                                      service: listServices[index],
                                    ),
                                  ),

                                  //
                                );
                              }),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            _isLoading != false ? fullViewLoadingUi(_isLoading) : Container(),
          ],
        ),
      ),
    );
  }

  slideOnclick(int posi) async {
    try {
      if (currentSlider.actionType.toString() == "Url") {
        launchInBrowser(currentSlider.dataLink!);
      } else if (currentSlider.actionType.toString() == "Phone") {
        launchInCall(currentSlider.dataLink!);
      }
    } catch (e) {
      print("slideOnclick error is " + e.toString());
    }
  }

  checkingLogin(Services choose, String title) async {
    RootDataPassing roots = RootDataPassing();
    roots.title = "" + title;
    roots.sub_title = "" + choose.title;

    roots.services_id = widget.datas["services_id"];
    roots.sub_services_id = choose.id.toString();

    Navigator.of(context).pushNamed(root_services_details, arguments: roots);
  }
}

class SelectCard extends StatefulWidget {
  const SelectCard({Key? key, required this.service}) : super(key: key);
  final Services service;

  @override
  State<SelectCard> createState() => _SelectCardState();
}

class _SelectCardState extends State<SelectCard> {
  Color slectCardBg = Colors.white;
  Color textColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: MouseRegion(
        onEnter: (event) {
          slectCardBg = Theme.of(context).primaryColor.withOpacity(0.8);
          textColor = Colors.white;

          setState(() {});
        },
        onExit: (event) {
          slectCardBg = Colors.white;
          textColor = Colors.black;
          setState(() {});
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: slectCardBg,
          ),
          margin: MediaQuery.of(context).size.width > 850
              ? EdgeInsets.all(MediaQuery.of(context).size.width * 0.02)
              : EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 10),
                  margin: MediaQuery.of(context).size.width > 1000
                      ? const EdgeInsets.all(50)
                      : const EdgeInsets.all(0),
                  child: Image.network(
                    widget.service.images.toString(),
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/load.gif"),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset("assets/logo_with_name1.png");
                    },
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width * 0.015),
              Container(
                // alignment: Alignment.center,
                margin: EdgeInsets.only(
                  top: 0,
                  bottom: MediaQuery.of(context).size.width * 0.03,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.service.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                      color: textColor,
                      fontSize: MediaQuery.of(context).size.width > 850
                          ? 20
                          : 13,
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
}

class Services {
  Services({required this.id, required this.title, required this.images});

  String id = "";
  String title;
  String images;
}
