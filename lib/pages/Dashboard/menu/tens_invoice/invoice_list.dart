import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/Api/service.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/invoice_list.dart';
import 'package:localkart/model/notification_list.dart';
import 'package:localkart/pages/Dashboard/manage_business/suscribers_list.dart';
import 'package:localkart/pages/Dashboard/menu/Notification/notification_details.dart';
import 'package:localkart/pages/Dashboard/menu/tens_invoice/invoice_details.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';

class TransInvoiceList extends StatefulWidget {
  TransInvoiceList({Key? key}) : super(key: key);

  @override
  _NotificationDetailsFormState createState() =>
      _NotificationDetailsFormState();
}

class _NotificationDetailsFormState extends State<TransInvoiceList> {
  @override
  void initState() {
    super.initState();
    _invoiceList.errorCode = 1;
    getInvoice();
  }

  bool _isLoading = false;
  InvoiceListModel _invoiceList = new InvoiceListModel();

  getInvoice() async {
    try {
      var userIndexId = "" + await DBHelper().getLoginSubDB("Id");
      // Map<String, Object> inputs = {"userIndexId": "345"};
      Map<String, Object> inputs = {"userIndexId": userIndexId};
      setState(() {
        _isLoading = true;
      });

      var responces = await ApiClient(
        context,
      ).httpPost(inputs, urlTransInvoice);

      try {
        setState(() {
          _isLoading = false;
        });

        var datas = json.decode(responces.body.toString());

        print("datas " + datas.toString());

        if (datas['errorCode'].toString() == "0") {
          _invoiceList = InvoiceListModel.fromJson(datas);
          setState(() {});
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print(" notification loading list error " + e.toString());
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return actionBarTopBottomView(
      "Transaction History",
      context,
      Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          _invoiceList.errorCode != 0
              ? Center(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: const [
                        Icon(
                          Icons.notes_sharp,
                          color: Colors.black54,
                          size: 100,
                        ),
                        SizedBox(height: 10),
                        Text("No Data Found"),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                color: app_colorSecondary,
                                child: Row(
                                  children: [
                                    buildHeaderCell("#", 50),
                                    buildHeaderCell("Invoice No", 120),
                                    buildHeaderCell("Payment Date", 120),
                                    buildHeaderCell("Amount ₹ ", 70),
                                    buildHeaderCell("  View", 50),
                                  ],
                                ),
                              ),
                              for (
                                int i = 0;
                                i < _invoiceList.result!.length;
                                i++
                              ) ...[
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  color: Colors.white,
                                  child: Row(
                                    children: [
                                      buildHeaderCell((i + 1).toString(), 50),
                                      buildHeaderCell(
                                        _invoiceList.result![i].invoice_no ??
                                            "",
                                        120,
                                      ),
                                      buildHeaderCell(
                                        _invoiceList.result![i].date ?? "",
                                        120,
                                      ),
                                      buildHeaderCell(
                                        _invoiceList.result![i].amount ?? "",
                                        70,
                                      ),
                                      InkWell(
                                        child: Container(
                                          height: 30,
                                          width: 50,
                                          child: Icon(
                                            Icons.manage_search,
                                            color: app_theam,
                                            size: 28,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  InvoiceDetails(
                                                    notificationId:
                                                        "" +
                                                        _invoiceList
                                                            .result![i]
                                                            .id
                                                            .toString(),

                                                    type: _invoiceList
                                                        .result![i]
                                                        .type
                                                        .toString(),
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(3),
                                  color: billpay_div_line_color,
                                  height: 1,
                                  child: Row(
                                    children: [
                                      Container(width: 60),
                                      Container(width: 120),
                                      Container(width: 120),
                                      Container(width: 70),
                                      Container(width: 50),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

          _isLoading != false ? fullViewLoadingUi(_isLoading) : Container(),
        ],
      ),
    );
  }
}
