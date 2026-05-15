import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/Api/service.dart';
import 'package:localkart/RoutingSetup/router-constants.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/buttons.dart';
import 'package:localkart/unit/showing.dart';
import 'package:localkart/unit/showingStateListAletrs.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  _Register createState() => _Register();
}

class _Register extends State<Register> {
  @override
  void initState() {
    getStateList();
    super.initState();
  }

  bool value = false;
  String welcome = "Welcome";
  var _control_name = TextEditingController();
  var _control_mobile = TextEditingController();
  var _control_state = TextEditingController();
  var _control_dist = TextEditingController();

  late BuildContext contextMain;


  var _isLoading=false;

  @override
  Widget build(BuildContext context) {
    contextMain = context;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Container(
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
                      height: 400,
                      margin: EdgeInsets.only(top: 170, left: 15, right: 15),
                      child: Card(
                        elevation: 20,
                        color: Colors.white,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 15),
                              child: Text(
                                "NEW USER",
                                style: TextStyle(
                                  color: app_theam,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                left: 10,
                                right: 10,
                                bottom: 5,
                              ),
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: TextField(
                                maxLength: 20,
                                controller: _control_name,
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.text,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  hintText: "Enter Your Name",
                                  labelText: "Name",
                                  counterText: '',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: app_theam),
                                  ),
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                onChanged: (val) {},
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: TextField(
                                maxLength: 10,
                                controller: _control_mobile,
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "Mobile Number",
                                  labelText: "Mobile Number",
                                  counterText: '',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: app_theam),
                                  ),
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                onChanged: (val) {},
                              ),
                            ),
                            InkWell(
                              child: Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                padding: EdgeInsets.only(left: 5, right: 5),
                                child: TextField(
                                  maxLength: 20,
                                  enabled: false,
                                  controller: _control_state,
                                  textAlign: TextAlign.left,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: "State",
                                    labelText: "State",
                                    counterText: '',
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: app_theam),
                                    ),
                                    suffixIcon: Icon(
                                      Icons.arrow_drop_down_sharp,
                                      color: Colors.black45,
                                    ),
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  onChanged: (val) {
                                    setState(() {});
                                  },
                                ),
                              ),
                              onTap: () {
                                setState(() {});

                                _showModal(
                                  context,
                                  "State",
                                  stateListMain,
                                  true,
                                );
                              },
                            ),
                            InkWell(
                              child: Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                padding: EdgeInsets.only(left: 5, right: 5),
                                child: TextField(
                                  maxLength: 20,
                                  enabled: false,
                                  controller: _control_dist,
                                  textAlign: TextAlign.left,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: "District",
                                    labelText: "District / Zone",
                                    counterText: '',
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: app_theam),
                                    ),
                                    suffixIcon: Icon(
                                      Icons.arrow_drop_down_sharp,
                                      color: Colors.black45,
                                    ),
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  onChanged: (val) {
                                    setState(() {});
                                  },
                                ),
                              ),
                              onTap: () {
                                _showModal(
                                  context,
                                  "Districts",
                                  disListMain,
                                  false,
                                );
                              },
                            ),
                            Container(
                              child: Align(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                      activeColor: gradint_start_color,
                                      value: this.value,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          this.value = value!;
                                        });
                                      },
                                    ), //Checkbox/Che
                                    Text("I agree all "),
                                    InkWell(
                                      child: Text(
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
                            SizedBox(height: 5),
                            GestureDetector(
                              onTap: () {
                                setState(() {});

                                if (_control_name.text.toString().length == 0) {
                                  ShowToastdur(
                                    context,
                                    "Please enter your name",
                                  );
                                } else if (_control_mobile.text
                                        .toString()
                                        .length !=
                                    10) {
                                  ShowToastdur(
                                    context,
                                    "Enter 10 digit mobile number",
                                  );
                                } else if (_control_state.text
                                        .toString()
                                        .length ==
                                    0) {
                                  ShowToastdur(context, "Please select state");
                                } else if (_control_dist.text
                                        .toString()
                                        .length ==
                                    0) {
                                  ShowToastdur(
                                    context,
                                    "Please select district",
                                  );
                                } else if (!value) {
                                  ShowToastdur(
                                    context,
                                    "Please select terms and condition.",
                                  );
                                } else {
                                  apiRegister();
                                }
                              },
                              child: Container(
                                width: 110,
                                height: 45,

                                child: submitButton("Register", true),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              _isLoading != false
                  ? fullViewLoadingUi(_isLoading)
                  : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  apiRegister() async {


    var inputs = {
      "Phone": "" + _control_mobile.text.toString(),
      "Name": "" + _control_name.text.toString(),
      "stateId": "" + state.stateId.toString(),
      "districtId": "" + dist.stateId.toString(),
    };
    _isLoading=true;
    try {
      var responces = await HttpClients(context).httpRegister(inputs);
      var responce = "" + responces.body.toString();
      var datas = json.decode(responce);
      _isLoading=false;
      if (datas['errorCode'] == 0) {
        Navigator.pop(context, "" + _control_mobile.text.toString());
      } else {
        print("my res " + responce.toString());
        ShowToastdur(context, datas['message'].toString());
      }
    } catch (e) {
      _isLoading=false;
    }
  }

  // registerResponces(tyes, msg) async {
  //   var continues = await showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return TransSuccessAlerts(type: tyes, msg: msg);
  //       }) as bool;
  //   print("res - " + continues.toString());
  //   if (continues == true) {
  //     // Navigator.pop(buildContext, "success");
  //     // selectCurrentSubDetails("0");
  //   }
  // }

  List<StateList> stateListMain = [];
  List<StateList> disListMain = [];

  late StateList state;
  late StateList dist;

  getStateList() async {
    _isLoading=true;

    var responces = await HttpClients(context).httpState();
    List<StateList> localdata = [];
    var responce = "" + responces.body.toString();
    var datas = json.decode(responce);
    _isLoading=false;
    if (datas['errorCode'] == 0) {
      var lists = datas['result'] as List;
      for (int i = 0; i < lists.length; i++) {
        localdata.add(
          StateList(
            stateName: lists[i]['stateName'].toString(),
            stateId: lists[i]['stateId'].toString(),
          ),
        );
      }
    }
    setState(() {
      stateListMain = localdata;
    });
  }

  getDistrict(String id) async {
    var responces = await HttpClients(context).httpDistrict(id);

    _isLoading=true;
    List<StateList> localdata = [];
    var responce = "" + responces.body.toString();
    var datas = json.decode(responce);
    _isLoading=false;
    if (datas['errorCode'] == 0) {
      var lists = datas['result'] as List;
      for (int i = 0; i < lists.length; i++) {
        localdata.add(
          StateList(
            stateName: lists[i]['districtName'].toString(),
            stateId: lists[i]['districtId'].toString(),
          ),
        );
      }
    }
    setState(() {
      disListMain = localdata;
    });
  }

  void _showModal(
    context,
    String title,
    List<StateList> list,
    var isState,
  ) async {
    print("print tempStateList " + list.length.toString());
    try {
      var retState =
          await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return StateListAletrs(title: title, stateList: list);
                },
              )
              as StateList;
      print("res - " + retState.toString());

      if (isState) {
        _control_state.text = retState.stateName.toString();
        state = retState;
        getDistrict(retState.stateId);
        _control_dist.text = "";
      } else {
        dist = retState;
        _control_dist.text = retState.stateName.toString();
      }
    } catch (e) {
      print("Login alerts errors - " + e.toString());
    }
  }
}

class StateList {
  String stateName;

  StateList({required this.stateName, required this.stateId});

  String stateId;
}
