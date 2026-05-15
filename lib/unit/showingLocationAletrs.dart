import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localkart/Api/service.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/pages/autho/register.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/showing.dart';
import 'package:localkart/unit/showingStateListAletrs.dart';

class showLocationAlerts extends StatefulWidget {
  String state;
  String city;

  showLocationAlerts({Key? key, required this.state, required this.city})
    : super(key: key);

  @override
  _showLocationAlerts createState() => _showLocationAlerts();
}

class _showLocationAlerts extends State<showLocationAlerts> {
  List<StateList> stateListMain = [];
  List<StateList> disListMain = [];

  TextEditingController _textState = TextEditingController();
  TextEditingController _textCity = TextEditingController();
  String stateIds = "";
  String cityIds = "";

  @override
  void initState() {
    stateIds = widget.state;
    cityIds = widget.city;
    getStateList(stateIds, cityIds);
    super.initState();
  }

  getStateList(stateId, districtId) async {
    try {
      var responces = await HttpClients(context).httpState();
      var responce = "" + responces.body.toString();
      var datas = json.decode(responce);
      print("my res " + datas.toString());
      List<StateList> localdata = [];
      if (datas['errorCode'] == 0) {
        var lists = datas['result'] as List;
        for (int i = 0; i < lists.length; i++) {
          if (lists[i]['stateId'].toString() == stateId) {
            _textState.text = lists[i]['stateName'].toString();
            getDistrict(lists[i]['stateId'], districtId);
          }

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
    } catch (e) {}
  }

  getDistrict(String stateId, districtId) async {
    try {
      var responces = await HttpClients(context).httpDistrict(stateId);

      var responce = "" + responces.body.toString();
      var datas = json.decode(responce);
      List<StateList> localdata = [];
      if (datas['errorCode'] == 0) {
        var lists = datas['result'] as List;

        for (int i = 0; i < lists.length; i++) {
          if (lists[i]['districtId'].toString() == districtId) {
            _textCity.text = lists[i]['districtName'].toString();
          }
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
    } catch (e) {
      setState(() {});
    }
  }

  void _showModal(
    context,
    String title,
    List<StateList> list,
    var isState,
  ) async {
    try {
      var retState =
          await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return StateListAletrs(title: "State", stateList: list);
                },
              )
              as StateList;

      if (await retState != null) {
        if (isState) {
          _textState.text = retState.stateName.toString();
          getDistrict(retState.stateId, "0");
          _textCity.text = "";
          stateIds = retState.stateId;
          setState(() {});
        } else {
          setState(() {});
          cityIds = retState.stateId;
          _textCity.text = retState.stateName.toString();
        }
      }
    } catch (e) {
      print("Login alerts errors - " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 270,

            width: double.infinity,
            // margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.white,
            ),
            padding: const EdgeInsets.only(left: 15, top: 10, right: 15),

            child: Column(
              children: [
                const TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: "Select",
                    labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                    border: InputBorder.none,
                  ),
                ),
                InkWell(
                  onTap: () {
                    _showModal(context, "State", stateListMain, true);
                  },
                  child: TextField(
                    controller: _textState,
                    enabled: false,
                    style: TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      suffixIcon: Icon(
                        Icons.arrow_drop_down_sharp,
                        color: Colors.grey,
                      ),
                      hintText: "Select State Name",
                      labelText: "State",
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _showModal(context, "Districts", disListMain, false);
                  },
                  child: TextField(
                    enabled: false,
                    controller: _textCity,
                    style: TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      suffixIcon: Icon(
                        Icons.arrow_drop_down_sharp,
                        color: Colors.grey,
                      ),
                      hintText: "Select District Name",
                      labelText: "Districts",
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  alignment: FractionalOffset.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Map<String, Object> inputs = {
                            "stateId": "0",
                            "distId": "0",
                          };
                          Navigator.pop(context, inputs);
                        },
                        child: Container(
                          width: 90,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: gradient_btn_lift,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(5, 5),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (_textState.text.toString().length == 0) {
                            ShowToast(context, "Please select state name");
                          } else if (_textCity.text.toString().length == 0) {
                            ShowToast(context, "Please select districts name");
                          } else {
                            Map<String, Object> inputs = {
                              "stateId": stateIds,
                              "distId": cityIds,
                            };

                            var loginProfile = await DBHelper().getLoginAllDB();
                            print("db  profile is " + loginProfile.toString());
                            dynamic local = json.decode(loginProfile);
                            local['result']['stateId'] = stateIds.toString();
                            local['result']['districtId'] =
                                "" + cityIds.toString();
                            local['result']['district_name'] =
                                "" + _textCity.text.toString();
                            local['result']['state_name'] =
                                "" + _textState.text.toString();

                            var encode = await json.encode(local);
                            print(
                              "location details is updated " +
                                  encode.toString(),
                            );

                            await DBHelper().saveLoginDB(encode.toString());
                            var name = await DBHelper().getLoginSubDB(
                              "district_name",
                            );

                            print("the inputes " + inputs.toString());
                            print("the name " + name.toString());
                            Navigator.pop(context, inputs);
                          }
                        },
                        child: Container(
                          width: 90,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: gradient_btn_rigth,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(5, 5),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'Ok',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
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
