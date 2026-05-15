import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localkart/theams_colors.dart';

class NearMeshowLocationAlerts extends StatefulWidget {
  String titles;

  NearMeshowLocationAlerts({Key? key, required this.titles}) : super(key: key);

  @override
  _NearMeshowLocationAlerts createState() => _NearMeshowLocationAlerts();
}

class _NearMeshowLocationAlerts extends State<NearMeshowLocationAlerts> {
  int valueHolder = 30;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 280,
            // color: Colors.white,
            width: double.infinity,
            // margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 50, 0, 5),
              child: Column(
                children: [
                  Text(
                    'Show ${widget.titles} with radius of kilometer',
                    style: TextStyle(fontSize: 15),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 30),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("   0"), //
                              Spacer(),
                              Text("60  "),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 55),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$valueHolder KM',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: app_theam,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Slider(
                          value: valueHolder.toDouble(),
                          min: 1,
                          max: 60,
                          divisions: 60,
                          activeColor: app_theam,
                          inactiveColor: Colors.grey,
                          label: '${valueHolder.round()}',
                          onChanged: (double newValue) {
                            setState(() {
                              valueHolder = newValue.round();
                            });
                          },
                          semanticFormatterCallback: (double newValue) {
                            return '${newValue.round()}';
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context, "0");
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: gradient_btn_lift,
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
                                    " Cancel",
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
                        Container(height: 50, width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(
                                context,
                                "" + valueHolder.toString(),
                              );
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
                                    "Ok",
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
        ],
      ),
    );
  }
}
