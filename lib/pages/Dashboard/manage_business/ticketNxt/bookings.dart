import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/RoutingSetup/router-constants.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';
import 'package:provider/provider.dart';

class EventBookingsListPage extends StatefulWidget {
  static const routeName = '/bookings';

  EventBookingsListPage({required this.eventId, Key? key}) : super(key: key);
  int eventId;

  @override
  State<EventBookingsListPage> createState() => _EventBookingsListPageState();
}

class _EventBookingsListPageState extends State<EventBookingsListPage> {
  bool _isLoading = false;
  List bookingList = [];

  @override
  void initState() {
    getBookings("all");
    super.initState();
  }

  dynamic responseBody = null;

  getBookings(type) async {
    var url = '$eventBookingLists?eventid=${widget.eventId}&type="all';
    _isLoading = true;
    setState(() {});
    var response = await ApiClientLocalKart().httpGet(url);
    try {
      responseBody = jsonDecode(response.body);
      bookingList = [];
      if (responseBody["result"] != null) {
        for (int i = 0; i < responseBody["result"].length; i++) {
          bookingList.add(responseBody['result'][i]);
        }
      }
      _isLoading = false;
      setState(() {});
    } catch (e) {
      _isLoading = false;
      setState(() {});
      print("loading error $e");
    }
  }

  Color? convertColor(String? colorString) {
    if (colorString == null) return null;
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double screenWidth = mediaQueryData.size.width - 20;
    return actionBarTopBottomView(
      "Bookings",
      context,

      Scaffold(
        body: _isLoading == true
            ? Center(child: fullViewLoadingUi(_isLoading))
            : responseBody != null &&
                  responseBody['errorCode'] == 1 &&
                  responseBody['result'] == null
            ? Center(child: Text(responseBody['message']))
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,

                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,

                  child: SizedBox(
                    width: screenWidth * 2 - 120,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: app_theam[100],
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 30,
                                    width: screenWidth / 9.5,
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

                                  SizedBox(
                                    height: 30,
                                    width: screenWidth / 9.5,
                                    child: Center(
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Image.asset(
                                          'assets/entry-02.png',
                                          color: app_theam,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                height: 30,
                                width: screenWidth / 2.5,
                                child: Center(
                                  child: Text(
                                    'NAME & MOBILE NO',
                                    style: TextStyle(
                                      color: app_theam,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 60),
                              SizedBox(
                                height: 30,
                                width: screenWidth / 6,
                                child: Center(
                                  child: Text(
                                    'TICKETS',
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
                                width: screenWidth / 3,
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
                                    'ADMITTED',
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

                        bookingList.isEmpty
                            ? const Center(child: CupertinoActivityIndicator())
                            : Column(
                                children: [
                                  for (
                                    int i = 0;
                                    i < bookingList.length;
                                    i++
                                  ) ...[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 5,
                                        top: 5,
                                        bottom: 5,
                                        right: 5,
                                      ),
                                      child: Row(
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: screenWidth / 9.5,
                                                child: Center(
                                                  child: Text(
                                                    (i + 1).toString(),
                                                  ),
                                                ),
                                              ),

                                              SizedBox(
                                                height: 30,
                                                width: screenWidth / 9.5,
                                                child: Center(
                                                  child: Image.asset(
                                                    'assets/dot.png',
                                                    width: 15,
                                                    height: 20,
                                                    color:
                                                        convertColor(
                                                          bookingList[i]['admitted_color'],
                                                        ) ??
                                                        Colors.transparent,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 10),
                                          SizedBox(
                                            width: screenWidth / 2.5,
                                            child: GestureDetector(
                                              onTap: () {
                                                launchInCall(
                                                  bookingList[i]['customer_mobile']
                                                      .toString(),
                                                );
                                              },
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${bookingList[i]['customer_name'] ?? "-"}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${bookingList[i]['customer_mobile'] ?? ""}',
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 60),
                                          GestureDetector(
                                            onTap: () {
                                              // Navigator.pushNamed(context,
                                              //     TicketDetailsScreen.routeName,
                                              //     arguments:
                                              //         TicketDetailsArguments(
                                              //             bookingList[i]['id']));

                                              Map<String, String> roots = {
                                                "id":
                                                    bookingList[i]['id']
                                                        .toString() ??
                                                    "",
                                              };
                                              Navigator.of(context).pushNamed(
                                                view_my_bookings,
                                                arguments: roots,
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: app_gradient,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              height: 30,
                                              width: screenWidth / 6,
                                              child: Center(
                                                child: Text(
                                                  '${bookingList[i]['ticket_qty'] ?? ""}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          SizedBox(
                                            width: screenWidth / 3,
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    '${bookingList[i]['date'] ?? ""}',
                                                  ),
                                                  Text(
                                                    '${bookingList[i]['time'] ?? ""}',
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          SizedBox(
                                            width: screenWidth / 4,
                                            child: Center(
                                              child: Text(
                                                bookingList[i]['admit_date'] !=
                                                        null
                                                    ? "${bookingList[i]['admit_date']}\n ${bookingList[i]['admit_time']}"
                                                    : "-",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      thickness: 1,
                                      indent: 1,
                                      endIndent: 1,
                                    ),
                                  ],
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ),

        bottomNavigationBar: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 50,
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

enum FilterOptions { all, admitted, notAdmitted }

FilterOptions _selectedOption = FilterOptions.all;

class FilterBox extends StatefulWidget {
  FilterBox(this.eventId, {super.key});

  int eventId;

  @override
  State<FilterBox> createState() => _FilterBoxState();
}

class _FilterBoxState extends State<FilterBox> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Show"),
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 4.2,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
              child: RadioListTile<FilterOptions>(
                title: const Text("All"),
                value: FilterOptions.all,
                groupValue: _selectedOption,
                onChanged: (FilterOptions? value) {
                  setState(() {
                    _selectedOption = value!;
                  });
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
              child: RadioListTile<FilterOptions>(
                title: const Text("Admitted"),
                value: FilterOptions.admitted,
                groupValue: _selectedOption,
                onChanged: (FilterOptions? value) {
                  setState(() {
                    _selectedOption = value!;
                  });
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
              child: RadioListTile<FilterOptions>(
                title: const Text("Not Admitted"),
                value: FilterOptions.notAdmitted,
                groupValue: _selectedOption,
                onChanged: (FilterOptions? value) {
                  setState(() {
                    _selectedOption = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // if (_selectedOption == FilterOptions.all) {
                    //   Provider.of<MyBookingsProvider>(context, listen: false)
                    //       .getEventBookingList(widget.eventId, "all");
                    //   getBookings(all)
                    // } else if (_selectedOption == FilterOptions.admitted) {
                    //   Provider.of<MyBookingsProvider>(context, listen: false)
                    //       .getEventBookingList(widget.eventId, "admitted");
                    // } else {
                    //   Provider.of<MyBookingsProvider>(context, listen: false)
                    //       .getEventBookingList(widget.eventId, "notadmitted");
                    // }

                    Navigator.pop(context);
                  },
                  child: const Text("Submit"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
