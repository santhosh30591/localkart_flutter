import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/Api/service.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/businessModel/choiceModel.dart';
import 'package:localkart/pages/autho/login_otp.dart';
import 'package:localkart/pages/autho/register.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/buttons.dart';
import 'package:localkart/unit/image_zooming.dart';
import 'package:localkart/unit/showing.dart';
import 'package:localkart/unit/showingStateListAletrs.dart';

class RegisterBusiness extends StatefulWidget {
  RegisterBusiness({Key? key}) : super(key: key);

  @override
  _RegisterBusinessFormState createState() => _RegisterBusinessFormState();
}

class _RegisterBusinessFormState extends State<RegisterBusiness> {
  var stateId = "";
  var districtId = "";
  var mobile = "";

  @override
  void initState() {
    _controller_bus_type.text = "";
    _controller_bus_name.text = "";
    _controller_bus_category.text = "";
    _controller_bus_subCate.text = "";

    loadingLocalData();
    super.initState();
  }

  loadingLocalData() async {
    _controller_state.text = "" + await DBHelper().getLoginSubDB("state_name");
    _controller_city.text =
        "" + await DBHelper().getLoginSubDB("district_name");
    stateId = "" + await DBHelper().getLoginSubDB("stateId");
    districtId = "" + await DBHelper().getLoginSubDB("districtId");
    mobile = "" + await DBHelper().getLoginSubDB("Phone");
    _controller_mobile.text = mobile;

    getStateList(stateId, districtId);

    setState(() {});
  }

  bool isCategory = true;

  List<Choice> Category = [];
  List<Choice> subCategory = [];

  late Choice categoryMain;
  late Choice subCategoryMain;

  loadingShopping(bool isShopping) async {
    _controller_bus_category.text = "";
    _controller_bus_subCate.text = "";
    List<Choice> localChose = [];

    Category = [];

    if (isShopping) {
      try {
        var responces = await HttpClients(context).httpShopping();
        localChose = [];
        var responce = "" + responces.body.toString();

        print("shopping size testing $responces");
        if (responce.length != 0) {
          var datas = json.decode(responce);
          var lists = datas['result'] as List;

          for (int i = 0; i < lists.length; i++) {
            localChose.add(
              Choice(
                id: lists[i]['Id'].toString(),
                title: lists[i]['Category'].toString(),
                icon: lists[i]['Image'].toString(),
              ),
            );
          }
          setState(() {
            Category = localChose;
            print("choicesServices size - " + Category.length.toString());
          });
        }
      } catch (e) {
        print("loading error $e");
      }
    } else {
      try {
        var responces = await HttpClients(context).httpServices();
        localChose = [];
        var responce = "" + responces.body;

        print("services size testing " + responce.length.toString());
        if (responce.length != 0) {
          var datas = json.decode(responce);
          var lists = datas['result'] as List;

          for (int i = 0; i < lists.length; i++) {
            localChose.add(
              Choice(
                id: lists[i]['Id'].toString(),
                title: lists[i]['Category'].toString(),
                icon: lists[i]['Image'].toString(),
              ),
            );
          }
          setState(() {
            Category = localChose;
            print("services size - " + Category.length.toString());
          });
        }
      } catch (e) {
        print("loading error $e");
      }
    }
  }

  var isMobileVerifyUi = true;
  var isMobileVerify = false;

  var isReferralVerifyUi = false;
  var isReferralVerify = false;

  var _controller_bus_type = TextEditingController();
  var _controller_bus_name = TextEditingController();
  var _controller_bus_category = TextEditingController();
  var _controller_bus_subCate = TextEditingController();
  var _controller_mobile = TextEditingController();
  var _controller_state = TextEditingController();
  var _controller_city = TextEditingController();
  var _controller_referal = TextEditingController();

  late BuildContext contextMain;

  final ImagePicker imgpicker = ImagePicker();
  String imagepath = "";
  late File imagefile;

  showAlertsImgPick() {
    showBottomSheetCustomeView(
      context,
      "Select",
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: new Icon(Icons.photo_outlined),
            title: new Text('Gallery'),
            onTap: () {
              setState(() {
                openFilePath(1);
              });
              // Navigator.pop(context);
            },
          ),
          ListTile(
            leading: new Icon(Icons.camera_alt),
            title: new Text('Camera'),
            onTap: () {
              setState(() {
                openFilePath(2);
              });

              // Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  openFilePath(type) async {
    try {
      var pickedFile = null;
      if (type == 1) {
        pickedFile = await imgpicker.pickImage(source: ImageSource.gallery);
      } else {
        pickedFile = await imgpicker.pickImage(source: ImageSource.camera);
      }
      if (pickedFile != null) {
        imagepath = await cropImage(pickedFile.path);
        imagefile = File(imagepath);
        setState(() {});
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }

  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    contextMain = context;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: actionBarTopBottomView(
        "Register Your Business",
        context,

        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Scaffold(
              body: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),

                      InkWell(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: TextField(
                            enabled: false,
                            controller: _controller_bus_type,
                            style: TextStyle(color: Colors.black),

                            decoration: InputDecoration(
                              hintText: 'Business Type',
                              hintStyle: TextStyle(
                                color: Colors
                                    .grey, // Change this to your desired color
                              ),
                              labelStyle: TextStyle(color: Colors.grey),

                              labelText: "Business Type",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.arrow_drop_down_sharp),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          showBottomSheetCustomeView(
                            context,
                            "Select Business Type",
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: new Icon(
                                    Icons.shopping_cart_outlined,
                                  ),
                                  title: new Text('Shopping'),
                                  onTap: () {
                                    setState(() {
                                      subCategory = [];
                                      _controller_bus_category.text = "";
                                      _controller_bus_type.text = "Shopping";
                                      loadingShopping(true);
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: new Icon(
                                    Icons.miscellaneous_services,
                                  ),
                                  title: new Text('Services'),
                                  onTap: () {
                                    setState(() {
                                      subCategory = [];
                                      _controller_bus_category.text = "";
                                      _controller_bus_type.text = "Services";

                                      loadingShopping(false);
                                    });

                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: 15,
                          right: 15,
                          bottom: 15,
                        ),
                        child: TextField(
                          controller: _controller_bus_name,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: 'Enter Business Name',
                            hintStyle: TextStyle(
                              color: Colors
                                  .grey, // Change this to your desired color
                            ),
                            labelStyle: TextStyle(color: Colors.grey),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Business Name",

                            suffixIcon: IconButton(
                              onPressed: _controller_bus_name.clear,
                              icon: Icon(Icons.clear, size: 20),
                            ),
                          ),
                        ),
                      ),

                      InkWell(
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 15,
                            right: 15,
                            bottom: 15,
                          ),
                          child: TextField(
                            enabled: false,
                            controller: _controller_bus_category,
                            style: TextStyle(color: Colors.black),

                            decoration: InputDecoration(
                              hintText: 'Sector',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: "Sector",
                              hintStyle: TextStyle(
                                color: Colors
                                    .grey, // Change this to your desired color
                              ),
                              labelStyle: TextStyle(color: Colors.grey),
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.arrow_drop_down_sharp),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          isCategory = true;
                          if (Category.length != 0) {
                            _showModal(context, "Sector", Category);
                          } else {
                            ShowToastdur(
                              context,
                              "Please select business type",
                            );
                          }
                        },
                      ),

                      InkWell(
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 15,
                            right: 15,
                            bottom: 15,
                          ),
                          child: TextField(
                            enabled: false,
                            controller: _controller_bus_subCate,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: 'Sub Sector',
                              labelText: "Sub Sector",
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
                          isCategory = false;
                          if (subCategory.length != 0) {
                            _showModal(context, "Sub Sector", subCategory);
                          } else {
                            ShowToastdur(context, "Please select Sector");
                          }
                        },
                      ),

                      Container(
                        margin: EdgeInsets.only(
                          left: 15,
                          right: 15,
                          bottom: 15,
                        ),
                        child: TextField(
                          controller: _controller_mobile,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          onChanged: (values) {
                            if (_controller_mobile.text.length >= 10) {
                              isMobileVerifyUi = true;
                            } else {
                              isMobileVerifyUi = false;
                            }
                            setState(() {});
                          },
                          readOnly: !isMobileVerify ? false : true,
                          decoration: InputDecoration(
                            counterText: '',
                            hintText: 'Mobile Number',
                            hintStyle: TextStyle(
                              color: Colors
                                  .grey, // Change this to your desired color
                            ),

                            labelStyle: TextStyle(color: Colors.grey),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Mobile",

                            suffixIcon: isMobileVerifyUi
                                ? Container(
                                    width: 120,
                                    height: 50,
                                    child: InkWell(
                                      onTap: () {
                                        if (isMobileVerify) {
                                          isMobileVerifyUi = false;
                                          isMobileVerify = false;
                                          _controller_mobile.text = "";

                                          setState(() {});
                                        } else {
                                          verifyOtp();
                                        }

                                        print("isMobileVerify $isMobileVerify");
                                      },

                                      child: submitButton(
                                        isMobileVerify ? "Change" : "Verify",
                                        !isMobileVerify,
                                      ),
                                    ),
                                  )
                                : IconButton(
                                    onPressed: _controller_mobile.clear,
                                    icon: Icon(Icons.clear, size: 20),
                                  ),
                          ),
                        ),
                      ),
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 15,
                            right: 15,
                            bottom: 15,
                          ),
                          child: TextField(
                            enabled: false,
                            controller: _controller_state,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: 'Select State',
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
                          _showStateDistrict(
                            context,
                            "State",
                            stateListMain,
                            true,
                          );
                        },
                      ),
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 15,
                            right: 15,
                            bottom: 15,
                          ),
                          child: TextField(
                            enabled: false,
                            controller: _controller_city,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: 'Select District',
                              labelText: "District",
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
                          if (_controller_state.text.length != 0) {
                            _showStateDistrict(
                              context,
                              "District",
                              disListMain,
                              false,
                            );
                          } else {
                            ShowToastdur(context, "Please select state");
                          }
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: 15,
                          right: 15,
                          bottom: 15,
                        ),
                        child: TextField(
                          readOnly: isReferralVerify ? true : false,
                          controller: _controller_referal,
                          textCapitalization: TextCapitalization.characters,
                          keyboardType: TextInputType.text,
                          maxLength: 10,

                          onChanged: (values) {
                            if (_controller_referal.text.length >= 4) {
                              isReferralVerifyUi = true;
                            } else {
                              isReferralVerifyUi = false;
                            }
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            counterText: '',
                            hintText: 'Referral Code',
                            hintStyle: TextStyle(
                              color: Colors
                                  .grey, // Change this to your desired color
                            ),
                            labelStyle: TextStyle(color: Colors.grey),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "Referral",
                            suffixIcon: isReferralVerifyUi
                                ? Container(
                                    width: 120,
                                    height: 50,
                                    child: InkWell(
                                      onTap: () {
                                        if (isReferralVerify) {
                                          isReferralVerifyUi = false;
                                          isReferralVerify = false;
                                          _controller_referal.text = "";
                                        } else {
                                          verifyReferralCode();
                                        }
                                        setState(() {});
                                        print(
                                          "isReferralVerify $isReferralVerify",
                                        );
                                      },

                                      child: submitButton(
                                        isReferralVerify
                                            ? "Change"
                                            : "Referral",
                                        !isReferralVerify,
                                      ),
                                    ),
                                  )
                                : IconButton(
                                    onPressed: _controller_referal.clear,
                                    icon: Icon(Icons.clear, size: 20),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              bottomNavigationBar: InkWell(
                onTap: () {
                  if (_controller_bus_type.text.toString() == "") {
                    ShowToastdur(context, "Please select business type");
                    return;
                  } else if (_controller_bus_name.text.toString() == "") {
                    ShowToastdur(context, "Please enter business name");
                    return;
                  } else if (_controller_bus_category.text.toString() == "") {
                    ShowToastdur(context, "Please select sector");
                    return;
                  } else if (_controller_bus_subCate.text.toString() == "") {
                    ShowToastdur(context, "Please select sub sector");
                    return;
                  } else if (_controller_mobile.text.toString() == "") {
                    ShowToastdur(context, "Please enter mobile number");
                    return;
                  } else if (_controller_state.text.toString() == "") {
                    ShowToastdur(context, "Please select state");
                  } else if (_controller_city.text.toString() == "") {
                    ShowToastdur(context, "Please select district");
                  } else {
                    if (isMobileVerify) {
                      registerBusiness();
                    } else {
                      ShowToastdur(context, "Please verify your mobile number");
                    }
                  }
                },
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(gradient: app_gradient),
                  child: Text(
                    "Register",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            _isLoading ? fullViewLoadingUi(_isLoading) : Container(),
          ],
        ),
      ),
    );
  }

  void _showStateDistrict(
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
      print("res - " + retState.toString());

      if (retState != null) {
        if (isState) {
          _controller_state.text = retState.stateName.toString();
          getDistrict(retState.stateId, "0");
          _controller_city.text = "";
          stateId = retState.stateId;
          setState(() {});
        } else {
          setState(() {});
          districtId = retState.stateId;
          _controller_city.text = retState.stateName.toString();
        }
      }
    } catch (e) {
      print("Login alerts errors - " + e.toString());
    }
  }

  void _showModal(context, String title, List<Choice> list) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      context: context,
      builder: (context) {
        //3
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return DraggableScrollableSheet(
              expand: false,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 20, bottom: 5),
                          margin: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Select $title",
                                  style: TextStyle(
                                    color: app_theam,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                child: Icon(Icons.clear),
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            //5
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return _showBottomSheetWithSearch(index, list);
                            },
                          ),
                        ),
                      ],
                    );
                  },
            );
          },
        );
      },
    );
  }

  Widget _showBottomSheetWithSearch(int index, List<Choice> listOfCities) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10),
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Color(0xFFf4a4c8)),
              ),
              child: Container(
                padding: EdgeInsets.all(3),
                width: 30,
                height: 30,
                child: Image.network(
                  listOfCities[index].icon,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          listOfCities[index].title,
                          maxLines: 2,
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // child: Container(
      //     margin: EdgeInsets.all(15),
      //     child: new Text(listOfCities[index].title)),
      onTap: () {
        setState(() {
          if (isCategory) {
            subCategory = [];
            _controller_bus_category.text = listOfCities[index].title
                .toString();
            setState(() {
              getServicesDetails(listOfCities[index].id.toString());
            });
            categoryMain = new Choice(
              id: listOfCities[index].id.toString(),
              title: listOfCities[index].title,
              icon: listOfCities[index].icon,
            );
          } else {
            _controller_bus_subCate.text = listOfCities[index].title.toString();
            subCategoryMain = new Choice(
              id: listOfCities[index].id.toString(),
              title: listOfCities[index].title,
              icon: listOfCities[index].icon,
            );

            setState(() {});
          }
        });
        Navigator.of(context).pop();
      },
    );
  }

  getServicesDetails(String id) async {
    _controller_bus_subCate.text = "";
    _isLoading = true;
    var url = "";
    if (_controller_bus_type.text.toString() == "Shopping") {
      url = "shopsubcat";
    } else {
      url = "servicesubcat";
    }
    var responces = await HttpClients(context).httpSubServices(id, url);
    List<Choice> localdata = [];
    var responce = "" + responces.body.toString();
    var datas = json.decode(responce);
    _isLoading = false;
    if (datas['errorCode'] == 0) {
      var lists = datas['result'] as List;
      for (int i = 0; i < lists.length; i++) {
        localdata.add(
          new Choice(
            id: lists[i]['Id'].toString(),
            title: lists[i]['subCategoryName'].toString(),
            icon: lists[i]['Image'].toString(),
          ),
        );
      }
    }
    setState(() {
      subCategory = localdata;
    });
  }

  List<StateList> disListMain = [];
  List<StateList> stateListMain = [];

  getStateList(stateId, districtId) async {
    _isLoading = true;
    try {
      var responces = await HttpClients(context).httpState();
      var responce = "" + responces.body.toString();
      _isLoading = false;
      var datas = json.decode(responce);
      print("my res " + datas.toString());
      List<StateList> localdata = [];
      if (datas['errorCode'] == 0) {
        var lists = datas['result'] as List;
        for (int i = 0; i < lists.length; i++) {
          if (lists[i]['stateId'].toString() == stateId) {
            _controller_state.text = lists[i]['stateName'].toString();
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
    } catch (e) {
      _isLoading = false;
    }
    setState(() {});
  }

  getDistrict(String stateId, districtId) async {
    try {
      _isLoading = true;
      var responces = await HttpClients(context).httpDistrict(stateId);
      _isLoading = false;
      var responce = "" + responces.body.toString();
      var datas = json.decode(responce);
      List<StateList> localdata = [];
      if (datas['errorCode'] == 0) {
        var lists = datas['result'] as List;

        for (int i = 0; i < lists.length; i++) {
          if (lists[i]['districtId'].toString() == districtId) {
            _controller_city.text = lists[i]['districtName'].toString();
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

  verifyOtp() async {
    try {
      _isLoading = true;
      var responces = await HttpClients(
        context,
      ).httpSendOtp(_controller_mobile.text.toString());
      var responce = "" + responces.body.toString();
      var datas = json.decode(responce);
      _isLoading = false;
      if (datas['errorCode'] == 0) {
        showAlerts(datas['otp'].toString());
      } else {
        ShowToastdur(context, datas['message'].toString());
      }

      setState(() {});
    } catch (e) {
      setState(() {});
    }
  }

  verifyReferralCode() async {
    try {
      _isLoading = true;
      var responces = await HttpClients(
        context,
      ).httpReferralCode(_controller_referal.text.toString());
      var responce = "" + responces.body.toString();
      _isLoading = false;
      var datas = json.decode(responce);
      if (datas['errorCode'] == 0) {
        isReferralVerify = true;
      } else {
        ShowToastdur(context, datas['message'].toString());
      }
    } catch (e) {}
    setState(() {});
  }

  registerBusiness() async {
    try {
      var referral_code = "";
      if (isMobileVerify) {
        referral_code = _controller_referal.text.toString();
      }

      Map<String, Object> inputs = {
        "userIndexId": "" + await DBHelper().getUserId(),
        "type": "" + _controller_bus_type.text.toString(),
        "name": "" + _controller_bus_name.text.toString(),
        "catId": "" + categoryMain.id,
        "subCatId": "" + subCategoryMain.id,
        "mobileNo": "" + _controller_mobile.text.toString(),
        "stateId": stateId,
        "districtId": districtId,
        "state": _controller_state.text.toString(),
        "district": _controller_city.text.toString(),
        "busRefCode": referral_code,
      };
      _isLoading = true;
      var responces = await ApiClientLocalKart().httpPost(
        inputs,
        urlBusiness_create,
      );
      setState(() {});

      _isLoading = false;

      var responce = "" + await responces.body.toString();
      var datas = json.decode(responce);
      if (datas['errorCode'] == 0) {
        var loginProfile = await DBHelper().getLoginAllDB();
        print("db  profile is " + loginProfile.toString());
        dynamic local = json.decode(loginProfile);
        local['flag'] = 1;
        local['type'] = _controller_bus_type.text.toString();

        local['shopId'] = datas['indexId'];

        var encode = await json.encode(local);
        await DBHelper().saveLoginDB(encode.toString());

        businessAlerts(context, datas['message'], () {
          Navigator.pop(context); // 1. Close dialog
          Navigator.pop(context); // 2. Go back to previous page
        });
      } else {
        // showCommonToast(context, "", datas['message'].toString());
        var result = await businessAlerts(context, datas['message'], () {
          Navigator.pop(context, true);
        });

        print("result $result");

        if (result == true) {
          Navigator.pop(context);
        }
      }

      setState(() {});
    } catch (e) {
      setState(() {});
    }
  }

  showAlerts(otp) async {
    try {
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
          isMobileVerify = true;
          setState(() {});
        }
      }
    } catch (e) {
      print("My res alerts error - $e");
    }
  }
}
