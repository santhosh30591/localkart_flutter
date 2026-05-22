import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localkart/theams_colors.dart';

class TransSuccessAlerts extends StatefulWidget {
  bool type;
  String msg;

  TransSuccessAlerts({Key? key, required this.type, required this.msg})
    : super(key: key);

  @override
  _TransSuccessAlerts createState() => _TransSuccessAlerts();
}

class _TransSuccessAlerts extends State<TransSuccessAlerts> {
  int valueHolder = 30;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            // height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
            ),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 30),

                  widget.type == true
                      ? Text(
                          widget.msg,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Text(
                          widget.msg,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
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
                              if (widget.type == true) {
                                Navigator.pop(context, true);
                              } else {
                                Navigator.pop(context, false);
                              }
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: app_gradient,
                                borderRadius: BorderRadius.circular(10),
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
                                    "Continue",
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
            child: widget.type == true
                ? CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 35,
                    child: Icon(Icons.check, size: 50, color: Colors.green),
                  )
                : CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 35,
                    child: Icon(Icons.close, size: 50, color: Colors.red),
                  ),
          ),
        ],
      ),
    );
  }
}
