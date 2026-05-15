import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/Api/service.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/notification_list.dart';
import 'package:localkart/pages/Dashboard/menu/Notification/notification_details.dart';
import 'package:localkart/pages/Dashboard/menu/Notification/notification_post_details.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';

class NotificationDetailsList extends StatefulWidget {
  NotificationDetailsList({Key? key}) : super(key: key);

  @override
  _NotificationDetailsFormState createState() =>
      _NotificationDetailsFormState();
}

class _NotificationDetailsFormState extends State<NotificationDetailsList> {
  @override
  void initState() {
    super.initState();
    _notificationModel.errorCode = 1;
    getNotifications();
  }

  bool _isLoading = false;
  NotificationModel _notificationModel = new NotificationModel();

  getNotifications() async {
    try {
      var userIndexId = "" + await DBHelper().getLoginSubDB("Id");
      // Map<String, Object> inputs = {"userIndexId": "345"};
      Map<String, Object> inputs = {"userIndexId": userIndexId};
      setState(() {
        _isLoading = true;
      });

      var responces = await ApiClient(
        context,
      ).httpPost(inputs, urlNotification);

      try {
        setState(() {
          _isLoading = false;
        });

        var datas = json.decode(responces.body.toString());

        print("datas " + datas.toString());

        if (datas['errorCode'].toString() == "0") {
          _notificationModel = NotificationModel.fromJson(datas);
          setState(() {});
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print(" notification loading list error " + e.toString());
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return actionBarTopBottomView(
      "Notification",
      context,
      Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          _notificationModel.errorCode != 0
              ? Center(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: const [
                        Icon(
                          Icons.notifications_active_outlined,
                          color: Colors.black54,
                          size: 100,
                        ),
                        SizedBox(height: 10),
                        Text("No Data Found"),
                      ],
                    ),
                  ),
                )
              : Container(
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: ListView.builder(
                      itemCount: _notificationModel.result!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _itemList(context, index);
                      },
                    ),
                  ),
                ),

          _isLoading != false ? fullViewLoadingUi(_isLoading) : Container(),
        ],
      ),
    );
  }

  Widget _itemList(BuildContext context, int index) {
    return InkWell(
      child: Container(
        width: 300,
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Card(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  _notificationModel.result![index].postType
                                      .toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              " (" +
                                  _notificationModel.result![index].fromDate
                                      .toString() +
                                  " To " +
                                  _notificationModel.result![index].toDate
                                      .toString() +
                                  ")",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              _notificationModel.result![index].postHeading
                                  .toString(),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        if (_notificationModel.result![index].type == "post") {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PostNotyDetails(
                shopIndexId:
                    "" +
                    _notificationModel.result![index].shopIndexId.toString(),
                postIndexId:
                    "" +
                    _notificationModel.result![index].postIndexId.toString(),
                postType:
                    "" + _notificationModel.result![index].shopType.toString(),
              ),
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NotificationDetails(
                notificationId: _notificationModel.result![index].postIndexId
                    .toString(),
              ),
            ),
          );
        }
      },
    );
  }
}
