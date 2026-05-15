import 'package:flutter/material.dart';
import 'package:localkart/RoutingSetup/router-constants.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/theams_colors.dart';

class BusinessSuccessAlerts extends StatefulWidget {
  String message;
  BuildContext contextMain;

  bool isRegister = false;

  BusinessSuccessAlerts({
    Key? key,
    required this.contextMain,
    required this.message,
    required this.isRegister,
  }) : super(key: key);

  @override
  _BusinessSuccessAlerts createState() => _BusinessSuccessAlerts();
}

class _BusinessSuccessAlerts extends State<BusinessSuccessAlerts> {
  int valueHolder = 30;

  redirectHome() async {
    await Future.delayed(const Duration(milliseconds: 200), () async {
      var flag = await DBHelper().getLoginDB("flag");
      print("my rest " + flag);
      // if (widget.isRegister) {
      //   Navigator.of(widget.contextMain).popUntil(ModalRoute.withName('/home'));
      // } else {
      //   Navigator.of(
      //     widget.contextMain,
      //   ).popUntil(ModalRoute.withName('/business'));
      // }

      Navigator.pushNamedAndRemoveUntil(
        widget.contextMain,
        root_dashboard,
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(5),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 45, 5, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.message.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              Navigator.pop(context);
                              redirectHome();
                              // Navigator.of(widget.contextMain)
                              //     .pushNamedAndRemoveUntil('/business',
                              //         (Route<dynamic> route) => true);

                              // Navigator.pushReplacement(
                              // context, MaterialPageRoute(builder: (context) => HomePage()));
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: app_gradient,
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
                                    "Go to Home",
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
          const Positioned(
            top: -40,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 35,
              child: Icon(Icons.check, size: 50, color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}
