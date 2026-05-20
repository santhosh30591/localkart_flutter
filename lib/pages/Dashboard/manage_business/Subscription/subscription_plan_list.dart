import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/sub_get_price.dart';
import 'package:localkart/pages/payment/cashfree.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';
import 'package:localkart/unit/showingSubscriptinPriceAlerts.dart';
import 'package:localkart/unit/showingTransSuccessAlerts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class SubscriptionPlansList extends StatefulWidget {
  const SubscriptionPlansList({Key? key}) : super(key: key);

  @override
  _SubscriptionPlansListFormState createState() =>
      _SubscriptionPlansListFormState();
}

class _SubscriptionPlansListFormState extends State<SubscriptionPlansList> {
  late Razorpay _razorpay;
  bool _isLoading = false;
  var referalCode = "";
  String userIndexId = "";
  String selectedPlanId = "";

  late GetPriceListModel _getPriceListModel = GetPriceListModel(
    description: [],
    result: [],
  );
  Map<String, dynamic> _planBenefitsData = {};
  List<String> _planNames = [];

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    loadInitialData();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  loadInitialData() async {
    userIndexId = await DBHelper().getLoginSubDB("Id");
    setState(() => _isLoading = true);
    await Future.wait([getSubDetailsView(), getGetPrice()]);
    setState(() => _isLoading = false);
  }

  Future<void> getGetPrice() async {
    try {
      Map<String, Object> inputs = {"userIndexId": userIndexId};
      var response = await ApiClientLocalKart().httpPost(inputs, urlgetPrice);
      var datas = json.decode(response.body.toString());
      if (datas['errorCode'].toString() == "0") {
        setState(() {
          _getPriceListModel = GetPriceListModel.fromJson(datas);
        });
      }
    } catch (e) {
      print("getGetPrice error: $e");
    }
  }

  Future<void> getSubDetailsView() async {
    try {
      Map<String, Object> inputs = {"userIndexId": userIndexId};
      var response = await ApiClientLocalKart().httpPost(
        inputs,
        urlSubscriptionList,
      );
      var datas = json.decode(response.body.toString());
      if (datas['errorCode'].toString() == "0") {
        setState(() {
          _planBenefitsData = datas["result"] ?? {};
          _planNames = _planBenefitsData.keys.toList();

          // Sort plans to match screenshot order: Free, Dhamaka, Dhool Dhamaka...
          _planNames.sort((a, b) {
            int getPriority(String name) {
              name = name.toLowerCase();
              if (name == 'free') return 0;
              if (name == 'dhamaka') return 1;
              if (name.contains('dhool')) return 2;
              if (name.contains('double')) return 3;
              return 4;
            }

            return getPriority(a).compareTo(getPriority(b));
          });
        });
      }
    } catch (e) {
      print("getSubDetailsView error: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    ShowToastdur(context, "Payment Success: ${response.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ShowToastdur(context, "Payment Error: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ShowToastdur(context, "External Wallet: ${response.walletName}");
  }

  dynamic getBenefitValue(String planName, String benefitKey) {
    try {
      var planList = _planBenefitsData[planName];
      if (planList != null && planList is List && planList.isNotEmpty) {
        var benefits = planList[0]['benifits'] as Map;
        if (benefits.containsKey(benefitKey)) {
          return benefits[benefitKey];
        }
      }
    } catch (e) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return actionBarTopBottomView(
      "Plans",
      context,
      Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        _buildComparisonTable(),
                        // const SizedBox(height: 5),
                        _buildUpgradeSection(),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
                _buildBottomButton(),
              ],
            ),
            if (_isLoading) fullViewLoadingUi(_isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonTable() {
    if (_getPriceListModel.description == null ||
        _getPriceListModel.description!.isEmpty) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Container(
                color: const Color(0xFFFFEBF5), // Light pink background
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 170,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "Benefits",
                          style: TextStyle(
                            color: Color(0xFFE4287C), // Pink text
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    ..._planNames.map(
                      (name) => SizedBox(
                        width: 120,
                        child: Text(
                          name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFFE4287C),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Data Rows
              ..._getPriceListModel.description!.map((benefit) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade100),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Benefit Title & Subtitle
                      Container(
                        width: 170,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              benefit.key ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Color(0xFF333333),
                              ),
                            ),
                            if (benefit.value != null &&
                                benefit.value!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  benefit.value!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Values for each plan
                      ..._planNames.map((planName) {
                        var val = getBenefitValue(planName, benefit.key!);
                        return SizedBox(
                          width: 120,
                          child: Center(child: _buildCellIconOrText(val)),
                        );
                      }),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCellIconOrText(dynamic val) {
    if (val == null)
      return const Text("-", style: TextStyle(color: Colors.grey));
    String sVal = val.toString();
    if (sVal.toLowerCase() == "yes" || sVal == "1") {
      return const Icon(Icons.check, color: Colors.green, size: 24);
    } else if (sVal.toLowerCase() == "no" || sVal == "0") {
      return const Icon(Icons.close, color: Colors.red, size: 24);
    }
    return Text(
      sVal,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  var planPrice = "0";

  Widget _buildUpgradeSection() {
    var upgradePlans =
        _getPriceListModel.result
            ?.where((p) => p.isCurrentPlan != "1")
            .toList() ??
        [];
    if (upgradePlans.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Text(
            "Select Plan",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: upgradePlans.length,
            itemBuilder: (context, index) {
              var plan = upgradePlans[index];
              if (plan.isCurrentPlan == "true") {
                planPrice = plan.planPrice.toString();
              }
              // bool isSelected = selectedPlanId == plan.planId;
              return GestureDetector(
                onTap: () {
                  var currentPlanPrice = int.parse(planPrice);
                  var selectedPlanPrice = int.parse(plan.planPrice.toString());

                  if (currentPlanPrice == selectedPlanPrice) {
                    showCommonToast(
                      context,
                      "",
                      "You ${plan.planName} plan is already subscribed. Upgrade any other plans.",
                    );
                  }
                  if (currentPlanPrice > selectedPlanPrice) {
                    showCommonToast(
                      context,
                      "",
                      "You can't downgrade to a lower plan when a higher plan is currently active. Please select any higher plan. (You can subscribe to a lower plan only after the current plan is expired.)",
                    );
                  } else {
                    amountCalculaction(
                      plan.planId,
                      plan.planName,
                      plan.planPrice,
                    );
                  }
                },
                child: Container(
                  width: 250,
                  margin: const EdgeInsets.only(right: 12, top: 5, bottom: 10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: plan.isCurrentPlan == "true"
                          ? const Color(0xFFE4287C)
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        plan.isCurrentPlan == "true"
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: plan.isCurrentPlan == "true"
                            ? const Color(0xFFE4287C)
                            : Colors.grey,
                        size: 26,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            plan.isCurrentPlan == "true"
                                ? const Text("Current Plan")
                                : Text(
                                    "Upgrade To",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            Text(
                              plan.planName ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Color(0xFFE4287C),
                              ),
                            ),
                            const SizedBox(height: 2),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: "₹ ${plan.planPrice}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " / ${plan.planValidity} Days",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Container(
      decoration: BoxDecoration(gradient: app_gradient),
      child: SafeArea(
        child: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            height: 55,
            alignment: Alignment.center,
            child: const Text(
              "Back",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  var amount = 0.0;
  var referaltype = "";

  amountCalculaction(String? id, String? planName, String? planPrice) async {
    Map<String, Object> inputs = {
      "userIndexId": userIndexId,
      "planId": "" + id.toString(),
    };

    try {
      setState(() {
        _isLoading = true;
      });

      var responces = await ApiClientLocalKart().httpPost(
        inputs,
        urlAmountcalculation,
      );

      setState(() {
        _isLoading = false;
      });

      var datas = json.decode(responces.body.toString());

      print("the amount calsc - " + datas.toString());

      if (datas['errorCode'].toString() == "0") {
        var data;

        String amounts = "";
        try {
          amounts = datas['amount'].toString();
          data =
              await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return SubscriptinAlerts(
                        titles: planName.toString(),
                        amount: "₹ " + planPrice.toString(),
                        finalAmount: double.parse(amounts),
                      );
                    },
                  )
                  as Map<String, Object>;
        } catch (e) {
          print("cancel title err -" + e.toString());
        }

        if (data['price'] != 0) {
          var price = data['price'].toString();
          amount = double.parse(price.toString());
          print("price " + amount.toString());

          var finalprice = amount.round();
          referaltype = data['type'].toString();
          buynowSucceApiCall(finalprice, false, id);
        }
      }
      setState(() {});
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(" loading payment success" + e.toString());
    }
  }

  buynowSucceApiCall(int finalAmt, isFree, planId) async {
    Map<String, Object> inputs = {
      "userIndexId": userIndexId,
      "planId": "" + planId,
      "amount": "" + finalAmt.toString(),
      "referalCode": referalCode,
      "referalType": "" + referaltype,
    };

    try {
      setState(() {
        _isLoading = true;
      });
      var responces = await ApiClientLocalKart().httpPost(inputs, urlBuynow);
      setState(() {
        _isLoading = false;
      });
      var datas = json.decode(responces.body.toString());

      print(" type isFree $isFree name is json  " + datas.toString());
      if (datas['errorCode'].toString() == "0") {
        if (isFree) {
          paymentSucceApiCall("", planId);
        } else {
          checkout("", planId, finalAmt.toString());
        }
      }

      setState(() {});
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(" loading payment success" + e.toString());
    }
  }

  paymentSucceApiCall(String tid, planId) async {
    Map<String, Object> inputs = {
      "userIndexId": userIndexId,
      "planId": "" + planId,
      "amount": "" + amount.toString(),
      "referalCode": referalCode,
      "referalType": "" + referaltype,
      "payment_id": tid,
    };

    try {
      setState(() {
        _isLoading = true;
      });
      var responces = await ApiClientLocalKart().httpPost(
        inputs,
        urlPaymentsuccess,
      );
      setState(() {
        _isLoading = false;
      });
      var datas = json.decode(responces.body.toString());

      print(" paymentSucceApiCall json  " + datas.toString());
      if (datas['errorCode'].toString() == "0") {
        transAlertProcess(true, "Payment Successfully Completed.", "Free");
      }
      setState(() {});
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(" loading payment success" + e.toString());
    }
  }

  checkout(String tid, planId, amount) async {
    Map<String, Object> inputs = {
      "userIndexId": userIndexId,
      "planId": "" + planId,
      "amount": "" + amount.toString(),
      "referalCode": referalCode,
      "referalType": "" + referaltype,
    };

    try {
      setState(() {
        _isLoading = true;
      });
      var responces = await ApiClientLocalKart().httpPost(inputs, urlBuynow);
      setState(() {
        _isLoading = false;
      });
      var datas = json.decode(responces.body.toString());

      print(" name is json  " + datas.toString());
      if (datas['errorCode'].toString() == "0") {
        var response =
            await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CashFreePaymentPage(
                      setOrderId: datas['order_id'].toString(),
                      setPaymentSessionId: datas['session_id'].toString(),
                      environment: datas['environment'].toString(),
                    ),
                  ),
                )
                as Map<String, String>;

        print("result $response");

        if (response != null) {
          if (response['status'].toString() == "success") {
            paymentSucceApiCall(response['orderId'].toString(), planId);
          } else if (response['status'].toString() == "cancel") {
          } else {
            transAlertProcess(false, response['message'].toString(), "Free");
          }
        }
      }
      setState(() {});
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(" loading payment success" + e.toString());
    }
  }

  transAlertProcess(tyes, msg, title) async {
    var continues =
        await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return TransSuccessAlerts(type: tyes, msg: msg);
              },
            )
            as bool;
    if (continues == true) {
      Map<String, String> maps = {
        "amount": "" + amount.toString(),
        "title": "" + title,
      };
      // Navigator.pop(context);
      Navigator.pop(context, maps);
    }
  }
}
