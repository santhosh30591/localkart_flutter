import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/Api/service.dart';
import 'package:localkart/RoutingSetup/root_data_pass.dart';
import 'package:localkart/RoutingSetup/router-constants.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/showing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class NavBar extends StatefulWidget {
  NavBar({Key? key}) : super(key: key);

  @override
  _NavBar createState() => _NavBar();
}

class _NavBar extends State<NavBar> {
  late BuildContext contextMain;
  late BuildContext contextMainAlerts;

  var image_higth = 10.0;
  var image_left = 10.0;
  var image_space = 1.0;

  late SharedPreferences prefs1;

  String userName = "Guest User";
  String userEmail = "info@localkart.app";
  String userProfile = "";
  bool isLogin = false;

  var flag = "";

  @override
  void initState() {
    retrieve();
    super.initState();
  }

  var ScanEvents = '';
  var ScanUserId = "";

  var dbhelper = DBHelper();

  retrieve() async {
    try {
      dbhelper = await DBHelper();
      prefs1 = await SharedPreferences.getInstance();
      var getLogin = await DBHelper().getLoginDB("errorCode");

      flag = await DBHelper().getLoginDB("flag");
      print("getLogin " + getLogin.toString());

      if (getLogin.toString() == "0") {
        isLogin = true;
        userName = await dbhelper.getLoginSubDB("Name");
        // ScanEvents = await DBHelper().getLoginSubDB("scan_events");
        // ScanUserId = await DBHelper().getLoginSubDB("scan_userid");

        print(userName);
        userEmail = await DBHelper().getLoginSubDB("Phone");
        userProfile = await DBHelper().getLoginSubDB("profileImage");
      } else {
        isLogin = false;
      }
      print("ScanEvents nav " + await ScanEvents.toString());
    } catch (e) {
      print("loading error is " + e.toString());
    }
    setState(() {});
  }

  goToBusinessDetails() async {
    try {
      var flag1 = await DBHelper().getLoginDB("flag");
      if (flag1.toString() == "0") {
        Navigator.of(contextMain).pushNamed(root_business_basic);
      } else {
        Navigator.of(contextMain).pushNamed(root_business);
      }
    } catch (e) {
      print("loading error is " + e.toString());
    }
    setState(() {});
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget yesButton = TextButton(
      child: Text("YES"),
      onPressed: () async {
        await dbhelper.logOutDB();

        Navigator.pushNamedAndRemoveUntil(
          contextMainAlerts,
          root_login,
          (route) => false,
        );
      },
    );
    Widget noButton = TextButton(
      child: Text("NO"),
      onPressed: () {
        Navigator.pop(contextMainAlerts, true);
        // Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout!"),
      content: Text("Are you sure you want logout?"),
      actions: [noButton, yesButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        contextMainAlerts = context;
        contextMain = context;
        return alert;
      },
    );
  }

  void wait() async {
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    contextMain = context;

    var menuViewSpace = 4.0;
    var menuImgHeightWidth = 20.0;

    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          if (isLogin) ...[
            Container(
              decoration: BoxDecoration(gradient: app_gradient),
              padding: const EdgeInsets.only(top: 10, left: 15),
              height: 100,
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Container(
                    child: userProfile.length == 0
                        ? Icon(
                            Icons.account_circle_outlined,
                            size: 50,
                            color: Colors.white,
                          )
                        : Container(
                            width: 70,
                            height: 70,
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[200],
                              radius: 65,
                              backgroundImage: AssetImage('assets/loading.gif'),
                              child: CircleAvatar(
                                radius: 65,
                                backgroundColor: Colors.transparent,
                                backgroundImage: NetworkImage(
                                  userProfile,
                                  headers: {},
                                ),
                              ),
                            ),
                          ),
                  ),
                  Container(
                    height: 55,
                    margin: EdgeInsets.only(left: 15, top: 8),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            userEmail,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Container(
              height: 100,
              margin: EdgeInsets.only(top: 40, bottom: 10),
            ),
            Divider(),
          ],
          if (isLogin) ...[
            const SizedBox(height: 8),
            InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Image.asset(
                      'assets/ic_user.png',
                      width: 18,
                      height: 18,
                      fit: BoxFit.cover,
                      color: Colors.black54,
                    ),
                    // child: Icon(Icons.play_circle_outline),
                    padding: EdgeInsets.all(image_higth),
                    margin: EdgeInsets.only(left: image_left),
                  ),
                  SizedBox(width: image_space),
                  const Text(
                    'Profile',
                    style: TextStyle(
                      // fontWeight: FontWeight.w600,
                      color: Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(contextMain).pushNamed(root_profile_nav);
              },
            ),
          ],
          SizedBox(height: menuViewSpace),

          isLiveMode
              ? Container()
              : InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Image.asset(
                          'assets/ic_abouts.png',
                          width: menuImgHeightWidth,
                          height: menuImgHeightWidth,
                          fit: BoxFit.cover,
                          color: Colors.black54,
                        ),
                        // child: Icon(Icons.play_circle_outline),
                        padding: EdgeInsets.all(image_higth),
                        margin: EdgeInsets.only(left: image_left),
                      ),
                      SizedBox(width: image_space),
                      const Text(
                        'My Bookings',
                        style: TextStyle(
                          // fontWeight: FontWeight.w600,
                          color: Colors.black54,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(contextMain).pushNamed(root_my_bookings);
                  },
                ),

          isLiveMode
              ? Container()
              : InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(image_higth),
                        margin: EdgeInsets.only(left: image_left),
                        child: Image.asset(
                          'assets/my_booking.png',
                          width: menuImgHeightWidth,
                          height: menuImgHeightWidth,
                          fit: BoxFit.cover,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(width: image_space),
                      const Text(
                        'My Rewards',
                        style: TextStyle(
                          // fontWeight: FontWeight.w600,
                          color: Colors.black54,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(contextMain).pushNamed(root_my_rewards);
                  },
                ),

          InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Image.asset(
                    'assets/ic_abouts.png',
                    width: menuImgHeightWidth,
                    height: menuImgHeightWidth,
                    fit: BoxFit.cover,
                    color: Colors.black54,
                  ),
                  // child: Icon(Icons.play_circle_outline),
                  padding: EdgeInsets.all(image_higth),
                  margin: EdgeInsets.only(left: image_left),
                ),
                SizedBox(width: image_space),
                const Text(
                  'About Us',
                  style: TextStyle(
                    // fontWeight: FontWeight.w600,
                    color: Colors.black54,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            onTap: () {
              // RootDataPassing roots = new RootDataPassing();
              // roots.title = "About Us";
              // roots.url =
              //     "We are a technology-based marketing company providing technology solutions to business owners by connecting them directly to customers via mobile app. Shop/Service Providers list your business in directory, send digital vCard, promote deals, discounts and offers, send instant notifications and updates via mobile app, increase sales via mega local sale events and lot more.\n\n Customers can get updates about Deals, Discounts and Offers around themu and Business Owners can take your business promotion to the next level with our mobile app and reach more customers.";
              Navigator.pop(context);

              Map<String, String> roots = {
                "title": "About Us",
                "url": urlSignupTerms,
              };

              Navigator.of(
                contextMain,
              ).pushNamed(root_web_view_nav, arguments: roots);
            },
          ),

          // InkWell(
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         Container(
          //           child: Image.asset(
          //             'assets/ic_ticket.png',
          //             width: menuImgHeightWidth,
          //             height: menuImgHeightWidth,
          //             fit: BoxFit.cover,
          //             color: Colors.black54,
          //           ),
          //           // child: Icon(Icons.play_circle_outline),
          //           padding: EdgeInsets.all(image_higth),
          //           margin: EdgeInsets.only(left: image_left),
          //         ),
          //         SizedBox(width: image_space),
          //         const Text(
          //           'Events - TicketOne',
          //           style: TextStyle(
          //               // fontWeight: FontWeight.w600,
          //               color: Colors.black54,
          //               fontSize: 17),
          //         )
          //       ],
          //     ),
          //     onTap: () async {
          //       // Navigator.pop(context);
          //       // Navigator.of(contextMain).pushNamed(root_profile_nav);
          //       await launch('https://localkart.app/events/');
          //     }),
          if (ScanEvents == "true") ...[
            SizedBox(height: menuViewSpace),
            InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Image.asset(
                      'assets/qr-scan.png',
                      width: menuImgHeightWidth,
                      height: menuImgHeightWidth,
                      fit: BoxFit.cover,
                      color: Colors.black54,
                    ),
                    // child: Icon(Icons.play_circle_outline),
                    padding: EdgeInsets.all(image_higth),
                    margin: EdgeInsets.only(left: image_left),
                  ),
                  SizedBox(width: image_space),
                  const Text(
                    'TicketNXT QR Scan',
                    style: TextStyle(
                      // fontWeight: FontWeight.w600,
                      color: Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              onTap: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => ScanAgentEventsListing(ScanUserId),
                //   ),
                // );
              },
            ),
          ],
          if (isLogin) ...[
            SizedBox(height: menuViewSpace),
            InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Image.asset(
                      'assets/ic_mybusiness.png',
                      width: menuImgHeightWidth,
                      height: menuImgHeightWidth,
                      fit: BoxFit.cover,
                      color: Colors.black54,
                    ),
                    // child: Icon(Icons.play_circle_outline),
                    padding: EdgeInsets.all(image_higth),
                    margin: EdgeInsets.only(left: image_left),
                  ),
                  SizedBox(width: image_space),
                  flag == "0"
                      ? const Text(
                          'Advertise Your Business',
                          style: TextStyle(
                            // fontWeight: FontWeight.w600,
                            color: Colors.black54,
                            fontSize: 15,
                          ),
                        )
                      : const Text(
                          'Manage My Business',
                          style: TextStyle(
                            // fontWeight: FontWeight.w600,
                            color: Colors.black54,
                            fontSize: 15,
                          ),
                        ),
                ],
              ),
              onTap: () {
                goToBusinessDetails();
                Navigator.pop(context);
              },
            ),
          ],
          SizedBox(height: menuViewSpace),
          InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Image.asset(
                    'assets/ic_how_working.png',
                    width: menuImgHeightWidth,
                    height: menuImgHeightWidth,
                    fit: BoxFit.cover,
                    color: Colors.black54,
                  ),
                  // child: Icon(Icons.play_circle_outline),
                  padding: EdgeInsets.all(image_higth),
                  margin: EdgeInsets.only(left: image_left),
                ),
                SizedBox(width: image_space),
                const Text(
                  'How It Works',
                  style: TextStyle(
                    // fontWeight: FontWeight.w600,
                    color: Colors.black54,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            onTap: () {
              RootDataPassing roots = new RootDataPassing();
              roots.title = "How It Works";
              // roots.url = "https://www.youtube.com/embed/b4Y9ArZ65mg";
              roots.url = "https://localkart.app/app/how-it-works.php";
              Navigator.pop(context);
              launchInBrowser(roots.url);
              // Navigator.of(contextMain)
              //     .pushNamed(root_web_view_nav, arguments: roots);
            },
          ),
          SizedBox(height: menuViewSpace),
          InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Image.asset(
                    'assets/ic_handshake.png',
                    width: menuImgHeightWidth,
                    height: menuImgHeightWidth,
                    fit: BoxFit.cover,
                    color: Colors.black54,
                  ),
                  // child: Icon(Icons.play_circle_outline),
                  padding: EdgeInsets.all(image_higth),
                  margin: EdgeInsets.only(left: image_left),
                ),
                SizedBox(width: image_space),
                const Text(
                  'Become A Franchise',
                  style: TextStyle(
                    // fontWeight: FontWeight.w600,
                    color: Colors.black54,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            onTap: () {
              Map<String, String> roots = {
                "title": "Become A Franchise",
                "url": urlFranchise,
              };

              Navigator.pop(context);
              Navigator.of(
                contextMain,
              ).pushNamed(root_web_view_nav, arguments: roots);
            },
          ),
          SizedBox(height: menuViewSpace),
          InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Image.asset(
                    'assets/ic_share.png',
                    width: menuImgHeightWidth,
                    height: menuImgHeightWidth,
                    fit: BoxFit.cover,
                    color: Colors.black54,
                  ),
                  // child: Icon(Icons.play_circle_outline),
                  padding: EdgeInsets.all(image_higth),
                  margin: EdgeInsets.only(left: image_left),
                ),
                SizedBox(width: image_space),
                const Text(
                  'Share',
                  style: TextStyle(
                    // fontWeight: FontWeight.w600,
                    color: Colors.black54,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            onTap: () {
              shareLocalKart();
              Navigator.pop(context);
            },
          ),
          if (isLogin) ...[
            SizedBox(height: menuViewSpace),
            InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Image.asset(
                      'assets/ic_user_referal.png',
                      width: menuImgHeightWidth,
                      height: menuImgHeightWidth,
                      fit: BoxFit.cover,
                      color: Colors.black54,
                    ),
                    // child: Icon(Icons.play_circle_outline),
                    padding: EdgeInsets.all(image_higth),
                    margin: EdgeInsets.only(left: image_left),
                  ),
                  SizedBox(width: image_space),
                  const Text(
                    'Refer',
                    style: TextStyle(
                      // fontWeight: FontWSanthosheight.w600,
                      color: Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(contextMain).pushNamed(root_referal);
              },
            ),
            SizedBox(height: menuViewSpace),
            InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Image.asset(
                      'assets/ic_feedback.png',
                      width: menuImgHeightWidth,
                      height: menuImgHeightWidth,
                      fit: BoxFit.cover,
                      color: Colors.black54,
                    ),
                    // child: Icon(Icons.play_circle_outline),
                    padding: EdgeInsets.all(image_higth),
                    margin: EdgeInsets.only(left: image_left),
                  ),
                  SizedBox(width: image_space),
                  const Text(
                    'Feedback',
                    style: TextStyle(
                      // fontWeight: FontWeight.w600,
                      color: Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(contextMain).pushNamed(root_feedback);
              },
            ),
            // SizedBox(height: menuViewSpace),
            isLiveMode
                ? Container()
                : InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Image.asset(
                            'assets/ic_notification.png',
                            width: menuImgHeightWidth,
                            height: menuImgHeightWidth,
                            fit: BoxFit.cover,
                            color: Colors.black54,
                          ),
                          // child: Icon(Icons.play_circle_outline),
                          padding: EdgeInsets.all(image_higth),
                          margin: EdgeInsets.only(left: image_left),
                        ),
                        SizedBox(width: image_space),
                        const Text(
                          'Notification',
                          style: TextStyle(
                            // fontWeight: FontWeight.w600,
                            color: Colors.black54,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      checkingLoginNotification();
                    },
                  ),

            isLiveMode ? Container() : SizedBox(height: menuViewSpace),
            isLiveMode
                ? Container()
                : InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Image.asset(
                            'assets/ic_trans.png',
                            width: menuImgHeightWidth,
                            height: menuImgHeightWidth,
                            fit: BoxFit.cover,
                            color: Colors.black54,
                          ),
                          // child: Icon(Icons.play_circle_outline),
                          padding: EdgeInsets.all(image_higth),
                          margin: EdgeInsets.only(left: image_left),
                        ),
                        SizedBox(width: image_space),
                        const Text(
                          'Bill Payment History',
                          style: TextStyle(
                            // fontWeight: FontWeight.w600,
                            color: Colors.black54,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(contextMain, root_billbay_history);
                    },
                  ),
            isLiveMode ? Container() : SizedBox(height: menuViewSpace),
            isLiveMode
                ? Container()
                : InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Image.asset(
                            'assets/ic_trans.png',
                            width: menuImgHeightWidth,
                            height: menuImgHeightWidth,
                            fit: BoxFit.cover,
                            color: Colors.black54,
                          ),
                          // child: Icon(Icons.play_circle_outline),
                          padding: EdgeInsets.all(image_higth),
                          margin: EdgeInsets.only(left: image_left),
                        ),
                        SizedBox(width: image_space),
                        const Text(
                          'Transaction History',
                          style: TextStyle(
                            // fontWeight: FontWeight.w600,
                            color: Colors.black54,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(contextMain).pushNamed(root_trans_list);
                    },
                  ),
          ],

          SizedBox(height: menuViewSpace),
          InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(image_higth),
                  margin: EdgeInsets.only(left: image_left),
                  child: Image.asset(
                    'assets/ic_ration.png',
                    width: menuImgHeightWidth,
                    height: menuImgHeightWidth,
                    fit: BoxFit.cover,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(width: image_space),
                const Text(
                  'Rate Us',
                  style: TextStyle(
                    // fontWeight: FontWeight.w600,
                    color: Colors.black54,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            onTap: () {
              // RootDataPassing roots = new RootDataPassing();
              // roots.title = "Rate Us";
              // roots.url =
              //     "https://play.google.com/store/apps/details?id=com.localkartmarketing.localkart";
              // Navigator.pop(context);
              // Navigator.of(contextMain)
              //     .pushNamed(root_web_view_nav, arguments: roots);

              Navigator.pop(context);

              if (Platform.isAndroid) {
                var appPackageName = "com.localkartmarketing.localkart";
                try {
                  launch("market://details?id=" + appPackageName);
                } on PlatformException catch (e) {
                  launch(
                    "https://play.google.com/store/apps/details?id=" +
                        appPackageName,
                  );
                }
              } else if (Platform.isIOS) {
                launch(
                  "https://testflight.apple.com/v1/invite/302317bc1a79407bb9c13f11890ebb76ec3795425b07407baa436e11cbd57d7461514ce7?ct=99HU8X7PK2&advp=10000&platform=ios",
                );
              }
            },
          ),
          SizedBox(height: menuViewSpace),
          InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(image_higth),
                  margin: EdgeInsets.only(left: image_left),
                  child: Image.asset(
                    'assets/ic_privacy.png',
                    width: menuImgHeightWidth,
                    height: menuImgHeightWidth,
                    fit: BoxFit.cover,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(width: image_space),
                const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    // fontWeight: FontWeight.w600,
                    color: Colors.black54,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Map<String, String> roots = {
                "title": "Privacy Policy",
                "url": "https://www.localkart.app/privacy-policy.php",
              };

              Navigator.of(
                contextMain,
              ).pushNamed(root_web_view_nav, arguments: roots);
            },
          ),
          if (isLogin) ...[
            SizedBox(height: menuViewSpace),
            InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(image_higth),
                    margin: EdgeInsets.only(left: image_left),
                    child: Image.asset(
                      'assets/ic_logout.png',
                      width: menuImgHeightWidth,
                      height: menuImgHeightWidth,
                      fit: BoxFit.cover,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(width: image_space),
                  const Text(
                    'Logout',
                    style: TextStyle(
                      // fontWeight: FontWeight.w600,
                      color: Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                showAlertDialog(contextMain);
              },
            ),
          ] else ...[
            SizedBox(height: menuViewSpace),
            InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(image_higth),
                    margin: EdgeInsets.only(left: image_left),
                    child: Image.asset(
                      'assets/ic_login.png',
                      width: menuImgHeightWidth,
                      height: menuImgHeightWidth,
                      fit: BoxFit.cover,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(width: image_space),
                  const Text(
                    'Login',
                    style: TextStyle(
                      // fontWeight: FontWeight.w600,
                      color: Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                checkingLogin();
              },
            ),
          ],
          SizedBox(height: menuViewSpace),
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 160,
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/flag_ind.png',
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                      ),
                      const Text(
                        " India ",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const Text(
                        "- ",
                        style: TextStyle(color: Colors.grey, fontSize: 17),
                      ),
                      Image.asset(
                        'assets/lang_en.png',
                        width: menuImgHeightWidth,
                        height: menuImgHeightWidth,
                        fit: BoxFit.cover,
                      ),
                      const Text(
                        " English",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Version 1.0",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ),
              ],
            ),
            //
          ),
        ],
      ),
    );
  }

  checkingLogin() async {
    try {
      var result = await Navigator.of(context).pushNamed(root_login) as bool;
      if (result == true) {
        print("login success");
      }
    } catch (e) {
      print("Login alerts errors - " + e.toString());
    }
  }

  checkingLoginNotification() async {
    if (isLogin) {
      Navigator.pop(context);
      Navigator.of(contextMain).pushNamed(root_notification_list);
    } else {
      try {
        var result = await Navigator.of(context).pushNamed(root_login) as bool;
        if (result == true) {
          Navigator.pop(context);
          Navigator.of(contextMain).pushNamed(root_notification_list);
        }
      } catch (e) {
        print("Login alerts errors - " + e.toString());
      }
    }
  }
}
