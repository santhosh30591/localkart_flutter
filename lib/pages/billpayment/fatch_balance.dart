import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/Api/provider/billpay_provider.dart';
import 'package:localkart/RoutingSetup/router-constants.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/bill_pay_model/blanace_confirm_model.dart';
import 'package:localkart/model/bill_pay_model/blanace_fetch_model.dart';
import 'package:localkart/model/billpay_operater_list.dart';
import 'package:localkart/model/fatch_bill_info_model.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/buttons.dart';
import 'package:localkart/unit/showing.dart';
import 'package:provider/provider.dart';

class FetchBalanceDetails extends StatefulWidget {
  final dynamic datas;

  const FetchBalanceDetails({Key? key, required this.datas}) : super(key: key);

  @override
  State<FetchBalanceDetails> createState() => _FetchBalanceDetails();
}

class _FetchBalanceDetails extends State<FetchBalanceDetails> {
  bool isLoading = false;

  OperaterListResults get operatorInfo => widget.datas['operator'];

  FatchBillResult get fetch_biller_info => widget.datas['fetch_bill_result'];

  String get title => widget.datas['app_title'];

  TextEditingController edit_enter_amount_controller = TextEditingController();

  var isEditable = true;
  List<Info> info = [];
  List<int> quickPay = [];

  var paymentStatus = 0;
  var paymentStatusMessage = "Transcation about";

  BlanaceConfirmResponseModel blanaceConfirmResponseModel =
      BlanaceConfirmResponseModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isLoading = context.watch<BillPaymentProvider>().isLoading;
    paymentStatus = context.watch<BillPaymentProvider>().paymentStatus;

    return actionBarTopBottomViewBharathConnect(
      title,
      context,
      Consumer<BillPaymentProvider>(
        builder: (context, provider, child) {
          info = provider.info;
          quickPay = provider.quickPay;
          paymentStatus = provider.paymentStatus;
          var amount = amuntEditable(info);

          if (amount.length != 0) {
            edit_enter_amount_controller.text = amount;
            isEditable = false;
          } else {
            isEditable = true;
          }
          return Stack(
            children: [
              paymentStatus == 0
                  ? SingleChildScrollView(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: parmsLoading(provider),
                      ),
                    )
                  : Center(child: updatePaymentUiDesign(provider)),
              if (provider.isLoading) fullViewLoadingUi(provider.isLoading),
            ],
          );
        },
      ),
    );
  }

  parmsLoading(BillPaymentProvider provider) {
    return Container(
      child: Column(
        children: [
          Card(
            margin: EdgeInsets.all(10.0),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Container(
                        height: 50,
                        width: 50,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          child: Image.network(
                            operatorInfo.icon.toString(),
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/load.gif"),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset("assets/logo_with_name1.png");
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        operatorInfo.name.toString() +
                            "isLoading " +
                            isLoading.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(4),
                        margin: EdgeInsets.only(right: 10, left: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            width: 1,
                            style: BorderStyle.solid,
                            color: app_theam,
                          ),
                        ),
                        child: Text(
                          "  Change  ",
                          style: const TextStyle(
                            color: app_theam,
                            fontSize: 13,
                          ),
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  color: billpay_div_line_color,
                  margin: EdgeInsets.only(top: 3, bottom: 10),

                  height: 1,
                ),

                // loadingParmsData(provider),
                fetch_biller_info.fetchrequiment.toString().toUpperCase() ==
                        "MANDATORY"
                    ? loadingBillerDetails(info)
                    : Container(),

                amountView(),

                if (quickPay.length != 0) loadingQuickPay(quickPay),

                SizedBox(height: 10),
                InkWell(
                  onTap: () async {
                    var amount = edit_enter_amount_controller.text.toString();
                    var minimumamount = fetch_biller_info
                        .paramData![0]
                        .minAmount
                        .toString();
                    var maximumamount = fetch_biller_info
                        .paramData![0]
                        .maxAmount
                        .toString();

                    double min_dob = (int.tryParse(minimumamount) ?? 0) / 100;
                    int mini = (min_dob).toInt();
                    double max_dob = (int.tryParse(maximumamount) ?? 0) / 100;
                    int max = (max_dob).toInt();

                    if (amount.isEmpty) {
                      showCommonToast(
                        context,
                        "",
                        "Amount enter should be between ₹$mini and ₹$max",
                      );
                    } else {
                      var userId = await DBHelper().getUserId();
                      // userId = await DBHelper().getUserId();
                      double enter_amount = (double.tryParse(amount) ?? 0);
                      if (enter_amount >= mini && enter_amount <= max) {
                        String url = "eb_confirmation";
                        Map<String, Object> input = {};
                        print(" App title $title");

                        var billerid = operatorInfo.billerid.toString();
                        var adhoc = fetch_biller_info.adhoc!;
                        var number =
                            fetch_biller_info.paramData![0].enterValues;
                        input = {
                          "amount": amount,
                          "userid": userId.toString(),
                          "number": number,
                          "billerid": billerid,
                          "adhoc": adhoc,
                        };

                        if (title.toLowerCase().contains("electricity")) {
                          url = "eb_confirmation";
                          amountConfirmation(input, url, provider);
                        } else if (title.toLowerCase().contains("dth")) {
                          url = "dth_confirmation";
                          amountConfirmation(input, url, provider);
                        } else if (title.toLowerCase().contains("fastag")) {
                          url = "fastag_confirmation";
                          amountConfirmation(input, url, provider);
                        } else if (title.toLowerCase().contains(
                          "credit card",
                        )) {
                          url = "creditcard_confirmation";

                          number = fetch_biller_info.paramData![1].enterValues;
                          input = {
                            "amount": amount,
                            "userid": userId.toString(),
                            "number": number,
                            "billerid": billerid,
                            "adhoc": adhoc,
                          };

                          amountConfirmation(input, url, provider);
                        } else if (title.toLowerCase().contains("postpaid")) {
                          url = "postpaid_confirmation";
                          amountConfirmation(input, url, provider);
                        } else if (title.toLowerCase().contains("landline")) {
                          url = "landline_confirmation";
                          amountConfirmation(input, url, provider);
                        } else {
                          return showCommonToast(
                            context,
                            "",
                            "Invalid operator id ",
                          );
                        }
                      } else {
                        showCommonToast(
                          context,
                          "",
                          "Amount enter should be between ₹$mini and ₹$max",
                        );
                      }
                    }
                  },
                  child: submitBottomButton("Pay Now", provider.isAllValid),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget amountView() {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1,
          style: BorderStyle.solid,
          color: billpay_div_line_color,
        ),
      ),
      child: Container(
        height: 48,
        width: double.infinity,
        alignment: Alignment.centerLeft,
        child: TextField(
          controller: edit_enter_amount_controller,
          textCapitalization: TextCapitalization.none,
          keyboardType: TextInputType.number,
          enabled: isEditable,
          decoration: InputDecoration(
            prefix: Text(' ₹ '),
            // Add your desired currency symbol and optional space
            counterText: "",
            hintText: "Enter Amount",
            isDense: true,

            contentPadding: EdgeInsets.zero,
            hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
            border: InputBorder.none,
          ),
          onChanged: (value) {},
          style: TextStyle(
            fontSize: 15,
            color: isEditable ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget loadingParmsData(BillPaymentProvider provider) {
    return ListView.builder(
      itemCount: provider.paramData.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
      itemBuilder: (context, index) {
        var param = provider.paramData[index];
        return Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                param.labelName.toString(),
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              ),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 1,
                    style: BorderStyle.solid,
                    color: param.enterValues.isEmpty
                        ? billpay_div_line_color
                        : (param.isValidate ? Colors.green : Colors.red),
                  ),
                ),
                child: Container(
                  height: 45,
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    textCapitalization: TextCapitalization.none,
                    maxLength: int.tryParse(param.maxLength ?? "100") ?? 100,
                    keyboardType: param.inputType == "NUMERIC"
                        ? TextInputType.number
                        : TextInputType.text,
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: "Enter ${param.inputName}",
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      provider.enterNumbers(value, index);
                    },
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
              ),
              if (param.enterValues.isNotEmpty && !param.isValidate)
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 2),
                  child: Text(
                    "Please enter valid ${param.labelName} (Min ${param.minLength}, Max ${param.maxLength})",
                    style: TextStyle(fontSize: 11, color: Colors.red),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget loadingQuickPay(List<int> quickPayList) {
    int selectposi = 50;
    return Container(
      height: 55,
      margin: EdgeInsets.only(left: 5),
      child: ListView.builder(
        itemCount: quickPayList.length,
        scrollDirection: Axis.horizontal,

        itemBuilder: (context, index) {
          // var data = _operaterList[index];
          return InkWell(
            onTap: () {
              var amount = quickPayList[index].toString().replaceAll("₹", "");
              edit_enter_amount_controller.text = amount;
              selectposi = index;
              setState(() {});
            },
            child: Container(
              height: 50,
              width: 80,

              padding: const EdgeInsets.all(7),
              // margin: EdgeInsets.only(left: 5),
              child: Container(
                padding: EdgeInsets.all(8),
                // margin: EdgeInsets.only(right: 10, left: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    width: 1,
                    style: BorderStyle.solid,
                    color: selectposi == index
                        ? app_theam
                        : billpay_div_line_color,
                  ),
                ),
                child: Text(
                  "₹" + quickPayList[index].toString(),
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                  maxLines: 2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget loadingBillerDetails(List<Info> info) {
    return ListView.builder(
      itemCount: info.length,
      shrinkWrap: true,

      // physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        // var data = _operaterList[index];
        return Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      info[index].key.toString(),
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                      maxLines: 2,
                    ),
                  ),

                  Container(
                    child: Text(
                      info[index].value.toString(),
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              child: Text(
                "----------------------------------------------------------------------------------------------------------------",
                style: TextStyle(color: billpay_div_line_color, fontSize: 12),
                maxLines: 1,
              ),
            ),
          ],
        );
      },
    );
  }

  // confirmaction api call
  void amountConfirmation(
    Map<String, Object> input,
    url,
    BillPaymentProvider provider,
  ) async {
    // blanaceConfirmResponseModel = BlanaceConfirmResponseModel();
    context.read<BillPaymentProvider>().isUiLoading(true);

    try {
      url = BillPaymentBaseURL + url;
      var responce = await ApiClient(context).httpPost(input, url);
      var datas = json.decode(responce.body.toString());
      context.read<BillPaymentProvider>().isUiLoading(false);
      if (datas['errorCode'] != 0) {
        ShowToastdur(context, datas['message']);
      } else {
        blanaceConfirmResponseModel = BlanaceConfirmResponseModel.fromJson(
          datas,
        );

        try {
          var result = await Navigator.pushNamed(
            context,
            root_webview_payment,
            arguments: blanaceConfirmResponseModel,
          );

          try {
            if (result != null) {
              print("response " + result!.toString());

              dynamic data = result;

              String status = data["order_status"].toString().toLowerCase();
              print("status  $status");
              if (status == "success") {
                var order_id = data["order_id"];
                var order_status = data["order_status"];
                print("redirect to next page order_id $order_id");
                paymentStatusMessage = data["error_desc"];
                updatePaymentStatues(provider, 1);
              } else if (status.contains("aborted")) {
                paymentStatusMessage = data["error_desc"];
                updatePaymentStatues(provider, 3);
              } else {
                paymentStatusMessage = data["error_desc"];
                updatePaymentStatues(provider, 2);
              }
            } else {
              ShowToast(context, "Transaction is canceled.");
            }
          } catch (e) {
            print("Return page redirect error " + e.toString());
          }
        } catch (e) {
          print("its not null  error e " + e.toString());
        }
      }
    } catch (e) {
      context.read<BillPaymentProvider>().isUiLoading(false);
      print(" fetchInfo err - $e");
    }
  }

  void updatePaymentStatues(BillPaymentProvider provider, int status) {
    provider.updatePaymentStatus(status);

    new Future.delayed(const Duration(seconds: 3), () {
      if (status == 1 || status == 2) {
        // Navigator.pushReplacementNamed(
        //   context,
        //   root_billpay_opertor_list,
        //   arguments: blanaceConfirmResponseModel,
        // );

        Map<String, dynamic> data = {
          "referrenceid": blanaceConfirmResponseModel.referrenceid!,
          "isHistory": false,
        };
        Navigator.of(
          context,
        ).pushNamed(root_view_billbay_status, arguments: data);
      }
      provider.updatePaymentStatus(0);
    });
  }

  Widget updatePaymentUiDesign(BillPaymentProvider provider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          paymentStatus == 1
              ? "assets/ic_success_gif.gif"
              : paymentStatus == 2
              ? "assets/failed.gif"
              : "assets/warning.gif",
          height: 125.0,
          width: 125.0,
        ),
        SizedBox(height: 15),
        Text(
          paymentStatusMessage,
          style: paymentStatus == 1
              ? TextStyle(color: Colors.green, fontSize: 18)
              : paymentStatus == 2
              ? TextStyle(color: Colors.red, fontSize: 18)
              : TextStyle(color: Colors.amber, fontSize: 18),
        ),
      ],
    );
    Image.asset("assets/ic_logout.png", height: 125.0, width: 125.0);
  }

  String amuntEditable(List<Info> info) {
    var amount = "";

    var partPayment = false;
    try {
      for (var i = 0; i < fetch_biller_info.paramData!.length; i++) {
        if (fetch_biller_info.paramData![i].partPayment == 1) {
          partPayment = true;
          break;
        }
      }

      if (partPayment) {
        for (var i = 0; i < info.length; i++) {
          if (info[i].key.toString().toLowerCase() == "bill amount") {
            amount = info[i].value.toString();
            break;
          }
        }
      }
    } catch (e) {}
    print("update partPayment $partPayment amount $amount");

    return amount;
  }
}
