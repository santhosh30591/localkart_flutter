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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 180,
            width: double.infinity,
            margin: EdgeInsets.all(5),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 45, 0, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.type == true
                      ? Text(
                          widget.msg,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Text(
                          widget.msg,
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
                                gradient: LinearGradient(
                                  colors: [app_theam, Color(0xFFf4a4c8)],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
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
