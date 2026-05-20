import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/showing.dart';

class SubscriptinAlerts extends StatefulWidget {
  String titles;
  String amount;
  double finalAmount;

  SubscriptinAlerts({
    Key? key,
    required this.titles,
    required this.amount,
    required this.finalAmount,
  }) : super(key: key);

  @override
  _SubscriptinAlerts createState() => _SubscriptinAlerts();
}

class _SubscriptinAlerts extends State<SubscriptinAlerts> {
  var txt_coupon_code = TextEditingController();
  bool isReferral =  false;
  String referralCode = "";
  String referraltype = "";
  String referralprice = "";

  applyCouponCode(String code, final amount) async {
    referralCode = "";
    referraltype = "";

    var user_id = await DBHelper().getLoginSubDB("Id");

    Map<String, Object> inputs = {
      "userIndexId": user_id,
      "planAmount": "" + widget.finalAmount.toString(),
      "referralCode": code,
    };

    try {
      setState(() {
        _isLoading = true;
      });

      var responces = await ApiClientLocalKart().httpPost(inputs, urlApplyCode);

      setState(() {
        _isLoading = false;
      });

      var datas = json.decode(responces.body.toString());

      if (datas['errorCode'] == 0) {
        referralCode = "" + code;
        referraltype = "" + datas['referralType'].toString();
        referralprice = "" + datas['finalAmount'].toString();
        reloading = false;
        widget.finalAmount = datas['finalAmount'];
      } else {
        txt_coupon_code.text = "";
        isReferral = false;
        showCommonToast(context, "", datas['message'].toString());
      }
      setState(() {});
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(" loading payment success" + e.toString());
    }
  }

  bool _isLoading = false;

  update() {
    referralprice = widget.finalAmount.toString();
  }

  bool reloading = true;

  @override
  Widget build(BuildContext context) {
    update();
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            // height: 335,
            width: double.infinity,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            // margin: EdgeInsets.all(5),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 25),
                    Text(
                      'Subscription',
                      style: TextStyle(
                        fontSize: 19,
                        color: app_theam,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                "Plan Name ",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          Text(": ", style: TextStyle(fontSize: 16)),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(top: 4),
                              child: Text(
                                widget.titles,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                "Amount",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          Text(": ", style: TextStyle(fontSize: 16)),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(top: 4),
                              child: Text(
                                widget.amount,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                "Final Amount",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          Text(": ", style: TextStyle(fontSize: 16)),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(top: 4),
                              child: Text(
                                "₹ " + widget.finalAmount.toString(),
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    widget.finalAmount == 0
                        ? Container(height: 1, width: 1)
                        : widget.finalAmount == 0.0
                        ? Container(height: 1, width: 1)
                        : Container(
                            margin: EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.all(
                                Radius.circular(6.0),
                              ),
                            ),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Container(
                                    height: 50,
                                    child: TextField(
                                      controller: txt_coupon_code,
                                      maxLength: 12,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        focusColor: Colors.white,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(6.0),
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(6.0),
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        hintText:
                                            "Enter Referral / Coupon Code",
                                        fillColor: Colors.white,
                                        counterText: "",
                                      ),
                                      onChanged: (str) {
                                        if (str.length < 3) {
                                          isReferral = false;
                                        } else {
                                          isReferral = true;
                                        }
                                        setState(() {});
                                        // To do
                                      },
                                      onSubmitted: (str) {
                                        print("submit");
                                        // To do
                                      },
                                    ),
                                  ),
                                ),
                                isReferral == true
                                    ? InkWell(
                                        child: Container(
                                          width: 80,
                                          height: 50,
                                          decoration: new BoxDecoration(
                                            color: app_theam[300],
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(4.0),
                                              bottomRight: Radius.circular(4.0),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Apply",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          if (reloading == true) {
                                            applyCouponCode(
                                              "" + txt_coupon_code.text,
                                              widget.finalAmount,
                                            );
                                          }
                                        },
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                    const SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 110,
                            child: InkWell(
                              onTap: () {
                                Map<String, Object> datas = {
                                  "code": "",
                                  "price": 0,
                                };

                                Navigator.pop(context, datas);
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: gradient_btn_lift,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(5, 5),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Cancel",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(height: 50, width: 5),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                print(
                                  "code $referralCode type $referraltype price  $referralprice",
                                );
                                if (widget.finalAmount == 0 ||
                                    widget.finalAmount == 0.0) {
                                  Map<String, Object> datas = {
                                    "code": "" + txt_coupon_code.text,
                                    "price": 1,
                                  };
                                  Navigator.pop(context, datas);
                                } else {
                                  Map<String, Object> datas = {
                                    "code": "" + referralCode,
                                    "type": "" + referraltype,
                                    "price": referralprice,
                                  };
                                  Navigator.pop(context, datas);
                                }
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: gradient_btn_rigth,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(5, 5),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Process to Payment",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
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
          ),
          Positioned(
            top: -40,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 35,
              child: Image.asset(
                "assets/logo_with_name.png",
                height: 50,
                width: 50,
              ),
            ),
          ),
          _isLoading != false
              ? Container(
                  height: 335,
                  color: Colors.transparent,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 80,
                          height: 80,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(top: 10),
                          decoration: new BoxDecoration(
                            image: new DecorationImage(
                              image: new AssetImage("assets/load.gif"),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text(
                            "Loading...",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              // child: Loader(loadingTxt: 'Loading...'))
              : Container(height: 335),
        ],
      ),
    );
  }
}
