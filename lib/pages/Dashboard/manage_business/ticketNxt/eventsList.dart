import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/pages/Dashboard/manage_business/ticketNxt/scanTicket.dart';
import 'package:localkart/pages/events/eventdetailspage.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class ManageEventsListing extends StatefulWidget {
  static const routeName = '/events';

  ManageEventsListing({Key? key}) : super(key: key);

  @override
  State<ManageEventsListing> createState() => _ManageEventsListingState();
}

class _ManageEventsListingState extends State<ManageEventsListing> {
  bool isLoaded = false;
  List eventsList = [];

  @override
  void initState() {
    getEvent();
    super.initState();
  }

  getEvent() async {
    isLoaded = true;
    var userIndexId = await DBHelper().getLoginSubDB("Id");

    var url = '$businessEventList?userindexid=$userIndexId';
    var response = await ApiClientLocalKart().httpGet(url);
    if (response != null) {
      setState(() {
        var datas = json.decode(response.body.toString());

        eventsList = datas["result"];
        isLoaded = false;

        print("data is loading " + eventsList.length.toString());
      });
    }
    return response;
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double screenWidth = mediaQueryData.size.width;
    return actionBarTopBottomView(
      "Events",
      context,

      isLoaded
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
              body: SingleChildScrollView(
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
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    eventsList[i]['image'].toString(),
                                    fit: BoxFit.fill,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Container(
                                            height: 180,
                                            decoration: const BoxDecoration(
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
                                        height: 180,
                                        decoration: const BoxDecoration(
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
                                        data: '${eventsList[i]['eventname']}',
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
                                  padding: EdgeInsets.all(5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: SizedBox(
                                              height: 18,
                                              width: 18,
                                              child: Image.asset(
                                                "assets/calendar_outlined.png",
                                              ),
                                            ),
                                          ),
                                          Text(eventsList[i]['date']),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Icon(
                                              Icons.location_on_outlined,
                                              size: 20,
                                            ),
                                          ),
                                          Text(eventsList[i]['district']),
                                        ],
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
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EventDetailsPage(
                                                      context,
                                                      flag: 2,
                                                      eventId:
                                                          eventsList[i]['event_id'],
                                                    ),
                                              ),
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
                                                            eventsList[i]['event_id'],
                                                        scanUserId: 0,
                                                        eventName:
                                                            eventsList[i]['eventname']
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
                                                    bottomRight:
                                                        Radius.circular(13),
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
              bottomNavigationBar: InkWell(
                onTap: () async {
                  await launch('https://localkart.app/portal/events/authlogin');
                },
                child: Container(
                  height: 50,
                  width: screenWidth,
                  decoration: BoxDecoration(gradient: app_gradient),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Create Event',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
