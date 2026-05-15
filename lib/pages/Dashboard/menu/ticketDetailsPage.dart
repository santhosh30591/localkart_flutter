import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/pages/Dashboard/menu/tens_invoice/invoice_details.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class TicketDetailsScreen extends StatefulWidget {
  final dynamic datas;

  TicketDetailsScreen({required this.datas, Key? key}) : super(key: key);

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  bool isExpanded = false;

  dynamic data = null;

  @override
  void initState() {
    _getInfo();
    super.initState();
  }

  _getInfo() async {
    var id = widget.datas['id'];
    var url = '$subBase/eventbookingdetails?id=' + id;
    var responces = await ApiClientLocalKart().httpGet(url);

    try {
      var result = json.decode(responces.body);
      data = result['result'];
      total_amount = data['grand_total'];
      total_tickets = data['quantity'];
    } catch (e) {}
    setState(() {});
  }

  bool detailsShow = false;

  var total_tickets = "0.0";
  var total_amount = "0.0";

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return actionBarTopBottomView(
      "Booking Details",
      context,
      Scaffold(
        body: Container(
          // future: _getInfo(),
          // builder: (context, AsyncSnapshot snapshot) {
          child: data == null
              ? Center(child: CupertinoActivityIndicator())
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: const Color.fromARGB(255, 245, 196, 212),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 12.0,
                            bottom: 12.0,
                          ),
                          child: Center(
                            child: Text(
                              data['event_name'],
                              style: TextStyle(
                                color: app_theam,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,

                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Image.asset(
                                    'assets/calendar_outlined.png',
                                    height: 20,
                                  ),
                                ),
                                Text(data['event_date']),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Icon(
                                    Icons.access_time,
                                    color: Color.fromARGB(255, 26, 21, 21),
                                    size: 20,
                                  ),
                                ),
                                Text(data['event_time']),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: const Color.fromARGB(255, 245, 196, 212),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            top: 12.0,
                            bottom: 12.0,
                            right: 8.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['bookingid'],
                                style: TextStyle(
                                  color: app_theam,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                data['quantity'] != "1"
                                    ? "${data['quantity']} Tickets"
                                    : "${data['quantity']} Ticket",
                                style: TextStyle(
                                  color: app_theam,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          height: 250,
                          width: 250,
                          child: QrImageView(
                            data: data['bookingid'],
                            version: QrVersions.auto,
                            size: 320,
                            gapless: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        color: app_theam[100],
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Venue ",
                              style: TextStyle(
                                color: Color(0xFFe4287c),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                launch(data['map']);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.black,
                                    size: 16,
                                  ),
                                  Text("Directions"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${data['address1']},'),
                            Text('${data['address2']},'),
                            Text('${data['address3']},'),
                            Text('${data['district']},'),
                            Text('${data['state']} - ${data['pincode']}.'),
                          ],
                        ),
                      ),
                      Container(
                        color: const Color.fromARGB(255, 245, 196, 212),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tickets',
                                style: TextStyle(
                                  color: app_theam,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '₹',
                                style: TextStyle(
                                  color: app_theam,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0; i < data['ticket'].length; i++) ...[
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        width: 180,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data['ticket'][i]['name'],
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "₹${data['ticket'][i]['price']}",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                          // border: Border.all(color: Colors.grey),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              data['ticket'][i]['qty']
                                                  .toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "${data['ticket'][i]['total']}",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              data['ticket'].length - 1 == i
                                  ? Container()
                                  : Container(
                                      height: 1,
                                      color: billpay_div_line_color,
                                    ),
                            ],
                            data['is_confee'] == 1 &&
                                    data['con_fees_total'].toString() != '0.00'
                                ? Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              detailsShow = !detailsShow;
                                            });
                                          },
                                          child: Container(
                                            color: billpay_div_line_color,
                                            padding: EdgeInsets.all(10.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Convenience Fee"),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Text(
                                                          'Details',
                                                          style: TextStyle(
                                                            color: app_theam,
                                                          ),
                                                        ),
                                                        SizedBox(width: 5),
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
                                                  ],
                                                ),

                                                Text(data['con_fees_total']),
                                              ],
                                            ),
                                          ),
                                        ),

                                        if (detailsShow) ...[
                                          for (
                                            int i = 0;
                                            i < data['con_fees'].length;
                                            i++
                                          ) ...[
                                            Container(
                                              padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 5,
                                                bottom: 5,
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          data['con_fees'][i]['name'],
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                        Text(
                                                          "₹ " +
                                                              data['con_fees'][i]['price']
                                                                  .toString(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  Expanded(
                                                    child: Center(
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                        child: Text(
                                                          data['con_fees'][i]['qty']
                                                              .toString(),
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          "${data['con_fees'][i]['total']}",
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Divider(thickness: 0.0),
                                          ],
                                          for (
                                            int i = 0;
                                            i < data['gst'].length;
                                            i++
                                          ) ...[
                                            Row(
                                              children: [
                                                SizedBox(width: 120),
                                                const Spacer(),
                                                Text(
                                                  '${data['gst'][i]['label']} ${data['gst'][i]['percent']}%:',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                Text(
                                                  '₹${data['gst'][i]['amount']}',
                                                ),
                                                const SizedBox(width: 10),
                                              ],
                                            ),
                                          ],
                                        ],
                                      ],
                                    ),
                                  )
                                : Container(),

                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        bottomNavigationBar: SizedBox(
          height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                color: billpay_div_line_color,
                height: 50,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Text(
                        'Grand Total',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,

                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        total_tickets == "0"
                            ? " Ticket"
                            : total_tickets == "0.0"
                            ? " Ticket"
                            : total_tickets == "1"
                            ? " Ticket"
                            : total_tickets + " Tickets",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        total_amount,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: const [
                    //       Text(
                    //         'Total',
                    //         style: TextStyle(
                    //           fontSize: 12,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    //
                    // Container(
                    //   width: 75,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(5),
                    //     border: Border.all(color: Colors.grey),
                    //   ),
                    //   child: Center(
                    //     child: Padding(
                    //       padding: EdgeInsets.all(8.0),
                    //
                    //       // child: Text("${data['quantity']}"),
                    //       child: Text(total_tickets),
                    //     ),
                    //   ),
                    // ),
                    //
                    // SizedBox(
                    //   width: 80,
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.end,
                    //     // children: [Text("${data['grand_total']}")],   //
                    //     children: [Text(total_amount)],
                    //   ),
                    // ),
                  ],
                ),
              ),
              Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => InvoiceDetails(
                                notificationId:
                                    "" + widget.datas['id'].toString(),

                                type: "ticketnxt".toString(),
                              ),
                            ),
                          );
                          // ShowToastdur(context, "Coming Soon.");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: gradient_btn_lift,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.notes,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                // Image.asset('assets/invoice.png', height: 20),
                                const Text(
                                  ' Invoice',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(width: 1.2, color: Colors.white),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          // Navigator.pop(context);
                          // Navigator.pushNamed(context, MybookingsPage.routeName);
                        },
                        child: Container(
                          // height: 40,
                          decoration: BoxDecoration(
                            gradient: gradient_btn_rigth,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.arrow_back_outlined,
                                  color: Colors.white,
                                ),
                                Text(
                                  ' Back',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
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
