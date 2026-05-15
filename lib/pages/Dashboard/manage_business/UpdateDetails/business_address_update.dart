import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localkart/Api/service.dart';
import 'package:localkart/model/businessModel/get_business_details.dart';
import 'package:localkart/pages/autho/register.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';
import 'package:localkart/unit/showingStateListAletrs.dart';

import 'business_contact_update.dart';

class BusinessAddressUpdate extends StatefulWidget {
  Map<String, Object> register;
  GetBusinessDetailsModel getBusiness;

  BusinessAddressUpdate({
    Key? key,
    required this.getBusiness,
    required this.register,
  }) : super(key: key);

  @override
  _BusinessAddressUpdateFormState createState() =>
      _BusinessAddressUpdateFormState();
}

class _BusinessAddressUpdateFormState extends State<BusinessAddressUpdate> {
  late Map<String, Object> register = {"": ""};

  var stateIds = "";
  var cityIds = "";

  late GetBusinessDetailsModel getBusiness;

  @override
  void initState() {
    getBusiness = widget.getBusiness;
    register = widget.register;
    super.initState();

    _controller_bus_reg_door_no.text =
        "" + getBusiness.result!.addressDetails!.doorNo.toString();
    _controller_bus_reg_locality.text =
        "" + getBusiness.result!.addressDetails!.locality.toString();
    _controller_bus_reg_area.text =
        "" + getBusiness.result!.addressDetails!.area.toString();
    _controller_bus_reg_landmark.text =
        "" + getBusiness.result!.addressDetails!.landMark.toString();
    _controller_bus_reg_pincode.text =
        "" + getBusiness.result!.addressDetails!.pincode!
          ..toString();

    localDatas();
  }

  localDatas() async {
    var stateId = "" + getBusiness.result!.addressDetails!.stateId.toString();
    var districtI =
        "" + getBusiness.result!.addressDetails!.districtId.toString();

    getStateList(stateId, districtI);
    stateIds = stateId;
    cityIds = districtI;
  }

  var _controller_bus_reg_door_no = TextEditingController();
  var _controller_bus_reg_locality = TextEditingController();
  var _controller_bus_reg_area = TextEditingController();
  var _controller_bus_reg_landmark = TextEditingController();
  var _controller_bus_reg_state = TextEditingController();
  var _controller_bus_reg_district = TextEditingController();
  var _controller_bus_reg_pincode = TextEditingController();

  late BuildContext contextMain;

  List<StateList> stateListMain = [];
  List<StateList> disListMain = [];

  getStateList(stateId, districtId) async {
    try {
      var responces = await HttpClients(context).httpState();
      var responce = "" + responces.body.toString();

      print(
        "my res stateId " +
            stateId.toString() +
            " and districtId " +
            districtId.toString(),
      );

      var datas = json.decode(responce);
      print("my res " + datas.toString());
      List<StateList> localdata = [];
      if (datas['errorCode'] == 0) {
        var lists = datas['result'] as List;
        for (int i = 0; i < lists.length; i++) {
          if (lists[i]['stateId'].toString() == stateId) {
            _controller_bus_reg_state.text = lists[i]['stateName'].toString();
            print("my res name " + lists[i]['stateName'].toString());
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

  getDistrict(String id, String districtId) async {
    disListMain = [];
    var responces = await HttpClients(context).httpDistrict(id);

    List<StateList> localdata = [];
    var responce = "" + responces.body.toString();
    var datas = json.decode(responce);

    if (datas['errorCode'] == 0) {
      var lists = datas['result'] as List;
      for (int i = 0; i < lists.length; i++) {
        localdata.add(
          StateList(
            stateName: lists[i]['districtName'].toString(),
            stateId: lists[i]['districtId'].toString(),
          ),
        );

        if (districtId == lists[i]['districtId'].toString()) {
          _controller_bus_reg_district.text = lists[i]['districtName']
              .toString();
        }
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

      if (retState != null) {
        if (isState) {
          _controller_bus_reg_state.text = retState.stateName.toString();
          getDistrict(retState.stateId, "0");
          _controller_bus_reg_district.text = "";
          stateIds = retState.stateId;
          setState(() {});
        } else {
          setState(() {});
          cityIds = retState.stateId;
          _controller_bus_reg_district.text = retState.stateName.toString();
        }
      }
    } catch (e) {
      print("Login alerts errors - " + e.toString());
    }
  }

  bool checkValidact() {
    if (_controller_bus_reg_door_no.text == "") {
      ShowToastdur(context, "Please enter your Door No");
      return false;
    } else if (_controller_bus_reg_locality.text == "") {
      ShowToastdur(context, "Please enter your Locality");
      return false;
    } else if (_controller_bus_reg_area.text == "") {
      ShowToastdur(context, "Please enter your Area");
      return false;
    } else if (_controller_bus_reg_landmark.text == "") {
      ShowToastdur(context, "Please enter your Landmark");
      return false;
    } else if (_controller_bus_reg_state.text == "") {
      ShowToastdur(context, "Please select your State");
      return false;
    } else if (_controller_bus_reg_district.text == "") {
      ShowToastdur(context, "Please select your District");
      return false;
    } else if (_controller_bus_reg_pincode.text.toString().length <= 5) {
      ShowToastdur(context, "Please enter valid Pin Code");
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    contextMain = context;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: actionBarTopBottomView(
        "My Business",
        context,
        Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: bussiness_select_tab_height,
                          color: bussiness_select_tab_colors,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: bussiness_select_tab_height,
                          color: bussiness_select_tab_colors,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: bussiness_select_tab_height,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: bussiness_select_tab_height,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: bussiness_select_tab_height,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: bussiness_select_tab_height,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "2.Address Details",
                        style: TextStyle(color: app_theam, fontSize: 18),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: TextField(
                        controller: _controller_bus_reg_door_no,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.next,

                        decoration: InputDecoration(
                          hintText: 'Door No. / Flat No. / Building No.',
                          labelText: "Door No. / Flat No. / Building No.",
                          hintStyle: TextStyle(
                            color: Colors
                                .grey, // Change this to your desired color
                          ),
                          labelStyle: TextStyle(color: Colors.grey),

                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    child: TextField(
                      controller: _controller_bus_reg_locality,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,

                      decoration: InputDecoration(
                        hintText: 'Enter Locality',
                        labelText: "Locality",
                        floatingLabelBehavior:
                        FloatingLabelBehavior.always,
                        hintStyle: TextStyle(
                          color: Colors
                              .grey, // Change this to your desired color
                        ),
                        labelStyle: TextStyle(color: Colors.grey),
                        // suffixIcon: IconButton(
                        //   onPressed: () {},
                        //   // onPressed: _controllerUserName.clear,
                        //   icon: Icon(Icons.arrow_drop_down_sharp),
                        // ),
                      ),

                    ),
                  ),
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                      child: TextField(
                        controller: _controller_bus_reg_area,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'Area',
                          labelText: "Area",
                          floatingLabelBehavior:
                          FloatingLabelBehavior.always,
                          hintStyle: TextStyle(
                            color: Colors
                                .grey, // Change this to your desired color
                          ),
                          labelStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                      child: TextField(
                        controller: _controller_bus_reg_landmark,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'Landmark',
                          labelText: "Landmark",
                          floatingLabelBehavior:
                          FloatingLabelBehavior.always,
                          hintStyle: TextStyle(
                            color: Colors
                                .grey, // Change this to your desired color
                          ),
                          labelStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                      child: TextField(
                        enabled: false,
                        style: TextStyle(color: Colors.black),
                        controller: _controller_bus_reg_state,
                        decoration: InputDecoration(
                          hintText: 'State',
                          labelText: "State",
                          floatingLabelBehavior:
                          FloatingLabelBehavior.always,
                          hintStyle: TextStyle(
                            color: Colors
                                .grey, // Change this to your desired color
                          ),
                          labelStyle: TextStyle(color: Colors.grey),
                          suffixIcon: IconButton(
                            onPressed: () {},
                            // onPressed: _controllerUserName.clear,
                            icon: Icon(Icons.arrow_drop_down_sharp),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      // getSubCategory();

                      _showModal(context, "State", stateListMain, true);
                    },
                  ),
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                      child: TextField(
                        enabled: false,
                        controller: _controller_bus_reg_district,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'District',
                          labelText: 'District',
                          floatingLabelBehavior:
                          FloatingLabelBehavior.always,
                          hintStyle: TextStyle(
                            color: Colors
                                .grey, // Change this to your desired color
                          ),
                          labelStyle: TextStyle(color: Colors.grey),
                          suffixIcon: IconButton(
                            onPressed: () {},
                            // onPressed: _controllerUserName.clear,
                            icon: Icon(Icons.arrow_drop_down_sharp),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      _showModal(context, "District", disListMain, false);
                    },
                  ),
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        controller: _controller_bus_reg_pincode,
                        decoration: InputDecoration(
                          hintText: 'PIN Code',
                          labelText: "PIN Code",
                          floatingLabelBehavior:
                          FloatingLabelBehavior.always,
                          hintStyle: TextStyle(
                            color: Colors
                                .grey, // Change this to your desired color
                          ),
                          labelStyle: TextStyle(color: Colors.grey),
                          counterText: "",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
            // child: Text("Santhosh Kumar "),
          ),
          bottomNavigationBar: Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.only(right: 1),
                      decoration: BoxDecoration(gradient: gradient_btn_lift),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Previous",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());

                      late Map<String, Object> address;

                      print("register " + register.toString());

                      if (checkValidact()) {
                        address = {
                          "doorNo":
                              "" + _controller_bus_reg_door_no.text.toString(),
                          "locality":
                              "" + _controller_bus_reg_locality.text.toString(),
                          "area": "" + _controller_bus_reg_area.text.toString(),
                          "landMark":
                              "" + _controller_bus_reg_landmark.text.toString(),
                          "state": "" + stateIds.toString(),
                          "district":
                              "" +
                              _controller_bus_reg_district.text
                                  .toString()
                                  .toString(),
                          "district": "" + cityIds.toString(),
                          "pincode":
                              "" + _controller_bus_reg_pincode.text.toString(),
                        };
                        register.addAll(address);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BusinessContactsUpdates(
                              getBusiness: getBusiness,
                              register: register,
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      height: 50,

                      decoration: BoxDecoration(gradient: gradient_btn_rigth),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Next",
                            style: TextStyle(color: Colors.white, fontSize: 15),
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
      ),
    );
  }
}
