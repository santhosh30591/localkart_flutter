// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';
import 'package:localkart/model/businessModel/subscription_list.dart';
import 'package:localkart/theams_colors.dart';

Future<String> showBotPlanHistor(
  BuildContext context,
  String pack,
  ResultMore plan,
  String date,
  String endDate,
) async {
  return await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
    ),
    builder: (context) {
      return Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewPaddingOf(context).bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: new BoxDecoration(
                  gradient: app_gradient,
                  borderRadius: const BorderRadius.only(
                    // ignore: prefer_const_constructors
                    topRight: Radius.circular(15.0),
                    topLeft: Radius.circular(15.0),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Align(
                          alignment: Alignment.center,
                          child: Text(
                            pack,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.clear_outlined,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 150,
                color: Colors.white,
                padding: EdgeInsets.only(bottom: 5, top: 5),

                child: Container(
                  width: double.infinity,

                  margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                  padding: EdgeInsets.only(bottom: 5, top: 5),
                  decoration: new BoxDecoration(
                    border: Border.all(color: Color(0xFFE0E0E0), width: 1),
                    color: Color(0x6AF5F4F4),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Container(
                          child: Row(
                            children: [
                              Container(
                                child: Expanded(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          plan.dailyTotalCount.toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "Daily Post Count",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Expanded(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          plan.weeklyTotalCount.toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "Weekly Post Count",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
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
                      Expanded(
                        child: Container(
                          child: Row(
                            children: [
                              Container(
                                child: Expanded(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          plan.festivalTotalCount.toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "Festival Post Count",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Expanded(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          plan.dealsTotalCount!.toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "Deals Count",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
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
                    ],
                  ),
                ),
              ),

              Container(
                color: Colors.white,
                width: double.infinity,

                child: Container(
                  // color: Colors.white,
                  width: double.infinity,
                  height: 220,
                  margin: EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 10,
                    bottom: 10,
                  ),

                  decoration: new BoxDecoration(
                    // border: Border.all(width: 1),
                    border: Border.all(color: Color(0xFFE0E0E0), width: 1),

                    color: Color(0x6AF5F4F4),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: GridView.count(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    // crossAxisSpacing: 2.0,
                    // mainAxisSpacing: 2.0,
                    childAspectRatio: (1 / .4),

                    children: [
                      for (
                        int index = 0;
                        index < plan.othersList!.length;
                        index++
                      )
                        Container(
                          // height: 40,
                          // color: Colors.green,
                          padding: EdgeInsets.all(5),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                plan.othersList![index].value.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                plan.othersList![index].keyName.toString(),
                                style: TextStyle(
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
              ),

              // SizedBox(height: 15),
            ],
          ),
        ),
      );
    },
  );
}
