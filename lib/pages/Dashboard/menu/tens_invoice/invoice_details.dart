import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/invoice_list.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';
import 'package:screenshot/screenshot.dart';

class InvoiceDetails extends StatefulWidget {
  final String notificationId;
  final String type;

  InvoiceDetails({Key? key, required this.notificationId, required this.type})
    : super(key: key);

  @override
  State<InvoiceDetails> createState() => _InvoiceDetails();
}

class _InvoiceDetails extends State<InvoiceDetails> with WidgetsBindingObserver {
  late BuildContext contextMain;
  bool _isLoading = true;
  late InvoiceDetailsModel _invoiceDetails = InvoiceDetailsModel();
  late ScreenshotController screenshotController = ScreenshotController();

  getInvoiceDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var userId = await DBHelper().getLoginSubDB("Id");
      var inputs = {
        'userIndexId': userId,
        'id': widget.notificationId.toString(),
        'type': widget.type.toString(),
      };

      String url = '$urlTransInvoiceDetails';
      var response = await ApiClientLocalKart().httpPost(inputs, url);
      var data = json.decode(response.body.toString());

      if (data['errorCode'].toString() == "0") {
        setState(() {
          _invoiceDetails = InvoiceDetailsModel.fromJson(data);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _invoiceDetails.errorCode = 1;
        });
      }
    } catch (e) {
      print("getInvoiceDetails error: $e");
      setState(() {
        _isLoading = false;
        _invoiceDetails.errorCode = 1;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _invoiceDetails.errorCode = 1;
    getInvoiceDetails();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    contextMain = context;

    return actionBarTopBottomView(
      "Invoice",
      context,
      Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            if (!_isLoading && _invoiceDetails.errorCode == 0)
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 80),
                child: Screenshot(
                  controller: screenshotController,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Company Header
                        Center(
                          child: Column(
                            children: [
                              if (_invoiceDetails.result?.logo != null && _invoiceDetails.result!.logo!.isNotEmpty)
                                Image.network(_invoiceDetails.result!.logo!, height: 40)
                              else
                                Image.asset("assets/logo_with_name1.png", height: 40),
                              const SizedBox(height: 15),
                              Text(
                                _invoiceDetails.result?.company?.toUpperCase() ?? "",
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _invoiceDetails.result?.companyAddress ?? "",
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 11, color: Colors.black87, height: 1.3),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Bill To and Invoice Info
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_invoiceDetails.result?.billText ?? "Bill To",
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                  const SizedBox(height: 5),
                                  Text(_invoiceDetails.result?.billTo ?? "",
                                      style: const TextStyle(fontSize: 12, color: Colors.black, height: 1.4)),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(color: Colors.black, fontSize: 12),
                                    children: [
                                      const TextSpan(text: "Invoice # ", style: TextStyle(fontWeight: FontWeight.bold)),
                                      TextSpan(text: _invoiceDetails.result?.invoiceNo ?? ""),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(_invoiceDetails.result?.date ?? "", style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),

                        // Table Header
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                          color: const Color(0xFFFFEBF5), // Light pink background like in the image
                          child: Row(
                            children: const [
                              SizedBox(width: 25, child: Text("#", style: TextStyle(fontWeight: FontWeight.bold, color: app_theam, fontSize: 11))),
                              Expanded(child: Text("Description", style: TextStyle(fontWeight: FontWeight.bold, color: app_theam, fontSize: 11))),
                              SizedBox(width: 60, child: Text("Rate ₹", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, color: app_theam, fontSize: 11))),
                              SizedBox(width: 40, child: Text("Qty", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: app_theam, fontSize: 11))),
                              SizedBox(width: 70, child: Text("Amount ₹", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, color: app_theam, fontSize: 11))),
                            ],
                          ),
                        ),

                        // Table Rows
                        if (_invoiceDetails.result?.description != null)
                          ..._invoiceDetails.result!.description!.asMap().entries.map((entry) {
                            int idx = entry.key;
                            var item = entry.value;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(width: 25, child: Text("${idx + 1}", style: const TextStyle(fontSize: 11))),
                                  Expanded(child: Text(item.name?.toString() ?? "", style: const TextStyle(fontSize: 11, height: 1.4))),
                                  SizedBox(width: 60, child: Text(item.rate ?? "0.00", textAlign: TextAlign.right, style: const TextStyle(fontSize: 11))),
                                  SizedBox(width: 40, child: Text(item.qty?.toString() ?? "0", textAlign: TextAlign.center, style: const TextStyle(fontSize: 11))),
                                  SizedBox(width: 70, child: Text(item.amount ?? "0.00", textAlign: TextAlign.right, style: const TextStyle(fontSize: 11))),
                                ],
                              ),
                            );
                          }).toList(),

                        const Divider(height: 1),

                        // Totals section aligned right
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 220,
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200)),
                            child: Column(
                              children: [
                                _buildTotalRow(_invoiceDetails.result?.subtotalText ?? "Sub Total", _invoiceDetails.result?.subtotalValue ?? "0.00"),
                                _buildTotalRow(_invoiceDetails.result?.cgstText ?? "CGST 9%", _invoiceDetails.result?.cgstValue ?? "0.00"),
                                _buildTotalRow(_invoiceDetails.result?.sgstText ?? "SGST 9%", _invoiceDetails.result?.sgstValue ?? "0.00"),
                                _buildTotalRow("Total", _invoiceDetails.result?.total ?? "0.00", isLast: true),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 100),

                        // Footer Queries
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              _invoiceDetails.result?.queries ?? "",
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 11, color: Colors.black54, height: 1.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Signature Disclaimer
                        Center(
                          child: Text(
                            _invoiceDetails.result?.signature ?? "",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.black45),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else if (!_isLoading && _invoiceDetails.errorCode == 1)
              const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.notes_sharp, color: Colors.black54, size: 100),
                    SizedBox(height: 10),
                    Text("No Data Found"),
                  ],
                ),
              ),
            if (_isLoading)
              Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 80, height: 80, decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/load.gif")))),
                      const SizedBox(height: 20),
                      const Text("Loading...", style: TextStyle(color: Colors.black, fontSize: 18)),
                    ],
                  ),
                ),
              ),
          ],
        ),
        bottomNavigationBar: (!_isLoading && _invoiceDetails.errorCode == 0)
            ? InkWell(
                onTap: () => ShowToastdur(context, "Downloading..."),
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(gradient: app_gradient),
                  alignment: Alignment.center,
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Download ", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        Icon(Icons.file_download_outlined, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildTotalRow(String label, String value, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey.shade200))),
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(fontSize: 11, fontWeight: isLast ? FontWeight.bold : FontWeight.normal, color: app_theam))),
          Container(width: 1, height: 15, color: Colors.grey.shade200),
          const SizedBox(width: 10),
          SizedBox(width: 70, child: Text(value, textAlign: TextAlign.right, style: TextStyle(fontSize: 11, fontWeight: isLast ? FontWeight.bold : FontWeight.bold))),
        ],
      ),
    );
  }
}
