import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localkart/Api/provider/event_provider.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/event/event_ticket_count_model.dart';
import 'package:localkart/pages/events/review_booking.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';

class BookNowPage extends StatefulWidget {
  BookNowPage({required this.eventId, Key? key}) : super(key: key);

  int eventId;

  @override
  State<BookNowPage> createState() => _BookNowPageState();
}

class _BookNowPageState extends State<BookNowPage> {
  @override
  void initState() {
    _checkTicketAvailabilty();
    super.initState();
  }

  bool isLoading = false;
  var eventdetails;

  List ticketDetails = [];

  _bookNow() async {
    var loginProfile = await DBHelper().getLoginAllDB();
    var data = jsonDecode(loginProfile);

    var ticketBookedDetails = {
      'userId': data["result"]['Id'],
      'eventId': widget.eventId,
      'bookTicket': ticketDetails,
    };

    print(ticketDetails);

    var response = await EventsProvider().confeecalculation(
      ticketBookedDetails,
    );

    ticketBookedDetails['additionalFeeDetils'] = response['result'];

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Reviewbooking(
          bookingDetails: ticketBookedDetails,
          eventDetails: eventdetails,
        ),
      ),
    );
  }

  int totalTicket = 0;
  var totalPrice = 0;
  List<Ticket> ticket = [];

  _checkTicketAvailabilty() async {
    isLoading = true;



    setState(() {});
    var response = await EventsProvider().checkTicketAvailability(
      widget.eventId,
    );




    if (response != null) {
      // var event = response['result'];

      setState(() {
        isLoading = false;

        try {
          var datas = json.decode(response.body.toString());

          var model = EventDetailsTicketCountModel.fromJson(datas);

          ticket = model.result!.ticket!;

          print("ticket count " + ticket.length.toString());
        } catch (e) {
          print("error details " + e.toString());
        }

        eventdetails = json.decode(response.body)['result'];



        setState(() {
          totalPrice = 0;
          totalTicket = 0;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return actionBarTopBottomView(
      "Event Booking",
      context,
      Scaffold(
        body: isLoading
            ? fullViewLoadingUi(isLoading)
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    eventdetails['eventname'] == ''
                        ? const Center(child: CupertinoActivityIndicator())
                        : Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  // height: 5,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: app_colorSecondary,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(5),
                                      bottom: Radius.circular(0),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      eventdetails['eventname'],
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.clip,
                                      style: const TextStyle(
                                        color: app_theam,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  color: gray_color,
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 16,
                                            width: 16,
                                            child: Image.asset(
                                              'assets/calendar_outlined.png',
                                            ),
                                          ),
                                          Text(
                                            " " + eventdetails['date'],
                                            style: TextStyle(fontSize: 13),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time,
                                            color: Colors.black,
                                            size: 16,
                                          ),
                                          Text(
                                            " " +
                                                "${eventdetails['start_time']} to ${eventdetails['end_time']}",
                                            style: TextStyle(fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: eventdetails['ticket'].length,

                                  itemBuilder: (context, i) {
                                    int count = 0;

                                    return Container(
                                      margin: EdgeInsets.fromLTRB(
                                        10,
                                        10,
                                        10,
                                        0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: .5,
                                          color: gray_color,
                                        ),

                                        borderRadius: BorderRadius.circular(10),
                                      ),

                                      child: Container(
                                        child: Column(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),

                                                color: app_colorSecondary,
                                              ),

                                              padding: const EdgeInsets.all(
                                                10.0,
                                              ),
                                              child: Text(
                                                ticket[i].name.toString(),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),

                                            Container(
                                              padding: EdgeInsets.all(10),

                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        ticket[i].remaining! <=
                                                                0
                                                            ? Row(
                                                                children: [
                                                                  ticket[i].price ==
                                                                          0
                                                                      ? Text(
                                                                          "Free",
                                                                          style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                        )
                                                                      : ticket[i].iscombo ==
                                                                                1 &&
                                                                            ticket[i].ticktes ==
                                                                                int.parse(
                                                                                  ticket[i].comboCount.toString(),
                                                                                ) &&
                                                                            ticket[i].price !=
                                                                                0
                                                                      ? Row(
                                                                          children: [
                                                                            Text(
                                                                              ",xkvn ₹${ticket[i].price}",
                                                                              style: TextStyle(
                                                                                fontSize: 14,
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.w500,

                                                                                decoration: TextDecoration.lineThrough,
                                                                                decorationColor: Colors.red,
                                                                                decorationThickness: 2.0,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 5,
                                                                            ),
                                                                            Text(
                                                                              "₹${ticket[i].comboPrice}",
                                                                              style: TextStyle(
                                                                                fontSize: 14,
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.w500,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      : Text(
                                                                          "₹${ticket[i].price}",
                                                                          style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                  SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  Text(
                                                                    'Sold Out',
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : ticket[i].iscombo ==
                                                                      1 &&
                                                                  ticket[i]
                                                                          .ticktes ==
                                                                      int.parse(
                                                                        ticket[i]
                                                                            .comboCount
                                                                            .toString(),
                                                                      ) &&
                                                                  ticket[i]
                                                                          .price !=
                                                                      0
                                                            ? Row(
                                                                children: [
                                                                  Text(
                                                                    "₹${ticket[i].price}",

                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .lineThrough,
                                                                      decorationColor:
                                                                          Colors
                                                                              .black,
                                                                      decorationThickness:
                                                                          2.0,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(
                                                                    "₹${ticket[i].comboPrice}",
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : Container(
                                                                child: Text(
                                                                  ticket[i].price ==
                                                                          0
                                                                      ? "Free"
                                                                      : "₹${ticket[i].price}",
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ),

                                                        Text(
                                                          ticket[i]
                                                              .admitPerson!,
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  Container(
                                                    height: 40,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            if (ticket[i]
                                                                    .ticktes <=
                                                                0) {
                                                            } else {
                                                              ticket[i]
                                                                      .ticktes =
                                                                  ticket[i]
                                                                      .ticktes -
                                                                  1;
                                                              checkTicketCountPrice();
                                                              setState(() {});
                                                            }
                                                          },
                                                          child: Icon(
                                                            Icons.remove_circle,
                                                            size: 30,
                                                            color: gray_color,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 40,
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            ticket[i].ticktes
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  ticket[i]
                                                                          .remaining ==
                                                                      0
                                                                  ? gray_color
                                                                  : Colors
                                                                        .black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            if (ticket[i]
                                                                    .remaining ==
                                                                0) {
                                                            } else if (ticket[i]
                                                                    .ticktes >=
                                                                ticket[i]
                                                                    .remaining!) {
                                                              showCommonToast(
                                                                context,
                                                                "",
                                                                ticket[i]
                                                                    .availableTickets!
                                                                    .replaceAll(
                                                                      "**",
                                                                      ticket[i]
                                                                          .remaining
                                                                          .toString(),
                                                                    ),
                                                              );
                                                            } else if (ticket[i]
                                                                        .ticktes >=
                                                                    int.parse(
                                                                      ticket[i]
                                                                          .comboCount!
                                                                          .toString(),
                                                                    ) &&
                                                                ticket[i]
                                                                        .iscombo ==
                                                                    1 &&
                                                                ticket[i]
                                                                        .price !=
                                                                    0) {
                                                              showCommonToast(
                                                                context,
                                                                "",
                                                                ticket[i]
                                                                    .comboErrorMsg
                                                                    .toString(),
                                                              );
                                                            } else {
                                                              if (ticket[i]
                                                                      .ticktes >=
                                                                  0) {
                                                                ticket[i]
                                                                        .ticktes =
                                                                    ticket[i]
                                                                        .ticktes +
                                                                    1;
                                                                setState(() {});
                                                                checkTicketCountPrice();
                                                              }
                                                            }

                                                            print(
                                                              " conut " +
                                                                  ticket[i]
                                                                      .ticktes
                                                                      .toString(),
                                                            );
                                                          },
                                                          child: Icon(
                                                            Icons
                                                                .add_circle_outline_outlined,
                                                            size: 30,
                                                            color: gray_color,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            ticket[i].iscombo == 1 &&
                                                    ticket[i].ticktes != 0 &&
                                                    ticket[i].price != 0
                                                ? Container(
                                                    width: double.infinity,

                                                    padding: EdgeInsets.all(8),
                                                    color:
                                                        billpay_div_line_color,

                                                    child:
                                                        ticket[i].ticktes
                                                                .toString() ==
                                                            ticket[i].comboCount
                                                                .toString()
                                                        ? Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                color: Colors
                                                                    .green,
                                                                size: 18,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                ticket[i]
                                                                    .comboSuccessMsg!,
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Row(
                                                            children: [
                                                              Icon(
                                                                Icons.percent,
                                                                color: Colors
                                                                    .redAccent,
                                                                size: 18,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                ticket[i]
                                                                    .comboNotes!
                                                                    .replaceAll(
                                                                      "**",
                                                                      ticket[i]
                                                                          .ticktes
                                                                          .toString(),
                                                                    ),

                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .redAccent,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                  )
                                                : Container(
                                                    width: double.infinity,
                                                    height: 1,
                                                    color:
                                                        billpay_div_line_color,
                                                  ),
                                            Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.only(
                                                bottom: 10,
                                                left: 10,
                                                right: 10,
                                                top: 5,
                                              ),
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: ticket[i]
                                                    .ticketNotes!
                                                    .length,

                                                itemBuilder: (context, j) {
                                                  return Container(
                                                    padding: EdgeInsets.only(
                                                      bottom: 3,
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          size: 17,
                                                          Icons
                                                              .check_circle_outline,
                                                          color: Colors.grey,
                                                        ),
                                                        SizedBox(width: 5),
                                                        Expanded(
                                                          child: Text(
                                                            ticket[i]
                                                                .ticketNotes![j],
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                    SizedBox(height: 10),
                  ],
                ),
              ),

        bottomNavigationBar: totalTicket == 0
            ? Container(height: 1)
            : Container(
                height: 100,
                decoration: BoxDecoration(gradient: app_gradient),
                child: BottomAppBar(
                  elevation: 0,
                  padding: EdgeInsets.all(0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 50,
                        color: gray_color,

                        padding: EdgeInsets.all(10),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              totalTicket == 1
                                  ? " $totalTicket Ticket"
                                  : "$totalTicket Tickets",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "₹" + totalPrice.toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _bookNow();
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(gradient: app_gradient),
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child: Text(
                            "Book Now",
                            style: TextStyle(color: Colors.white, fontSize: 14),
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

  checkTicketCountPrice() async {
    totalTicket = 0;
    totalPrice = 0;
    ticketDetails.clear();
    for (int i = 0; i < ticket.length; i++) {
      totalTicket = totalTicket + ticket[i].ticktes;

      var price = ticket[i].price;
      if (ticket[i].iscombo == 1 &&
          ticket[i].ticktes != 0 &&
          ticket[i].price != 0 &&
          int.parse(ticket[i].comboCount.toString()) == ticket[i].ticktes) {
        totalPrice = totalPrice + ticket[i].comboPrice! * ticket[i].ticktes;
        print("select combo price - " + ticket[i].comboPrice!.toString());
      } else {
       totalPrice = totalPrice + ticket[i].price! * ticket[i].ticktes;
      }

      ticketDetails.add({
        "name": ticket[i].name,
        "qty": ticket[i].ticktes,
        "order": ticket[i].order,
        "price": price,
      });
    }
  }
}
