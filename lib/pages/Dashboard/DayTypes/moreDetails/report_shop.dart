import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localkart/Api/service.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';

class ReportThisShop extends StatefulWidget {
  String type;
  String shopIndexId;

  ReportThisShop({Key? key, required this.type, required this.shopIndexId})
    : super(key: key);

  @override
  _ReportThisShopFormState createState() => _ReportThisShopFormState();
}

bool _isLoading = false;

class _ReportThisShopFormState extends State<ReportThisShop> {
  @override
  void initState() {
    super.initState();
  }

  var _editReportThisShop = TextEditingController();
  late BuildContext contextMain;

  @override
  Widget build(BuildContext context) {
    contextMain = context;
    return actionBarTopBottomView(
      "Report This Shop",
      context,
      Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: new EdgeInsets.all(12.0),
            child: Column(
              children: [
                Container(
                  child: TextField(
                    controller: _editReportThisShop,
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.text,
                    maxLines: 6,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      focusColor: Colors.grey,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      hintText: "Enter your Complaint",
                      fillColor: Colors.grey,
                    ),
                    onChanged: (str) {
                      // To do
                    },
                    onSubmitted: (str) {
                      print("submit");
                      // To do
                    },
                  ),
                ),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    if (_editReportThisShop.text.length < 5) {
                      ShowToast(context, "Please enter some word");
                    } else {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      setState(() {});

                      _apiReports();
                    }
                  },
                  child: Container(
                    height: 45,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: app_gradient,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(5, 5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'SUBMIT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _isLoading != false ? fullViewLoadingUi(_isLoading) : Container(),
        ],
      ),
    );
  }

  _apiReports() async {
    setState(() {
      _isLoading = true;
    });

    var user_id = await DBHelper().getLoginSubDB("Id");

    Map<String, String> inputs = {
      "userIndexId": "" + user_id,
      "reports": "" + _editReportThisShop.text,
      "shopIndexId": "" + widget.shopIndexId.toString(),
      "shopType": "" + widget.type.toString(),
      "postIndexId": "",
    };

    var responces = await HttpClients(context).httpReports(inputs);
    try {
      setState(() {
        _isLoading = false;
      });

      try {
        var responce = "" + responces.body.toString();
        var datas = json.decode(responce);
        print("myres - " + datas.toString());

        if (datas['errorCode'] == 0) {
          // ShowToast(context, "" + datas['message'].toString());
          showAlertDialog();
        } else {
          try {
            ShowToast(context, "" + datas['message'].toString());
          } catch (e) {}
        }
      } catch (e) {}
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  showAlertDialog() {
    // set up the button
    Widget yesButton = TextButton(
      child: Text("OK"),
      onPressed: () async {
        Navigator.pop(context2);
        Navigator.pop(contextMain);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: const Text(
        "Your message has been submitted successfully and will be reviewed shortly. Thank you.",
      ),
      actions: [yesButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        context2 = context;
        return alert;
      },
    );
  }

  late BuildContext context2;
}
