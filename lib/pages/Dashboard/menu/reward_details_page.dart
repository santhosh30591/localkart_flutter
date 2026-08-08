import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/RoutingSetup/router-constants.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RewardDetailsPage extends StatefulWidget {
  final dynamic rewardData;

  const RewardDetailsPage({Key? key, required this.rewardData})
    : super(key: key);

  @override
  State<RewardDetailsPage> createState() => _RewardDetailsPageState();
}

class _RewardDetailsPageState extends State<RewardDetailsPage> {
  bool _isLoading = true;
  dynamic _data;

  var isManaged = false;

  var tc = [];

  @override
  void initState() {
    super.initState();
    _fetchRewardInfo();
    try {
      isManaged = widget.rewardData['isManaged'];
    } catch (e) {
      print("is Manage error " + e.toString());
    }
    print("isManaged " + isManaged.toString());
  }

  Future<void> _fetchRewardInfo() async {
    try {
      setState(() {
        _isLoading = true;
      });
      userId = await DBHelper().getUserId();
      final rewardId =
          widget.rewardData['id'] ?? widget.rewardData['reward_id'];

      // Using the uatapi or base api as per config
      final url = "$subBase/rewardinfo?rewardId=$rewardId&userId=$userId";

      final response = await ApiClientLocalKart().httpGet(url);
      final result = json.decode(response.body);

      if (result['errorCode'] == 0) {
        setState(() {
          _data = result['result'];

          // tc = _data['tc'].toList();

          // print("santhosh " + _data['tc'].length.toString());
          //

          type = _data['shop_type'].toString();
          shopIndexId = _data['shop_id'].toString();
          name = _data['shop_name'].toString();
          isSubscribed = _data['isSubscribed'].toString();
          tc.clear();
          for (var item in _data['tc']) {
            tc.add("" + item.toString());
          }
          // for (var item in _data['tc'].toList()) {
          //   tc.add(item.toString());
          //   print("lkn ");
          // }

          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching reward info: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchRewardInfoCodeCheck() async {
    try {
      setState(() {
        _isLoading = true;
      });
      userId = await DBHelper().getUserId();
      final rewardId =
          widget.rewardData['id'] ?? widget.rewardData['reward_id'];

      // Using the uatapi or base api as per config
      final url = "$subBase/rewardinfo?rewardId=$rewardId&userId=$userId";

      final response = await ApiClientLocalKart().httpGet(url);
      final result = json.decode(response.body);

      if (result['errorCode'] == 0) {
        setState(() {
          _data = result['result'];

          // tc = _data['tc'].toList();

          // print("santhosh " + _data['tc'].length.toString());
          //

          type = _data['shop_type'].toString();
          shopIndexId = _data['shop_id'].toString();
          name = _data['shop_name'].toString();
          isSubscribed = _data['isSubscribed'].toString();
          tc.clear();
          for (var item in _data['tc']) {
            tc.add("" + item.toString());
          }
          // for (var item in _data['tc'].toList()) {
          //   tc.add(item.toString());
          //   print("lkn ");
          // }

          _isLoading = false;

          String qrCodeValue = _data['offer_code'] ?? "No Data";
          _showQRCodeDialog(context, qrCodeValue);
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching reward info: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return actionBarTopBottomView(
      "Details",
      context,
      Scaffold(
        backgroundColor: Colors.white,
        body: _isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : _data == null
            ? const Center(child: Text("No details available"))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Top Offer Image
                    Image.network(
                      _data['reward_image'] ?? "",
                      width: double.infinity,
                      // height: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 250,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                    // 2. Shop Info Bar
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      color: const Color(0xFFFFE1EA), // Light pink background
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: Image.network(
                                _data['shop_logo'] ?? "",
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) =>
                                    const Icon(Icons.store),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            _data['shop_name'] ?? "Shop Name",
                            style: const TextStyle(
                              color: app_theam,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 3. Voucher Header (Yellow Bar)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 12,
                      ),
                      color: const Color(0xFFFFEB3B), // Yellow background
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _data['type'] ?? "Gift Voucher.",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            _data['offer_code'] ?? "",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 4. Validity Dates Row
                    Container(
                      margin: const EdgeInsets.all(10.0),

                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _dateItem("Issued", _data['issue_from'] ?? ""),
                                Text(
                                  _data['validupto'] ?? "",
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                _dateItem(
                                  "Valid Till",
                                  _data['expiry'] ?? "",
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                ),
                              ],
                            ),
                            // const SizedBox(height: 10),
                            // const Divider(thickness: 1),
                          ],
                        ),
                      ),
                    ),

                    // 5. Offer Title & Description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _data['title'] ?? "",
                            style: const TextStyle(
                              color: app_theam,
                              fontSize: 15,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _data['description'] ?? "",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 6. Redeem At Section
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: cen,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Redeem At",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  (_data['shopDoorNo'] + "," ?? "") +
                                      (_data['shopArea'] + ",\n" ?? "") +
                                      (_data['shopLocality'] + "," ?? "") +
                                      //
                                      (_data['shopPost'] + ",\n" ?? "") +
                                      (_data['shopLandmark'] + "," ?? "") +
                                      (_data['shopDistrict'] + ",\n" ?? "") +
                                      (_data['shopState'] + "-" ?? "") +
                                      // "-" +
                                      (_data['shopPincode'] + "." ?? ""),

                                  style: const TextStyle(
                                    color: Colors.black54,
                                    height: 1.5,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Map thumbnail
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              _data['map_image'] ??
                                  "https://www.sammyfans.com/wp-content/uploads/2022/07/Use-Google-Map-Offline.png",
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: app_colorSecondary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // REMOVED: Flexible widget wrapper deleted from here
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Terms and Conditions",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: app_theam,
                            ),
                          ),
                          const SizedBox(height: 5),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: tc.length,
                            itemBuilder: (context, index) {
                              // Wrapped in a widget to handle long text wrapping safely
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "" + (index + 1).toString() + ".",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        tc[index].toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),

                    isManaged == true
                        ? Container(height: 1)
                        : isSubscribed == "0"
                        ? Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              // mainAxisAlignment: cen,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Note",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Get instant update on details, discounts, and special offers. Tab the "Subscribe" button below to subscribe to this Shop / Services.',
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          height: 1.5,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(height: 1),

                    const SizedBox(height: 70),

                    // Space for bottom buttons
                  ],
                ),
              ),
        bottomSheet: _isLoading || _data == null
            ? null
            : isManaged
            ? Container(
                height: 50,
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          getsummery();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: gradient_btn_lift,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Summary",
                            style: TextStyle(
                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 1),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Handle Redeem

                          // print(_data['is_redeem']);
                          //
                          // if (_data['is_redeem'] == true) {
                          //   showCommonToast(context, "", _data['redeem_msg']);
                          // } else {
                          //   _fetchRewardInfoCodeCheck();
                          // }

                          Map<String, String> roots = {
                            "id":
                                widget.rewardData['id'].toString() ??
                                widget.rewardData['reward_id'].toString(),
                          };

                          print("roots $roots");
                          Navigator.of(
                            context,
                          ).pushNamed(view_my_redemptions, arguments: roots);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: gradient_btn_rigth,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Redemptions",
                            style: TextStyle(
                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                height: 50,
                color: Colors.white,
                // decoration: const BoxDecoration(
                //   border: Border(
                //     top: BorderSide(color: Colors.white, width: 1),
                //   ),
                // ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          updateSubecribe();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: gradient_btn_lift,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            isSubscribed == "0" ? "Subscribe" : "Unsubscribe",
                            style: TextStyle(
                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 1),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Handle Redeem

                          print(_data['is_redeem']);

                          if (_data['is_redeem'] == true) {
                            showCommonToast(context, "", _data['redeem_msg']);
                          } else {
                            _fetchRewardInfoCodeCheck();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: gradient_btn_rigth,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _data['is_redeem'] == true ? "Redeemed" : "Redeem",
                            style: TextStyle(
                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _dateItem(
    String label,
    String date, {
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          date,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }

  void updateSubecribe() {
    _updateScribeAlerts();
  }

  var type = "";
  var shopIndexId = "";
  var userId = "";
  var name = "";
  var isSubscribed = "";

  void _updateScribeAlerts() {
    String title = "";

    if (isSubscribed == "0") {
      title = "Subscribe!";
    } else {
      title = "UnSubscribe!";
    }

    Widget yesButton = TextButton(
      child: Text("YES"),
      onPressed: () {
        _apiSubScrition();
        Navigator.pop(context);
      },
    );
    Widget noButton = TextButton(
      child: const Text("NO"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: name.isEmpty
          ? const Text("")
          : RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text:
                        "You will ${isSubscribed == '0' ? 'receive' : 'not receive'} receive notifications when ",
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  TextSpan(
                    text: name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: ' posts  Deals and Offer.Are you sure want to $title',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
      actions: [noButton, yesButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _apiSubScrition() async {
    var user_id = await DBHelper().getLoginSubDB("Id");

    String updateTypes = "savesubscribers";

    Map<String, String> inputs;
    if (isSubscribed == "0") {
      updateTypes = "savesubscribers";
      inputs = {
        "userIndexId": "" + userId,
        "shopId": shopIndexId,
        "shopType": type,
      };
    } else {
      updateTypes = "unsubscribe";
      inputs = {
        "userIndexId": "" + user_id,
        "shopId": shopIndexId,
        "shopType": type,
      };
    }

    setState(() {
      _isLoading = true;
    });

    var url = "$subBase/$updateTypes";

    var responces = await ApiClientLocalKart().httpPost(inputs, url);

    try {
      setState(() {
        _isLoading = false;
      });
      var datas = json.decode(responces.body.toString());
      print("" + datas.toString());
      if (datas['errorCode'].toString() == "0") {
        try {
          _fetchRewardInfo();
          setState(() {});
        } catch (e) {
          print("error is - " + e.toString());
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(" loading rtt " + e.toString());
    }
  }

  getsummery() async {
    final rewardId = widget.rewardData['id'] ?? widget.rewardData['reward_id'];

    Map<String, String> inputs = {"reward_id": "" + rewardId.toString()};

    setState(() {
      _isLoading = true;
    });

    var responces = await ApiClientLocalKart().httpPost(inputs, summaryapi);

    try {
      setState(() {
        _isLoading = false;
      });
      var datas = json.decode(responces.body.toString());
      if (datas['errorCode'].toString() == "0") {
        try {
          _showSummaryDialog(context, datas);
          setState(() {});
        } catch (e) {
          print("error is - " + e.toString());
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(" loading rtt " + e.toString());
    }
  }

  void _showQRCodeDialog(BuildContext context, String qrData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 160,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with Gradient and Close Button
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    gradient: LinearGradient(
                      colors: [Color(0xFF0D47A1), Color(0xFF880E4F)],
                      // Adjust to match your app_theam gradient
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Show QR Code",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                // QR Code Section
                Container(
                  // padding: const EdgeInsets.all(20),
                  color: Colors.white,
                  child: QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 260.0,
                  ),
                ),
                // const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSummaryDialog(BuildContext context, dynamic data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          // Ensures content doesn't overlap rounded corners
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Header with Gradient and Close Button ---
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0D47A1), Color(0xFF880E4F)],
                    // Blue to Purple gradient
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Alert",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),

              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    // Top Row: Allocated | Issued
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          _buildStatItem(
                            "Allocated",
                            data['result'][0]['allocated']?.toString() ?? "0",
                          ),
                          Container(
                            width: 1,
                            margin: EdgeInsets.only(top: 15, bottom: 15),

                            // thickness: 1,
                            color: Color(0xFFEEEEEE),
                          ),
                          _buildStatItem(
                            "Issued",
                            data['result'][0]['isused']?.toString() ?? "0",
                          ),
                        ],
                      ),
                    ),

                    Container(
                      height: 1,
                      margin: EdgeInsets.only(left: 15, right: 15),

                      // thickness: 1,
                      color: Color(0xFFEEEEEE),
                    ),

                    Container(
                      width: 200,
                      child: _buildStatItem(
                        "Redeemed",

                        data['result'][0]['redemed']?.toString() ?? "0",
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
