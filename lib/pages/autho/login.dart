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

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  final TextEditingController _control_mobile = TextEditingController();
  final DBHelper _dbHelper = DBHelper();
  
  String welcome = "Good Morning";
  bool value = false;
  bool _isLoading = false;
  bool isBtnEnable = false;
  String _txt_control_mob_num = "";

  @override
  void initState() {
    super.initState();
    _setWelcomeMessage();
  }

  void _setWelcomeMessage() {
    final int hours = DateTime.now().hour;
    if (hours < 11) {
      welcome = "Good Morning!";
    } else if (hours < 15) {
      welcome = "Good Afternoon!";
    } else if (hours <= 19) {
      welcome = "Good Evening!";
    } else {
      welcome = "Good Night!";
    }
  }

  @override
  void dispose() {
    _control_mobile.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/splash_bg.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 60),
                              Image.asset(
                                'assets/logo_with_name.png',
                                height: 140,
                                width: 140,
                                fit: BoxFit.cover,
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
                  Container(
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Made with ",
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                        Image.asset(
                          'assets/hart.png',
                          width: 15,
                          height: 15,
                        ),
                        const Text(
                          " in India",
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(15),
                  child: Card(
                    elevation: 20,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      child: Column(
                        children: <Widget>[
                          Text(
                            _txt_control_mob_num,
                            style: const TextStyle(color: app_theam),
                          ),
                          SizedBox(
                            width: 200,
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
                                  isBtnEnable = val.length == 10;
                                  _txt_control_mob_num = val.isEmpty ? "" : "Enter Mobile Number";
                                });
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                  style: TextStyle(decoration: TextDecoration.underline),
                                ),
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    root_web_view_nav,
                                    arguments: {
                                      "title": "Terms and Conditions",
                                      "url": urlSignupTerms,
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 150,
                            child: InkWell(
                              onTap: _handleLogin,
                              child: submitButton("Login", isBtnEnable),
                            ),
                          ),
                          const SizedBox(height: 15),
                          InkWell(
                            onTap: () => Navigator.of(context).pushNamed(root_register),
                            child: const Text(
                              "Register Now",
                              style: TextStyle(color: app_theam, fontSize: 16),
                            ),
                          ),
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

  void _handleLogin() {
    if (_control_mobile.text.length == 10) {
      if (value) {
        _apiLogin(_control_mobile.text);
      } else {
        ShowToast(context, "Please accept Terms and Conditions");
      }
    } else {
      ShowToast(context, "Enter 10 digit mobile number.");
    }
  }

  Future<void> _apiLogin(String phone) async {
    setState(() => _isLoading = true);
    try {
      final response = await HttpClients(context).httpLogin({"Phone": phone});
      final data = json.decode(response.body);
      setState(() => _isLoading = false);
      
      if (data['errorCode'] != 0) {
        ShowToastdur(context, data['message'] ?? "Please enter valid mobile number");
      } else {
        _showOtpDialog(response.body);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ShowToast(context, "Connection error. Please try again.");
    }
  }

  Future<void> _showOtpDialog(String responseBody) async {
    try {
      final data = json.decode(responseBody);
      final otp = data['otp'];
      final phone = data['result']['Phone'];

      final bool? result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => LoginOTPAlerts(otp: otp.toString()),
      );

      if (result == true) {
        final success = await _dbHelper.saveLoginDB(responseBody);
        if (success) _navigateToDashboard();
      } else if (result == false) {
        _apiLogin(phone.toString());
      }
    } catch (e) {
      ShowToast(context, "Error processing login. Please try again.");
    }
  }

  void _navigateToDashboard() {
    ShowToastdur(context, "Login Successfully.");
    Navigator.pushNamedAndRemoveUntil(context, root_dashboard, (route) => false);
  }
}
