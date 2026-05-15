import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';

class EventSummaryPage extends StatefulWidget {
  static const routeName = '/eventsummary';

  int id;

  EventSummaryPage({required this.id, Key? key}) : super(key: key);

  @override
  State<EventSummaryPage> createState() => _EventSummaryPageState();
}

class _EventSummaryPageState extends State<EventSummaryPage> {
  bool isLoaded = false;

  @override
  void initState() {
    _getInfo();
    super.initState();
  }

  dynamic snapshot = null;

  _getInfo() async {
    isLoaded = true;
    setState(() {});
    // var response = await EventsProvider().getEventSummary(widget.id);
    var id = widget.id;

    var url = '$subBase/eventsummary?eventid=$id';
    var response = await ApiClientLocalKart().httpGet(url);
    if (response != null) {
      setState(() {
        var datas = json.decode(response.body.toString());
        isLoaded = false;

        try {
          for (int i = 0; i < datas['result']['ticket'].length; i++) {
            {
              total_allow =
                  total_allow +
                  int.parse(
                    datas['result']['ticket'][i]['ticketcount'].toString(),
                  );
            }
          }

          print("total_allow " + total_allow.toString());
        } catch (e) {
          print("error s $e");
        }
        print("total_allow final " + total_allow.toString());
        setState(() {});
        snapshot = datas;
      });
    }
  }

  int total_allow = 0;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double screenWidth = mediaQueryData.size.width;
    return actionBarTopBottomView(
      "Ticket View",
      context,
      Scaffold(
        body: isLoaded == true
            ? fullViewLoadingUi(isLoaded)
            : snapshot == null
            ? Center(child: Text("Loading..."))
            : snapshot['errorCode'] != 0
            ? Center(child: Text(snapshot['message']))
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: screenWidth * 2 + 20,
                      color: app_theam[100],
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 30,
                            width: screenWidth / 8,
                            child: Center(
                              child: Text(
                                '#',
                                style: TextStyle(
                                  color: app_theam,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            height: 30,
                            width: screenWidth / 2,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                'TICKET',
                                style: TextStyle(
                                  color: app_theam,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            height: 30,
                            width: screenWidth / 6,
                            child: Center(
                              child: Text(
                                '\u{20B9}',
                                style: TextStyle(
                                  color: app_theam,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 25),
                          SizedBox(
                            height: 30,
                            width: screenWidth / 4,
                            child: Center(
                              child: Text(
                                'ALLOTTED',
                                style: TextStyle(
                                  color: app_theam,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          // const SizedBox(width: 10),
                          SizedBox(
                            height: 30,
                            width: screenWidth / 3,
                            child: Center(
                              child: Text(
                                'AVAILABLE',
                                style: TextStyle(
                                  color: app_theam,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          // const SizedBox(width: 10),
                          SizedBox(
                            height: 30,
                            width: screenWidth / 4,
                            child: Center(
                              child: Text(
                                'BOOKED',
                                style: TextStyle(
                                  color: app_theam,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            height: 30,
                            width: screenWidth / 4,
                            child: Center(
                              child: Text(
                                'ATTENDED',
                                style: TextStyle(
                                  color: app_theam,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    for (
                      int i = 0;
                      i < snapshot['result']['ticket'].length;
                      i++
                    ) ...[
                      ...[
                        SizedBox(
                          width: screenWidth * 2 + 20,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 4,
                              top: 10,
                              bottom: 10,
                              right: 4,
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: screenWidth / 6,
                                  child: Center(
                                    child: Text((i + 1).toString()),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: screenWidth / 2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${snapshot['result']['ticket'][i]['name']}',
                                      ),
                                      const SizedBox(height: 3),
                                      // Text(
                                      //   '${snapshot['result']['ticket'][i]['description']}',
                                      //   style: const TextStyle(
                                      //     fontSize: 12,
                                      //     color: Colors.black54,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: screenWidth / 8,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text(
                                          '${snapshot['result']['ticket'][i]['amount']}',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 25),
                                SizedBox(
                                  width: screenWidth / 4,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text(
                                          '${snapshot['result']['ticket'][i]['ticketcount']}',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth / 3,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text(
                                          '${snapshot['result']['ticket'][i]['available']}',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth / 4,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text(
                                          '${snapshot['result']['ticket'][i]['booked']}',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: screenWidth / 4,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text(
                                          '${snapshot['result']['ticket'][i]['attended']}',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                    Container(
                      color: app_theam,
                      padding: const EdgeInsets.all(5),
                      width: screenWidth * 2 + 20,
                      child: Row(
                        children: [
                          SizedBox(
                            height: 30,
                            width: screenWidth / 6,
                            child: Center(
                              child: Text(
                                '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            height: 30,
                            width: screenWidth / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'BOOKING TOTAL',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            height: 30,
                            width: screenWidth / 8,
                            child: Center(
                              child: Text(
                                snapshot['result']['total_amount'].toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 25),
                          SizedBox(
                            height: 30,
                            width: screenWidth / 4,
                            child: Center(
                              child: Text(
                                total_allow.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            width: screenWidth / 3,
                            child: Center(
                              child: Text(
                                snapshot['result']['total_available']
                                    .toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            width: screenWidth / 4,
                            child: Center(
                              child: Text(
                                snapshot['result']['total_booked'].toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            height: 30,
                            width: screenWidth / 4,
                            child: Center(
                              child: Text(
                                snapshot['result']['total_attended'].toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
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
        bottomNavigationBar: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 45,
            width: screenWidth,
            decoration: BoxDecoration(gradient: app_gradient),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Back',
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
