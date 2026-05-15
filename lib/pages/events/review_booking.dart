// ignore: file_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localkart/Api/config.dart';
import 'package:localkart/Api/provider/event_provider.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';

class ReviewbookingArguments {
  var bookingDetails;

  var eventDetails;

  ReviewbookingArguments(this.bookingDetails, this.eventDetails);
}

class Reviewbooking extends StatefulWidget {
  static const routeName = '/reviewbooking';

  Reviewbooking({
    required this.eventDetails,
    required this.bookingDetails,
    Key? key,
  }) : super(key: key);

  var eventDetails;
  var bookingDetails;

  @override
  State<Reviewbooking> createState() => _ReviewbookingState();
}

class _ReviewbookingState extends State<Reviewbooking> {
  int totalpayable = 0;

  String title = "";
  String url = "";

  // late Razorpay _razorpay;

  // void _handlePaymentSuccess(
  //   // PaymentSuccessResponse
  //   response,
  // ) {
  //   paymentSucceApiCall("" + response.paymentId.toString());
  // }

  void _handlePaymentError(
    // PaymentFailureResponse
    response,
  ) {
    print("response ERROR " + response.message.toString());
    // transAlertProcess(false, "Transaction Failed.", "0");
    // Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    // Navigator.pushReplacementNamed(
    //   context,
    //   EventFailureScreen.routeName,
    //   arguments: EventFailureScreenArguments(orderId.toString()),
    // );
  }

  void _handleExternalWallet(
    // ExternalWalletResponse
    response,
  ) {
    print("response wallets " + response.toString());
    // ShowToast(context, "Please check your Wallet details.");

    // transAlertProcess(false, "Please check your Wallet details.", "0");
  }

  @override
  void dispose() {
    super.dispose();
    // _razorpay.clear();
  }

  bool detailsShow = false;
  bool _isLoading = false;

  var Ticketdata;
  var TicketOrderDetails;
  var TicketbookingOrderId;

  double totalqtyPrice = 0;

  var orderId = "0";

  void openCheckout(totalpayable) async {
    var userName = await DBHelper().getLoginSubDB("Name");
    print(userName);
    var userPhone = await DBHelper().getLoginSubDB("Phone");

    var userEmail = await DBHelper().getLoginSubDB("Email");
    if (userEmail == "" || userEmail == null || userEmail == "null") {
      userEmail = "info@localkart.app";
    }
    print("Payout amount");
    var options = {
      'key': 'rzp_live_dPU9HUhjVuJg54',
      //rzp_live_dPU9HUhjVuJg54   rzp_test_APRjuSYwwwfdnH
      'amount': totalpayable,
      'name': userName,
      'description': 'Payment',
      'prefill': {'contact': userPhone, 'email': userEmail},
      'external': {
        'wallets': ['paytm'],
      },
    };

    try {
      print("opction " + options.toString());
      // _razorpay.open(options);
    } catch (e) {
      // debugPrint(e);
      print("checkout error is  " + e.toString());
    }
  }

  // paymentSucceApiCall(String tid) async {
  //   var userIndexId = await DBHelper().getLoginSubDB("Id");
  //   print("userIndexId ${userIndexId.toString()}");
  //
  //   try {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     var payscucesResponse = await HttpClientsTicketNxt(context)
  //         .PaymentSucessAPI(
  //           widget.eventDetails['id'].toString(),
  //           userIndexId,
  //           Ticketdata,
  //           TicketOrderDetails,
  //           TicketbookingOrderId,
  //         );
  //     setState(() {
  //       _isLoading = false;
  //     });
  //
  //     // print("payscucesResponse ['errorCode'] "+payscucesResponse['errorCode'].toString());
  //     if (payscucesResponse['errorCode'].toString() == "1") {
  //       Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
  //       ShowToast(
  //         context,
  //         "" + payscucesResponse['Message'] ??
  //             "Something went wrong, Try again!",
  //       );
  //       // print("Message " + payscucesResponse['Message'].toString());
  //     } else if (payscucesResponse['errorCode'].toString() == "0") {
  //       print("Message " + payscucesResponse['Message'].toString());
  //       print("orderId " + payscucesResponse['orderId'].toString());
  //       orderId = payscucesResponse['orderId'].toString();
  //       // transAlertProcess(
  //       //     true, "Payment Successfully Completed.", orderId.toString());
  //
  //       Navigator.pop(context);
  //       Navigator.pop(context);
  //       Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
  //       Navigator.pushReplacementNamed(
  //         context,
  //         EventSucessScreen.routeName,
  //         arguments: EventSucessScreenArguments(orderId.toString()),
  //       );
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     ShowToast(context, "" + "Something went wrong, Try again!");
  //     print(" loading payment success " + e.toString());
  //   }
  // }
  //
  // transAlertProcess(tyes, msg, eventId) async {
  //   await showDialog(
  //     context: context,
  //     // barrierDismissible: true,
  //     builder: (BuildContext context) {
  //       return TransSuccessAlertsEvent(
  //         type: tyes,
  //         msg: msg,
  //         eventId: widget.eventDetails['id'].toString(),
  //       );
  //     },
  //   );
  // }

  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            key: _keyLoader,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: app_theam),
                  const SizedBox(width: 16),
                  const Text("Loading please wait..."),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  sumCart() async {
    final dataJson = jsonEncode(totalTicketPrices);
    final qtysJson = jsonEncode(totalTicketQuantity);

    var input = {
      'data': dataJson,
      'id': widget.eventDetails['id'].toString(),
      'qtys': qtysJson,
    };

    var sumCartApiResponse = await EventsProvider().sumCartApi(input);
    _onBookingSubmit(sumCartApiResponse);
  }

  _onBookingSubmit(sumCartApiResponse) async {
    var userIndexId = await DBHelper().getLoginSubDB("Id");

    final dataJson = jsonEncode(totalTicketPrices);
    Ticketdata = totalTicketPrices;
    final orderdetails = jsonEncode(sumCartApiResponse);
    TicketOrderDetails = sumCartApiResponse;

    var input = {
      'eventId': widget.eventDetails['id'].toString(),
      'userId': userIndexId,
      'data': dataJson,
      'orderdetails': orderdetails,
    };

    var bookingResponse = await EventsProvider().bookingApi(
      input,
      totalpayable,
    );
    TicketbookingOrderId = bookingResponse;

    if (totalpayable == 0) {
      var sucessData = {
        'eventId': widget.eventDetails['id'].toString(),
        'userId': userIndexId,
        'data': dataJson,
        'orderdetails': orderdetails,
      };

      print("sucess events $sucessData");
      // paymentSucessResponse(sucessData);
    } else {
      openCheckout(totalpayable);
    }
  }

  // paymentSucessResponse(data) async {
  //   var payscucessfreeResponse = await HttpClientsTicketNxt(
  //     context,
  //   ).paymentApi(data);
  //
  //   if (payscucessfreeResponse['errorCode'].toString() == "1") {
  //     Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
  //     ShowToast(
  //       context,
  //       "" + payscucessfreeResponse['Message'] ??
  //           "Something went wrong, Try again!",
  //     );
  //   } else if (payscucessfreeResponse['errorCode'].toString() == "0") {
  //     orderId = payscucessfreeResponse['orderId'].toString();
  //
  //     Navigator.pop(context);
  //     Navigator.pop(context);
  //     Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
  //     Navigator.pushReplacementNamed(
  //       context,
  //       // EventSucessScreen.routeName,
  //       // arguments: EventSucessScreenArguments(orderId.toString()),
  //     );
  //   }
  // }

  @override
  void initState() {
    checkwtyPrice();
    amountConvert();

    // _razorpay = Razorpay();
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    print("eventdetails sec " + widget.eventDetails.toString());
    super.initState();
  }

  amountConvert() {
    //  totalpayable =  double.parse(widget.bookingDetails['additionalFeeDetils']['grand_total']);
    double amountDouble = double.parse(
      widget.bookingDetails['additionalFeeDetils']['grand_total'],
    );
    totalpayable = (amountDouble * 100).round(); // Converting to paise
    getTicketPrice();
    getTicketQuantity();
  }

  List<int> totalTicketPrices = [];
  List<int> totalTicketQuantity = [];

  getTicketPrice() {
    totalTicketPrices = widget.bookingDetails['bookTicket'].map<int>((item) {
      int price = int.parse(item['price'].toString());
      int qty = item['qty'];
      return price * qty;
    }).toList();
  }

  getTicketQuantity() {
    totalTicketQuantity = widget.bookingDetails['bookTicket'].map<int>((item) {
      // int price = int.parse(item['price'].toString());
      int qty = item['qty'];
      return qty;
    }).toList();
  }

  bool _isbtnLoading = false;

  checkwtyPrice() {
    for (int i = 0; i < widget.bookingDetails['bookTicket'].length; i++) {
      totalqtyPrice =
          totalqtyPrice +
          (double.parse(
                widget.bookingDetails['bookTicket'][i]['price'].toString(),
              ) *
              double.parse(
                widget.bookingDetails['bookTicket'][i]['qty'].toString(),
              ));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return actionBarTopBottomView(
      'Review Booking',
      context,

      Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.white,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: app_theam,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(5),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              widget.eventDetails['eventname'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  Text(" " + widget.eventDetails['date']),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    color: Color.fromARGB(255, 26, 21, 21),
                                    size: 16,
                                  ),
                                  Text(
                                    " " +
                                        "${widget.eventDetails['start_time']} to ${widget.eventDetails['end_time']}",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: app_colorSecondary,
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  "Ticket",
                                  style: TextStyle(
                                    color: Color(0xFFe4287c),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                width: 70,
                                alignment: Alignment.center,
                                child: Text(
                                  "QTY",
                                  style: TextStyle(
                                    color: Color(0xFFe4287c),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                width: 70,
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "₹",
                                  style: TextStyle(
                                    color: Color(0xFFe4287c),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),

                        for (
                          int i = 0;
                          i < widget.bookingDetails['bookTicket'].length;
                          i++
                        ) ...[
                          if (widget.bookingDetails['bookTicket'][i]['qty'] !=
                              0) ...[
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget
                                              .bookingDetails['bookTicket'][i]['name'],
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "₹ " +
                                              widget
                                                  .bookingDetails['bookTicket'][i]['price']
                                                  .toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 70,
                                    alignment: Alignment.center,
                                    // decoration: BoxDecoration(
                                    //   borderRadius: BorderRadius.circular(5),
                                    //   border: Border.all(color: Colors.grey),
                                    // ),
                                    child: Text(
                                      widget
                                          .bookingDetails['bookTicket'][i]['qty']
                                          .toString(),
                                    ),
                                  ),
                                  Container(
                                    width: 70,
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "${int.parse(widget.bookingDetails['bookTicket'][i]['price'].toString()) * widget.bookingDetails['bookTicket'][i]['qty']}",
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ),
                          ],
                        ],

                        const Divider(thickness: 0.0),
                        Row(
                          children: [
                            SizedBox(width: 5),
                            Expanded(
                              child: Container(
                                width: 70,
                                padding: EdgeInsets.all(3),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Total",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),

                            Container(
                              width: 70,
                              padding: EdgeInsets.all(3),
                              alignment: Alignment.centerRight,
                              child: Text(
                                totalqtyPrice.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                        widget.bookingDetails['additionalFeeDetils']['is_confee'] ==
                                1
                            ? const Divider(thickness: 0.0)
                            : Container(height: 10),
                        widget.bookingDetails['additionalFeeDetils']['is_confee'] ==
                                    1 &&
                                widget.bookingDetails['additionalFeeDetils']['grand_total'] !=
                                    "0.00"
                            ? Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                      ),
                                      child: const Text(
                                        "Convenience Fee",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 1),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          detailsShow = !detailsShow;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              'Details',
                                              style: TextStyle(
                                                color: app_theam,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Icon(
                                              detailsShow
                                                  ? Icons
                                                        .keyboard_arrow_up_outlined
                                                  : Icons
                                                        .keyboard_arrow_down_outlined,
                                              color: app_theam,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    detailsShow
                                        ? Divider(thickness: 0.0)
                                        : Container(height: 8),
                                    if (detailsShow) ...[
                                      for (
                                        int i = 0;
                                        i <
                                            widget
                                                .bookingDetails['additionalFeeDetils']['con_fees']
                                                .length;
                                        i++
                                      ) ...[
                                        if (widget
                                                .bookingDetails['additionalFeeDetils']['con_fees'][i]['total'] !=
                                            0) ...[
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Row(
                                              children: [
                                                SizedBox(width: 5),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        widget
                                                            .bookingDetails['additionalFeeDetils']['con_fees'][i]['name'],
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        "₹ " +
                                                            widget
                                                                .bookingDetails['additionalFeeDetils']['con_fees'][i]['price']
                                                                .toString(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: 70,
                                                  alignment: Alignment.center,

                                                  child: Text(
                                                    widget
                                                        .bookingDetails['additionalFeeDetils']['con_fees'][i]['qty']
                                                        .toString(),
                                                  ),
                                                ),
                                                Container(
                                                  width: 70,
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    widget
                                                        .bookingDetails['additionalFeeDetils']['con_fees'][i]['qty']
                                                        .toString(),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 0.0,
                                            height: 5,
                                          ),
                                        ],
                                      ],
                                      for (
                                        int i = 0;
                                        i <
                                            widget
                                                .bookingDetails['additionalFeeDetils']['gst']
                                                .length;
                                        i++
                                      ) ...[
                                        Row(
                                          children: [
                                            const SizedBox(width: 120),
                                            const Spacer(),
                                            Text(
                                              '${widget.bookingDetails['additionalFeeDetils']['gst'][i]['label']} ${widget.bookingDetails['additionalFeeDetils']['gst'][i]['percent']}% :',
                                              style: const TextStyle(
                                                // fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              '${widget.bookingDetails['additionalFeeDetils']['gst'][i]['amount']}',
                                            ),
                                            SizedBox(width: 10),
                                          ],
                                        ),
                                      ],
                                      Container(height: 8),
                                    ],
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 90,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                height: 45,
                color: gray_color,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Grand Total",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          widget.bookingDetails['additionalFeeDetils']['quantity']
                                      .toString() ==
                                  "1"
                              ? "${widget.bookingDetails['additionalFeeDetils']['quantity']} Ticket"
                              : "${widget.bookingDetails['additionalFeeDetils']['quantity']} Tickets",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 70,
                      alignment: Alignment.centerRight,
                      child: Text(
                        "₹ ${widget.bookingDetails['additionalFeeDetils']['grand_total']}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(gradient: gradient_btn_lift),

                        child: Center(
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Edit',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 1),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _isbtnLoading = true;
                        });
                        // _isbtnLoading == true ??
                        // _showLoadingDialog(context);
                        sumCart();
                      },
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(gradient: gradient_btn_rigth),
                        width: MediaQuery.of(context).size.width / 2,

                        child: Center(
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  totalpayable != 0 ? 'Pay Now' : "Book Now",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
