import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/RoutingSetup/router-constants.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/pages/Dashboard/manage_business/ticketNxt/scanTicket.dart';
import 'package:localkart/pages/events/eventdetailspage.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class ManageRewardList extends StatefulWidget {
  ManageRewardList({Key? key}) : super(key: key);

  @override
  State<ManageRewardList> createState() => _ManageRewardListState();
}

class _ManageRewardListState extends State<ManageRewardList> {
  bool isLoaded = false;
  List eventsList = [];

  String message = "";

  @override
  void initState() {
    getEvent();
    super.initState();
  }

  getEvent() async {
    isLoaded = true;
    var userIndexId = await DBHelper().getLoginSubDB("Id");

    var type = "" + await DBHelper().getLoginDB("type");
    if (type == "Services") {
      type = "Service";
    }

    var url = '$managerewards?userIndexId=$userIndexId&type=$type';
    var response = await ApiClientLocalKart().httpGet(url);
    if (response != null) {
      setState(() {
        var datas = json.decode(response.body.toString());
        if (datas["errorCode"].toString() == "0") {
          eventsList = datas["result"];
        } else {
          message = datas["Message"];
        }
        isLoaded = false;
        print("data is loading " + eventsList.length.toString());
      });
    }
    return response;
  }

  dynamic ticketData = null;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double screenWidth = mediaQueryData.size.width;
    return actionBarTopBottomView(
      "Rewards",
      context,

      isLoaded
          ? const Center(child: CircularProgressIndicator())
          : eventsList.length == 0
          ? Center(child: Text(message, style: TextStyle(fontSize: 16)))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    for (int i = 0; i < eventsList.length; i++)
                      Card(
                        margin: const EdgeInsets.only(bottom: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        elevation: 4,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 10,
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                child: Image.network(
                                  eventsList[i]['reward_image'].toString(),
                                  // fit: BoxFit.fill,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Container(
                                          height: 160,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            image: DecorationImage(
                                              image: AssetImage(
                                                "assets/loading.gif",
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 160,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        image: DecorationImage(
                                          image: AssetImage(
                                            "assets/loading.gif",
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              Container(
                                color: app_theam[100],
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                    ),
                                    child: Html(
                                      data: '${eventsList[i]['title']}',
                                      style: {
                                        "body": Style(
                                          color: app_theam,
                                          textAlign: TextAlign.center,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Valid Till",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      eventsList[i]['validtill'],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          ticketData = eventsList[i];
                                          ticketData['isManaged'] = true;
                                          print("name $ticketData");

                                          Navigator.of(context).pushNamed(
                                            view_my_rewards,
                                            arguments: ticketData,
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: gradient_btn_lift,
                                            borderRadius:
                                                const BorderRadius.only(
                                                  bottomLeft: Radius.circular(
                                                    13,
                                                  ),
                                                ),
                                          ),
                                          height: 45,

                                          child: const Center(
                                            child: Text(
                                              'Details',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Container(height: 15, width: 1),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    TicketScannerPage(
                                                      eventId:
                                                          eventsList[i]['id'],
                                                      scanUserId: 0,
                                                      eventName:
                                                          eventsList[i]['title']
                                                              .toString(),
                                                    ),
                                              ),
                                            );
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: gradient_btn_rigth,
                                            borderRadius:
                                                const BorderRadius.only(
                                                  bottomRight: Radius.circular(
                                                    13,
                                                  ),
                                                ),
                                          ),
                                          height: 45,
                                          width: screenWidth / 2 + 2,
                                          child: const Center(
                                            child: Text(
                                              'Scan',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
    );
  }
}
