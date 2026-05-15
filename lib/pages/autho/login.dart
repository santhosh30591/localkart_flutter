import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/Api/service.dart';
import 'package:localkart/RoutingSetup/router-constants.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/pages/autho/login_otp.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/buttons.dart';
import 'package:localkart/unit/showing.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    int hours = now.hour;

    if (hours < 11) {
      welcome = "Good Morning!";
    } else if (hours >= 11 && hours < 15) {
      welcome = "Good Afternoon!";
    } else if (hours >= 15 && hours <= 19) {
      welcome = "Good Evening!";
    } else {
      welcome = "Good Night!";
    }
  }

  bool value = false;

  String welcome = "Good Morning";
  final _control_mobile = TextEditingController();
  late BuildContext contextMain;

  bool _isLoading = false;
  bool isBtnEnable = false;

  @override
  Widget build(BuildContext context) {
    contextMain = context;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/login-reg-bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        color: Colors.white,
                        padding: EdgeInsets.all(10),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/splash_bg.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: 60),
                                Container(
                                  height: 140,
                                  width: 140,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        'assets/logo_with_name.png',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  welcome,
                                  style: const TextStyle(
                                    color: app_theam,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.only(bottom: 5),
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Made with ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                            Image.asset(
                              'assets/hart.png',
                              width: 15,
                              height: 15,
                            ),
                            const Text(
                              " in India",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
              Positioned(
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.all(15),

                    child: Card(
                      elevation: 20,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: Text(
                              _txt_control_mob_num,
                              style: const TextStyle(color: Color(0xFFee77ad)),
                            ),
                          ),
                          Container(
                            width: 200,
                            // margin: const EdgeInsets.only(
                            //   left: 10,
                            //   right: 10,
                            //   bottom: 10,
                            // ),
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: TextField(
                              maxLength: 10,
                              controller: _control_mobile,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: "Enter Mobile Number",
                                counterText: '',
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: app_theam),
                                ),
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  if (val.isEmpty) {
                                    _txt_control_mob_num = "";
                                    isBtnEnable = false;
                                  } else {
                                    if (val.length == 10) {
                                      isBtnEnable = true;
                                    } else {
                                      isBtnEnable = false;
                                    }
                                    _txt_control_mob_num =
                                        "Enter Mobile Number";
                                  }
                                });
                              },
                            ),
                          ),
                          Container(
                            child: Align(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Checkbox(
                                    activeColor: gradint_start_color,
                                    value: value,
                                    onChanged: (bool? val) {
                                      setState(() {
                                        value = val ?? false;
                                      });
                                    },
                                  ),
                                  const Text("I agree all "),
                                  InkWell(
                                    child: const Text(
                                      "Terms and Conditions.",
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    onTap: () {
                                      Map<String, String> roots = {
                                        "title": "Terms and Conditions",
                                        "url": urlSignupTerms,
                                      };
                                      Navigator.of(context).pushNamed(
                                        root_web_view_nav,
                                        arguments: roots,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: 150,
                            child: InkWell(
                              onTap: () {
                                if (_control_mobile.text.length == 10) {
                                  if (value) {
                                    _apiLogin(_control_mobile.text);
                                  } else {
                                    ShowToast(
                                      context,
                                      "Please accept Terms and Conditions",
                                    );
                                  }
                                } else {
                                  ShowToast(
                                    context,
                                    "Enter 10 digit mobile number.",
                                  );
                                }
                              },

                              child: submitButton("Login", isBtnEnable),
                            ),
                          ),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: () {
                              registerPage();
                            },
                            child: const Text(
                              "Register Now",
                              style: TextStyle(color: app_theam, fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              fullViewLoadingUi(_isLoading),
            ],
          ),
        ),
      ),
    );
  }

  registerPage() async {
    try {
      var result =
          await Navigator.of(contextMain).pushNamed(root_register) as String?;

      if (result != null && result.length > 6) {
        // _apiLogin(result);
      }
    } catch (e) {
      print("register empty data comming $e");
    }
  }

  _apiLogin(String phone) async {
    setState(() {
      _isLoading = true;
    });
    Map<String, Object> inputs = {"Phone": phone};
    var responces = await HttpClients(context).httpLogin(inputs);

    try {
      var responce = responces.body.toString();
      var datas = json.decode(responce);
      setState(() {
        _isLoading = false;
      });
      if (datas['errorCode'] != 0) {
        ShowToastdur(context, "Please enter valid mobile number");
      } else {
        showAlerts(responce);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("encode err - $e");
    }
  }

  showAlerts(String responces) async {
    try {
      var datas = json.decode(responces);

      var otp = datas['otp'];
      var phone = datas['result']['Phone'];

      var result =
          await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return LoginOTPAlerts(otp: otp.toString());
                },
              )
              as bool?;

      print("result_otp  $result");

      if (result != null) {
        if (result == true) {
          saveLocalDatabase(responces);
        } else {
          _apiLogin(phone.toString());
        }
      }
    } catch (e) {
      print("My res alerts error - $e");
    }
  }

  saveLocalDatabase(responces) async {
    var loginIs = await DBHelper().saveLoginDB(responces);
    if (loginIs) {
      goToHome();
    }
  }

  goToHome() async {
    try {
      var getLogin = await DBHelper().getLoginDB("errorCode");
      print("getLogin " + await getLogin.toString());
      if (getLogin.toString() == "0") {
        ShowToastdur(context, "Login Successfully.");
        Navigator.pushNamedAndRemoveUntil(
          context,
          root_dashboard,
          (route) => false,
        );
      }
    } catch (e) {
      print("loading error is $e");
    }
  }

  String _txt_control_mob_num = "";
}
