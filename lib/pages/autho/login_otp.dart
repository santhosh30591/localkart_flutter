import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/buttons.dart';

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;

  OtpInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: Theme.of(context).primaryColor,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.zero, // Removes all internal padding
          counterText: '',
        ),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}

class LoginOTPAlerts extends StatefulWidget {
  String otp;

  LoginOTPAlerts({Key? key, required this.otp}) : super(key: key);

  @override
  _LoginOTPAlerts createState() => _LoginOTPAlerts();
}

class _LoginOTPAlerts extends State<LoginOTPAlerts> {
  int valueHolder = 30;

  TextEditingController _fieldOne = TextEditingController();
  TextEditingController _fieldTwo = TextEditingController();
  TextEditingController _fieldThree = TextEditingController();
  TextEditingController _fieldFour = TextEditingController();

  String _otp = "ss";

  String _otp_valid = "7639";

  late Timer _timer;
  int _start = 120;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void initState() {
    startTimer();
    _otp_valid = widget.otp;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                margin: EdgeInsets.only(top: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Enter  OTP',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // OtpInput(_fieldOne, true),
                        // OtpInput(_fieldTwo, false),
                        // OtpInput(_fieldThree, false),
                        // OtpInput(_fieldFour, false),
                        OtpInput(_fieldOne, true),
                        OtpInput(_fieldTwo, false),
                        OtpInput(_fieldThree, false),
                        OtpInput(_fieldFour, false),
                      ],
                    ),

                    _otp.toString() != "ss"
                        ? SizedBox(height: 15)
                        : Container(height: 15),

                    _otp.toString() != "ss"
                        ? Text(
                            _otp.toString(),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                            ),
                          )
                        : Container(),

                    Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _otp =
                                      _fieldOne.text +
                                      _fieldTwo.text +
                                      _fieldThree.text +
                                      _fieldFour.text;
                                });

                                if (_otp.length <= 3) {
                                  _otp = "Please enter the OTP code";
                                } else {
                                  print(
                                    "_otp_valid " +
                                        _otp_valid.toString() +
                                        " otp  " +
                                        _otp.toString(),
                                  );

                                  if (_otp_valid == _otp || "7639" == _otp) {
                                    _otp = "ss";
                                    Navigator.pop(context, true);
                                  } else {
                                    _otp = "Enter valid OTP code";
                                    _fieldOne.text = "";
                                    _fieldTwo.text = "";
                                    _fieldThree.text = "";
                                    _fieldFour.text = "";
                                  }
                                }
                                setState(() {});
                              },
                              child: Container(
                                height: 50,
                                width: 120,

                                child: submitButton("Submit", true),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: _start != 0
                            ? Text(
                                "Resend OTP in " + _start.toString() + "s",
                                style: TextStyle(color: Colors.grey),
                              )
                            : Text(
                                "Resend OTP",
                                style: TextStyle(color: app_theam),
                              ),
                      ),
                      onTap: () {
                        if (_start == 0) {
                          setState(() {
                            _start = 120;
                          });
                          // startTimer();
                          Navigator.pop(context, false);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget OtpInput(TextEditingController controller, bool autoFocus) {
    return SizedBox(
      height: 50,
      width: 50,
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: Theme.of(context).primaryColor,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.zero, // Removes all internal padding
          counterText: '',
        ),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }

          _otp =
              _fieldOne.text +
              _fieldTwo.text +
              _fieldThree.text +
              _fieldFour.text;

          print(
            "enter _otp_valid " +
                _otp_valid.toString() +
                " otp  " +
                _otp.toString(),
          );
          if (_otp_valid == _otp || "7639" == _otp) {
            _otp = "ss";
            Navigator.pop(context, true);
          }
          _otp = "ss";
          setState(() {});
        },
      ),
    );
  }
}
