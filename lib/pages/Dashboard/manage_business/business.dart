import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localkart/Api/api_client.dart';

import 'package:localkart/Api/config.dart';
import 'package:localkart/Api/service.dart';
import 'package:localkart/RoutingSetup/router-constants.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/create_magasale.dart';
import 'package:localkart/pages/Dashboard/manage_business/posts/maga_sale_post.dart';
import 'package:localkart/pages/Dashboard/sliderWidget.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';
import 'package:url_launcher/url_launcher.dart';

class Business extends StatefulWidget {
  Business({Key? key}) : super(key: key);

  @override
  _BusinessFormState createState() => _BusinessFormState();
}

var sid, dId;

class _BusinessFormState extends State<Business> {
  @override
  void initState() {
    // dashboardPageReloadings(sid, dId);
    super.initState();
    _count();
  }

  var window_width = 0.0;
  var menu_size = 28.0;

  var subscribeCount;
  String viewCount = '';
  String averageRating = '';
  String EventRegister = "";
  var userIndexId;

  _count() async {
    if (!isLiveMode) {
      await getMagaSale();
    }

    var response = await HttpClients(context).getCounts();
    print(response);
    setState(() {
      subscribeCount = response['subscribeCount'];
      viewCount = response['viewCount'];
      averageRating = response['averageRating'];
    });
    await getEventRegister();
  }

  getEventRegister() async {
    userIndexId = await DBHelper().getLoginSubDB("Id");
    print("userIndexId $userIndexId");

    var url = checkRegister + "?useindexId=$userIndexId";
    var responces = await ApiClientLocalKart().httpGet(url);

    // print("userIndexId $userIndexId responces " + responces['result'].toString());

    var responseBody = jsonDecode(responces.body);

    EventRegister = responseBody['result'].toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: actionBarTopBottomView(
        "Manage Business",
        context,
        Container(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),

            // color: Color(0xFFF5F5F5),
            padding: EdgeInsets.zero,
            child: Center(
              child: Container(
                padding: EdgeInsets.zero,

                // color: Colors.white,
                width: 500,
                decoration: BoxDecoration(
                  // color: Color(0xFFF5F5F5),
                  border: Border.all(width: 1, color: Color(0xFFE0E0E0)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  color: Color(0xF8F8F5F5),
                  padding: EdgeInsets.all(0),
                  child: ListView(
                    children: [
                      SliderWidget(pageId: 'business'),
                      Container(
                        padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                        child: Card(
                          // color: Colors.red,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              15.0,
                              10.0,
                              20.0,
                              10.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star_border_outlined,
                                      color: app_theam,
                                      size: 24,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      " " + averageRating,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    if (isLiveMode) {
                                      ShowToastdur(context, "Coming Soon");
                                    } else {
                                      Navigator.of(context).pushNamed(
                                        root_business_subscribers_list,
                                      );
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.notifications_none_outlined,
                                        color: app_theam,
                                        size: 24,
                                      ),
                                      const SizedBox(height: 5),
                                      subscribeCount == null
                                          ? const Text(
                                              '',
                                              style: TextStyle(fontSize: 16),
                                            )
                                          : Text(
                                              ' $subscribeCount',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (isLiveMode) {
                                      ShowToastdur(context, "Coming Soon");
                                    } else {
                                      Map<String, String> roots = {"id": ""};
                                      Navigator.of(context).pushNamed(
                                        business_lead,
                                        arguments: roots,
                                      );
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.remove_red_eye_outlined,
                                        color: app_theam,
                                        size: 24,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        ' $viewCount',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Container(
                              color: Colors.white,
                              child: ListTile(
                                minLeadingWidth: 15,
                                leading: Image.asset(
                                  'assets/my_business_new.png',
                                  width: menu_size,
                                  height: menu_size,
                                ),
                                title: const Text(
                                  'My Business',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.navigate_next,
                                  color: Colors.grey,
                                ),
                                onTap: () {
                                  Navigator.of(
                                    context,
                                  ).pushNamed(root_business_basic_update);
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              color: Colors.white,
                              child: ListTile(
                                minLeadingWidth: 15,
                                leading: Image.asset(
                                  'assets/subscription_new.png',
                                  width: 28,
                                  height: 28,
                                ),
                                title: const Text(
                                  'Subscription & Plans',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.navigate_next,
                                  color: Colors.grey,
                                ),
                                onTap: () {
                                  Navigator.of(
                                    context,
                                  ).pushNamed(root_business_subScription);
                                },
                              ),
                            ),

                            const SizedBox(height: 20),
                            Container(
                              color: Colors.white,
                              child: ListTile(
                                minLeadingWidth: 15,
                                leading: Image.asset(
                                  'assets/ic_manage_rewards.png',
                                  width: 28,
                                  height: 28,
                                ),
                                title: const Text(
                                  'Manage Rewards',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.navigate_next,
                                  color: Colors.grey,
                                ),
                                onTap: () {
                                  if (isLiveMode) {
                                    showCommonToast(context, "", "Coming Soon");
                                  } else {
                                    Navigator.of(
                                      context,
                                    ).pushNamed(root_manage_rewards);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              color: Colors.white,
                              child: ListTile(
                                minLeadingWidth: 15,
                                leading: Image.asset(
                                  'assets/post_new.png',
                                  width: 28,
                                  height: 28,
                                ),
                                title: const Text(
                                  'Create Post',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.navigate_next,
                                  color: Colors.grey,
                                ),
                                onTap: () {
                                  if (isLiveMode) {
                                    showCommonToast(context, "", "Coming Soon");
                                  } else {
                                    Navigator.of(
                                      context,
                                    ).pushNamed(root_business_create_post);
                                  }
                                },
                              ),
                            ),

                            const SizedBox(height: 20),
                            Container(
                              color: Colors.white,
                              child: ListTile(
                                minLeadingWidth: 15,

                                leading: Image.asset(
                                  'assets/history_new.png',
                                  width: 28,
                                  height: 28,
                                ),
                                title: const Text(
                                  'Post History',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.navigate_next,
                                  color: Colors.grey,
                                ),
                                onTap: () {
                                  if (isLiveMode) {
                                    showCommonToast(context, "", "Coming Soon");
                                  } else {
                                    Navigator.of(
                                      context,
                                    ).pushNamed(root_business_ads);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              color: Colors.white,
                              child: ListTile(
                                minLeadingWidth: 15,
                                leading: Image.asset(
                                  'assets/digital_vcard.png',
                                  width: 28,
                                  height: 28,
                                ),
                                title: const Text(
                                  'Digital Vcard',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.navigate_next,
                                  color: Colors.grey,
                                ),
                                onTap: () {
                                  Navigator.of(
                                    context,
                                  ).pushNamed(root_business_digital_Vcard);
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              color: Colors.white,
                              child: ListTile(
                                minLeadingWidth: 15,
                                leading: Image.asset(
                                  'assets/help_new.png',
                                  width: 28,
                                  height: 28,
                                ),
                                title: const Text(
                                  'Help & Support',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.navigate_next,
                                  color: Colors.grey,
                                ),
                                onTap: () {
                                  Map<String, String> roots = {
                                    "title": "Help & Support",
                                    "url": urlBusinessSupport,
                                  };
                                  Navigator.of(context).pushNamed(
                                    root_web_view_nav,
                                    arguments: roots,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              color: Colors.white,
                              child: ListTile(
                                minLeadingWidth: 15,
                                leading: Image.asset(
                                  'assets/post_new.png',
                                  width: 28,
                                  height: 28,
                                ),
                                title: const Text(
                                  'Job Post',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.navigate_next,
                                  color: Colors.grey,
                                ),
                                onTap: () {
                                  if (isLiveMode) {
                                    showCommonToast(context, "", "Coming Soon");
                                  } else {
                                    Navigator.of(
                                      context,
                                    ).pushNamed(root_business_job);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            EventRegister == "1"
                                ? Container(
                                    color: Colors.white,
                                    child: ListTile(
                                      minLeadingWidth: 15,
                                      leading: Image.asset(
                                        'assets/ticketnxt.png',
                                        width: 28,
                                        height: 28,
                                      ),
                                      title: const Text(
                                        'TicketNXT - Manage Events',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      ),
                                      trailing: const Icon(
                                        Icons.navigate_next,
                                        color: Colors.grey,
                                      ),
                                      onTap: () async {
                                        if (isLiveMode) {
                                          ShowToastdur(context, "Coming Soon");
                                        } else {
                                          Navigator.of(
                                            context,
                                          ).pushNamed(root_ticketNxt);
                                        }
                                      },
                                    ),
                                  )
                                : EventRegister == "0"
                                ? Container(
                                    color: Colors.white,
                                    child: ListTile(
                                      minLeadingWidth: 15,
                                      leading: Image.asset(
                                        'assets/ticketnxt.png',
                                        width: 28,
                                        height: 28,
                                      ),
                                      title: const Text(
                                        'TicketNXT - Registration To Create Events',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      ),
                                      trailing: const Icon(
                                        Icons.navigate_next,
                                        color: Colors.grey,
                                      ),
                                      onTap: () async {
                                        await launch(
                                          'https://localkart.app/portal/events/authlogin',
                                        );
                                      },
                                    ),
                                  )
                                : Container(),
                            const SizedBox(height: 20),
                            magaSale == false
                                ? Container(height: 1, width: 1)
                                : Container(
                                    color: Colors.white,
                                    child: ListTile(
                                      minLeadingWidth: 15,
                                      leading: Container(
                                        width: 30,
                                        height: 30,
                                        child: Image.network(
                                          _magaSaleCreateModel.result![0].icon
                                              .toString(),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      title: Text(
                                        "${_magaSaleCreateModel.result![0].offerTitle}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      ),
                                      trailing: const Icon(
                                        Icons.navigate_next,
                                        color: Colors.grey,
                                      ),
                                      onTap: () {
                                        if (_magaSaleCreateModel
                                                .result![0]
                                                .isAlready
                                                .toString() ==
                                            "1") {
                                          showCommonToast(
                                            context,
                                            _magaSaleCreateModel
                                                .result![0]
                                                .offerTitle
                                                .toString(),
                                            _magaSaleCreateModel
                                                .result![0]
                                                .alreadyMessage
                                                .toString(),
                                          );
                                        } else {
                                          Navigator.of(
                                            context,
                                          ).pushNamed(root_ticketNxt);

                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MagaSalePost(
                                                    magaSaleCreateModel:
                                                        _magaSaleCreateModel,
                                                  ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                            const SizedBox(height: 35),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool magaSale = false;
  bool image = false;

  bool activeStates = true;

  ActiveStatus() {
    Widget yesButton = TextButton(
      child: Text("Yes"),
      onPressed: () async {
        // deleteBusiness();
        Navigator.pop(context1);
      },
    );
    Widget noButton = TextButton(
      child: Text("No"),
      onPressed: () async {
        Navigator.pop(context1);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Delete Account"),
      content: const Text(
        "Are you sure you want to continue? Deleting this account will remove its data from your iPhone",
      ),
      actions: [noButton, yesButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        context1 = context;
        return alert;
      },
    );
  }

  // deleteBusiness() async {
  //   var shopIndexId = "" + await DBHelper().getLoginDB("shopId");
  //   var type = "" + await DBHelper().getLoginDB("type");
  //   Map<String, Object> inputs = {
  //     "businessIndexId": "" + shopIndexId.toString(),
  //     "businessType": type.toString(),
  //   };
  //
  //   var responces = await HttpClients(context).deleteBusinessDetails(inputs);
  //   try {
  //     var responce = "" + responces.body.toString();
  //     var datas = json.decode(responce);
  //
  //     print("res =" + datas.toString());
  //
  //     if (datas['errorCode'] == 0) {
  //       try {
  //         var loginProfile = await DBHelper().getLoginAllDB();
  //         print("db  profile is " + loginProfile.toString());
  //         dynamic local = json.decode(loginProfile);
  //         local['shopId'] = "";
  //         local['type'] = "";
  //         local['flag'] = "0";
  //         var encode = await json.encode(local);
  //         await DBHelper().saveLoginDB(encode.toString());
  //         Navigator.of(context).popUntil(ModalRoute.withName('/home'));
  //       } catch (e) {
  //         print("error is - " + e.toString());
  //       }
  //
  //       setState(() {});
  //     } else {
  //       try {
  //         ShowToast(context, "" + datas['message'].toString());
  //       } catch (e) {}
  //
  //       setState(() {});
  //     }
  //   } catch (e) {
  //     print("encode err - " + e.toString());
  //   }
  // }

  late BuildContext context1;

  MagaSaleCreateModel _magaSaleCreateModel = MagaSaleCreateModel();

  getMagaSale() async {
    var userIndexId = await DBHelper().getLoginSubDB("Id");
    Map<String, Object> inputs = {"userIndexId": "" + userIndexId.toString()};

    var responces = await ApiClientLocalKart().httpPost(
      inputs,
      urlGetmegasales,
    );

    try {
      var datas = json.decode(responces.body.toString());

      if (datas['errorCode'] == 0) {
        magaSale = true;
        _magaSaleCreateModel = MagaSaleCreateModel.fromJson(datas);
        setState(() {});
      } else {
        magaSale = false;
        setState(() {});
      }
    } catch (e) {
      print("encode err - " + e.toString());
    }
  }
}
