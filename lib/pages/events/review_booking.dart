// ignore: file_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/Api/provider/event_provider.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/pages/events/EventFailure.dart';
import 'package:localkart/pages/events/eventsucess.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showEventTransactionSucess.dart';
import 'package:localkart/unit/showing.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

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

  late Razorpay _razorpay;

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    try {
      var id = response.paymentId;

      print("api  _razorpay response succes " + id.toString());
      paymentSucceApiCall("" + id.toString());
    } catch (e) {
      print("api  _razorpay response error " + e.toString());

      paymentSucceApiCall("" + e.toString());
    }
  }

  void _handlePaymentError(
    // PaymentFailureResponse
    response,
  ) {
    print("response ERROR " + response.message.toString());
    // transAlertProcess(false, "Transaction Failed.", "0");

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => EventFailureScreen(eventid: "0")),
    );
  }

  // void _handleExternalWallet(
  //   // ExternalWalletResponse
  //   response,
  // ) {
  //   print("response wallets " + response.toString());
  //   // ShowToast(context, "Please check your Wallet details.");
  //   // transAlertProcess(false, "Please check your Wallet details.", "0");
  // }

  @override
  void dispose() {
    super.dispose();

    // _razorpay.clear();
  }

  bool detailsShow = false;

  bool _isLoading = false;

  var Ticketdata;
  var TicketOrderDetails = "";
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
      // 'key': 'rzp_live_dPU9HUhjVuJg54',
      'key': 'rzp_test_APRjuSYwwwfdnH',

      'amount': totalpayable,
      'name': userName,
      'description': 'Ticket Booking.',
      'event_name': widget.eventDetails['eventname'],
      'prefill': {'contact': userPhone, 'email': userEmail},
      'external': {
        'wallets': ['paytm'],
      },
    };

    if (isLiveMode) {
      options = {
        'key': 'rzp_live_dPU9HUhjVuJg54',
        'amount': totalpayable,
        'name': userName,
        'order_id': TicketbookingOrderId,
        'description': 'Ticket Booking.',
        'event_name': widget.eventDetails['eventname'],
        'prefill': {'contact': userPhone, 'email': userEmail},
        'external': {
          'wallets': ['paytm'],
        },
      };
    }

    try {
      print("opction " + options.toString());
      _razorpay.open(options);
    } catch (e) {
      // debugPrint(e);
      print("checkout error is  " + e.toString());
    }
  }

  paymentSucceApiCall(trans_id) async {
    var userIndexId = await DBHelper().getLoginSubDB("Id");
    print("userIndexId ${userIndexId.toString()}");

    try {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
      });

      Map<String, Object> input = {
        "eventId": widget.eventDetails['id'].toString(),
        "userId": userIndexId.toString(),
        "paymentId": trans_id,
        "tempid": tempId,
        "orderdetails": TicketOrderDetails.toString(),
        "orderId": TicketbookingOrderId.toString(),
        "amount": "" + finaltotalpayable.toString(),
      };

      print("parms paysuccess $input");

      var responces1 = await ApiClientLocalKart().httpPost(input, paysuccess);
      print("payscucesResponse responces ${responces1.body}");

      Map<String, Object> input2 = {"payment_id": trans_id};

      var responces2 = await ApiClientLocalKart().httpPost(
        input2,
        payment_status,
      );
      print("payscucesResponse responces2 ${responces2.body}");
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      try {
        var payscucesResponse = json.decode(responces2.body.toString());

        if (payscucesResponse['errorCode'].toString() == "1") {
          // Safe check instead of forcing with '!'
          if (_keyLoader.currentContext != null) {
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
          }

          if (!mounted) return;
          ShowToast(
            context,
            payscucesResponse['Message']?.toString() ??
                "Something went wrong, Try again!",
          );
        } else if (payscucesResponse['errorCode'].toString() == "0") {
          print("orderId ${payscucesResponse['orderId']}");

          orderId = payscucesResponse['orderId'].toString();

          // 1. Safely dismiss the loading dialog if it is visible
          if (_keyLoader.currentContext != null) {
            Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
          }

          // 2. Ensure context is still valid before running screen pops
          if (!mounted) return;
          Navigator.pop(context);
          Navigator.pop(context);

          // 3. Push to success screen

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EventSucessScreen(
                eventid: widget.eventDetails['id'].toString(),
                orderId: orderId,
              ),
            ),
          );

          // Navigator.of(context).push(
          //   MaterialPageRoute(builder: (context) => EventFailureScreen(eventid: "0")),
          // );
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) =>
          //         EventSucessScreen(eventid: orderId.toString()),
          //   ),
          // );
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ShowToast(context, "Something went wrong, Try again!");
        }
        print(" loading payment success main inside $e");
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ShowToast(context, "Something went wrong, Try again!");
      }
      print(" loading payment success $e");
    }
  }

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
    var userIndexId = await DBHelper().getLoginSubDB("Id");

    List<String> dataJson = [];
    List<String> qtysJson = [];

    for (int i = 0; i < totalTicketPrices.length; i++) {
      dataJson.add(totalTicketPrices[i].toString());
    }

    for (int i = 0; i < totalTicketQuantity.length; i++) {
      qtysJson.add(totalTicketQuantity[i].toString());
    }

    int? parsedId = int.tryParse(widget.eventDetails['id'].toString());
    int? parsedUserId = int.tryParse(userIndexId.toString());

    // 1. Keep data as a Map object for your API
    Map<String, Object> input = {
      'data': dataJson.toString(),
      'id': parsedId.toString(),
      'userid': parsedUserId.toString(),
      'qtys': qtysJson.toString(),
    };

    var response = await ApiClientLocalKart().httpPost(input, sumcart);
    // var responseBody = jsonDecode(response.body);

    sumCartApiResponse = response;
    // print("New response " + responseBody.toString());
    // if (responseBody['errorCode'] == 0) {
    // return responseBody;

    // var sumCartApiResponse = await EventsProvider().sumCartApi(input);
  }

  var sumCartApiResponse;

  var tempId = "";

  _onBookingSubmit(sumCartApiResponse) async {
    var userIndexId = await DBHelper().getLoginSubDB("Id");
    Ticketdata = totalTicketPrices;
    var orderdetails = json.decode(sumCartApiResponse.body.toString());

    tempId = orderdetails["tempid"].toString();

    TicketOrderDetails = jsonEncode(TicketOrderDetails.toString());

    // 3. Extract the inner list using the "orderdetails" key
    List<dynamic> orderDetailsList = orderdetails['orderdetails'];

    // 4. (Optional) If you need it as a clean JSON string again, use jsonEncode
    TicketOrderDetails = jsonEncode(orderDetailsList);

    print("sumCartApiResponse $orderdetails");
    print("TicketOrderDetails $TicketOrderDetails and tempId " + tempId);

    String finalJsonString = jsonEncode(TicketOrderDetails);
    print(finalJsonString);

    var url =
        bookingconfirm +
        "?amount=$finaltotalpayable&tempid=$tempId&userid=" +
        userIndexId.toString();
    var bookingResponse = await ApiClientLocalKart().httpGet(url);

    var payscucesResponse = bookingResponse.body.toString();

    TicketbookingOrderId = payscucesResponse;

    if (totalpayable == 0) {
      paymentSucceApiCall("");
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

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    print("eventdetails sec " + widget.eventDetails.toString());
    super.initState();
  }

  var finaltotalpayable = 0.0;

  amountConvert() {
    //  totalpayable =  double.parse(widget.bookingDetails['additionalFeeDetils']['grand_total']);
    double amountDouble = double.parse(
      widget.bookingDetails['additionalFeeDetils']['grand_total'],
    );

    finaltotalpayable = amountDouble;
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
    sumCart();
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
                                                        "₹ ${widget.bookingDetails['additionalFeeDetils']['con_fees'][i]['price']}",
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
              Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 45,
                          margin: EdgeInsets.only(right: 1),
                          decoration: BoxDecoration(
                            gradient: gradient_btn_lift,
                          ),

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

                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _isbtnLoading = true;
                          });
                          // _isbtnLoading == true ??
                          // _showLoadingDialog(context);
                          // sumCart();

                          _onBookingSubmit(sumCartApiResponse);
                        },
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            gradient: gradient_btn_rigth,
                          ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
