import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localkart/Api/service.dart';
import 'package:localkart/RoutingSetup/router-constants.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';

class ReferalDetails extends StatefulWidget {
  ReferalDetails({Key? key}) : super(key: key);

  @override
  _ReferalDetailsFormState createState() => _ReferalDetailsFormState();
}

class _ReferalDetailsFormState extends State<ReferalDetails> {
  @override
  void initState() {
    super.initState();
    getreferralDetails();
  }

  bool _isLoading = false;

  var flag = "4";

  var referralCode = "";

  var amount = "0";
  var dailyPost = "";
  var weeklyPost = "";
  var festivalPost = "";
  var dealsPost = "";
  var validity = "";

  getreferralDetails() async {
    var userIndexId = await DBHelper().getLoginSubDB("Id");

    setState(() {
      _isLoading = true;
    });

    var responces = await HttpClients(context).httpReferalDetails(userIndexId);
    try {
      var responce = "" + responces.body.toString();
      setState(() {
        _isLoading = false;
      });

      try {
        var datas = json.decode(responce);

        var errorCode = datas['errorCode'].toString();
        flag = errorCode;
        print("datas " + datas.toString());

        if (errorCode == "0") {
          referralCode = datas['result']['referralCode'].toString();
          dailyPost = datas['result']['dailyPost'].toString();
          weeklyPost = datas['result']['weeklyPost'].toString();
          festivalPost = datas['result']['festivalPost'].toString();
          dealsPost = datas['result']['dealsPost'].toString();
          validity = datas['result']['validity'].toString();
        } else {}
        setState(() {});
      } catch (e) {
        print("data set  loading errors -" + e.toString());
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("encode err - " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: actionBarTopBottomView(
        "Referal",
        context,
        Scaffold(
          body: flag == "0"
              ? Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Center(
                              child: Text(
                                "Your referral code is",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 45,
                              width: 180,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xfff5bdd6),
                                    Color(0xfff5bdd6),
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(5, 5),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: InkWell(
                                child: Text(
                                  referralCode,
                                  style: TextStyle(
                                    color: app_theam,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  Clipboard.setData(
                                    ClipboardData(text: referralCode),
                                  );
                                  ShowToast(
                                    context,
                                    "Your referral code is copy",
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 25),
                            Container(
                              child: Text(
                                "Referral code will be generated only after you buy paid subscription plan. When a referral (coupon) code is used, both the user and you will get the benefits.",
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                  color: Colors.grey,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ),
                            SizedBox(height: 25),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "User Benefits",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "The user will get discount when he use your code while subscribing to a new plan. The user needs to enter and apply the code on the payment page.",
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 25),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Your Benefits",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "When a user completes the subscription purchases by using your referral (coupon) code, then your will get the following free benefits which includes additional Daily, Weekly, and Festival Posts along with validity.",
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(height: 1, color: Color(0xFFD6D6D6)),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Daily Post",
                                  style: TextStyle(
                                    fontSize: 16,
                                    height: 1.5,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  dailyPost,
                                  style: TextStyle(
                                    fontSize: 16,
                                    height: 1.5,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(height: 1, color: Color(0xFFD6D6D6)),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Weekly Post",
                                  style: TextStyle(
                                    fontSize: 16,
                                    height: 1.5,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  weeklyPost,
                                  style: TextStyle(
                                    fontSize: 16,
                                    height: 1.5,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(height: 1, color: Color(0xFFD6D6D6)),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Festival Post",
                                  style: TextStyle(
                                    fontSize: 16,
                                    height: 1.5,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  festivalPost,
                                  style: TextStyle(
                                    fontSize: 16,
                                    height: 1.5,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(height: 1, color: Color(0xFFD6D6D6)),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Deals Per Post",
                                  style: TextStyle(
                                    fontSize: 16,
                                    height: 1.5,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  dealsPost,
                                  style: TextStyle(
                                    fontSize: 16,
                                    height: 1.5,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(height: 1, color: Color(0xFFD6D6D6)),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Validity",
                                  style: TextStyle(
                                    fontSize: 16,
                                    height: 1.5,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  validity,
                                  style: TextStyle(
                                    fontSize: 16,
                                    height: 1.5,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(height: 1, color: Color(0xFFD6D6D6)),
                            SizedBox(height: 20),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Note",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "1. You can not use your own referral (coupon) code.",
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "2. You can send referral (coupon) code to any number of persons",
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "3. An use can redeem the referral (coupon) code only once ( for one successful plan subscription).",
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "4. However, if you want to enjoy the free benefits, you can send your referral (coupon) code to as many persons as you can.",
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "5. The free benefits will be added to you every time when a user busy any subscription plan using your referral (coupon) code.",
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "6. All the free benefits will be canceled when you are upgrading to a higher subscription plan.",
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                    _isLoading != false
                        ? fullViewLoadingUi(_isLoading)
                        : Container(),
                  ],
                )
              : flag == "4"
              ? Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      margin: EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Center(
                            child: Text(
                              "Your referral code is",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 45,
                            width: 180,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xfff5bdd6), Color(0xfff5bdd6)],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(5, 5),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Text(
                              "NOT AVAILABLE",
                              style: TextStyle(
                                color: app_theam,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          Container(
                            child: const Text(
                              "Referral code will be generated only after you buy paid subscription plan. When a referral (coupon) code is used, both the user and you will get the benefits.",
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                color: Colors.grey,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          Container(
                            alignment: Alignment.topLeft,
                            child: const Text(
                              "User Benefits",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "The user will get discount when he use your code while subscribing to a new plan. The user needs to enter and apply the code on the payment page.",
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 25),
                          Container(
                            alignment: Alignment.topLeft,
                            child: const Text(
                              "Your Benefits",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "When a user completes the subscription purchases by using your referral (coupon) code, then your will get the following free benefits which includes additional Daily, Weekly, and Festival Posts along with validity.",
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _isLoading != false
                        ? fullViewLoadingUi(_isLoading)
                        : Container(),
                  ],
                )
              : flag == "3"
              ? Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      margin: EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Center(
                            child: Text(
                              "Your referral code is",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 45,
                            width: 180,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xfff5bdd6), Color(0xfff5bdd6)],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(5, 5),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Text(
                              "NOT AVAILABLE",
                              style: TextStyle(
                                color: app_theam,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 25),
                          Container(
                            child: Text(
                              "Referral code will be generated only after you buy paid subscription plan. When a referral (coupon) code is used, both the user and you will get the benefits.",
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                color: Colors.grey,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ),
                          SizedBox(height: 25),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "User Benefits",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "The user will get discount when he use your code while subscribing to a new plan. The user needs to enter and apply the code on the payment page.",
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 25),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Your Benefits",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "When a user completes the subscription purchases by using your referral (coupon) code, then your will get the following free benefits which includes additional Daily, Weekly, and Festival Posts along with validity.",
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _isLoading != false
                        ? fullViewLoadingUi(_isLoading)
                        : Container(),
                  ],
                )
              : flag == "2"
              ? Center(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "You must be a \nBusiness Register User \nto enjoy all the benefits of referral.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "You must be a \nBusiness Register User \nto enjoy all the benefits of referral.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),

          // child: Text("Santhosh Kumar "),
          bottomNavigationBar: Container(
            height: 50,
            decoration: BoxDecoration(gradient: app_gradient),
            child: BottomAppBar(
              elevation: 0,
              padding: EdgeInsets.all(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        print("flg " + flag);
                        if (flag == "3" || flag == "4") {
                          Navigator.of(
                            context,
                          ).pushNamed(root_business_subScription);
                        } else if (flag == "2") {
                          Navigator.of(context).pushNamed(root_business_basic);
                        } else if (flag == "1") {
                          checkingLogin();
                        } else if (flag == "0") {
                          setState(() {
                            shareServicesDetails(
                              'Take Your Business Promotion to Next Level.\n\n'
                                  'Share Digital vCard, Exciting Deals and Offers through Digital Platform and Reach More Customers.\n\n'
                                  'Use Code $referralCode and Get Rs.100 Discount.',
                              "https://bit.ly/3Bo6WNb",
                            );
                          });
                        }
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(gradient: app_gradient),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            flag == "4" || flag == "3"
                                ? Text(
                                    "Buy Subscription Plan",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  )
                                : flag == "0"
                                ? Text(
                                    "Share",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  )
                                : Text(
                                    "Register Now",
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
          ),
        ),
      ),
    );
  }

  checkingLogin() async {
    try {
      var result = await Navigator.of(context).pushNamed(root_login) as bool;
      if (result == true) {
        Navigator.pop(context);
      }
    } catch (e) {
      print("Login alerts errors - " + e.toString());
    }
  }
}
