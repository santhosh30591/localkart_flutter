import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/Api/service.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';

class FeedBack extends StatefulWidget {
  FeedBack({Key? key}) : super(key: key);

  @override
  _FeedBackFormState createState() => _FeedBackFormState();
}

class _FeedBackFormState extends State<FeedBack> {
  @override
  void initState() {
    super.initState();
  }

  bool _isLoading = false;

  feedbackUpdates(String feedback) async {
    try {
      var userIndexId = "" + await DBHelper().getLoginSubDB("Id");
      Map<String, Object> inputs = {
        "userIndexId": "" + userIndexId,
        "feedBack": feedback,
      };

      setState(() {
        _isLoading = true;
      });

      var responces = await ApiClientLocalKart().httpPost(inputs,urlFeedBack);
      try {
        setState(() {
          _isLoading = false;
        });

        var datas = json.decode(responces.body.toString());

        print("datas " + datas.toString());

        if (datas['errorCode'].toString() == "0") {
          ShowToastdur(context, datas['Message'].toString());
          FocusScope.of(context).requestFocus(FocusNode());
          Navigator.pop(context);
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print(" loading rtt " + e.toString());
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  final _editFeedBack = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: actionBarTopBottomView(
        "Feedback",
        context,
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Container(
                    child: TextField(
                      controller: _editFeedBack,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.text,
                      maxLines: 6,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        focusColor: Colors.grey,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        hintText: "Please enter your feedback",
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
                      if (_editFeedBack.text.toString().length < 3) {
                        ShowToast(context, "Please enter some feedback");
                      } else {
                        feedbackUpdates(_editFeedBack.text.toString());
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
      ),
    );
  }
}
