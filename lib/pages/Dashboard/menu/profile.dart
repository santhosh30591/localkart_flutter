import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localkart/Api/service.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/pages/autho/register.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/buttons.dart';
import 'package:localkart/unit/image_zooming.dart';
import 'package:localkart/unit/showing.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<Profile> {
  String imagepath = "";
  String urlImages = "";
  String userIndexId = "";
  late File imagefile;

  bool _isLoading = false;

  String stateId = "";
  String districtId = "";

  getUserProfile() async {
    userIndexId = await DBHelper().getLoginSubDB("Id");

    setState(() {
      _isLoading = true;
    });

    var responces = await HttpClients(
      context,
    ).httpUserProfile("" + userIndexId.toString());
    try {
      var responce = "" + responces.body.toString();
      setState(() {
        _isLoading = false;
      });

      try {
        var datas = json.decode(responce);

        var name = datas['result']['customerName'].toString();

        var mobileNumber = datas['result']['mobileNumber'].toString();
        var country = datas['result']['country'].toString();
        var Language = datas['result']['Language'].toString();
        var userId = datas['result']['userId'].toString();
        var userType = datas['result']['userType'].toString();
        urlImages = datas['result']['profileImage'].toString();

        userId = userId.split('/')[0].toString();
        userType = userType.split('/')[0].toString();
        // urlImages =
        //     "https://www.siliconindia.com/images/simag_images/uploaded_images/company_logos/pq026.pushpa.jpg";
        String emailAddress = "";
        try {
          emailAddress = datas['result']['emailAddress'].toString();

          if (emailAddress == "null") {
            emailAddress = "";
          }
        } catch (e) {}

        _controllerUserName.text = name;
        _controllerEmail.text = emailAddress;
        _controllerMobile.text = mobileNumber;
        _controllerCountry.text = country;
        _controllerLanguage.text = Language;
        _controllerUserType.text = userType;
        _controllerUserId.text = userId;
        setState(() {});
        stateId = datas['result']['state'].toString();
        districtId = datas['result']['district'].toString();
        //
        getStateList(stateId, districtId);
      } catch (e) {
        print("data set  loading errors -" + e.toString());
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("encode err - " + e.toString());
    }
  }

  late StateList state;
  late StateList dist;

  getStateList(stateId, districtId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      var responces = await HttpClients(context).httpState();

      setState(() {
        _isLoading = false;
      });

      var responce = "" + responces.body.toString();
      var datas = json.decode(responce);
      print("my res " + datas.toString());
      if (datas['errorCode'] == 0) {
        var lists = datas['result'] as List;
        for (int i = 0; i < lists.length; i++) {
          if (lists[i]['stateId'].toString() == stateId) {
            _controllerState.text = lists[i]['stateName'].toString();
            getDistrict(stateId, districtId);
          }
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  getDistrict(String stateId, districtId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      var responces = await HttpClients(context).httpDistrict(stateId);
      setState(() {
        _isLoading = false;
      });

      var responce = "" + responces.body.toString();
      var datas = json.decode(responce);

      if (datas['errorCode'] == 0) {
        var lists = datas['result'] as List;
        for (int i = 0; i < lists.length; i++) {
          if (lists[i]['districtId'].toString() == districtId) {
            _controllerCity.text = lists[i]['districtName'].toString();
          }
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  updateProfileDetails() async {
    try {
      var name = "" + _controllerUserName.text.toString();
      var mail = "" + _controllerEmail.text.toString();
      bool emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
      ).hasMatch(mail);

      print("mail = " + mail + " emailValid " + emailValid.toString());

      if (name.length == 0) {
        ShowToastdur(context, "Please enter your name");
      } else if (emailValid == false) {
        ShowToastdur(context, "Please enter valid Mail Id");
      } else {
        var base64string = "";

        try {
          if (imagepath != "") {
            Uint8List imagebytes = await imagefile
                .readAsBytes(); //convert to bytes
            base64string = base64.encode(imagebytes); //con
          } else {}
        } catch (e) {}

        Map<String, Object> inputs = {
          "userIndexId": "" + userIndexId,
          "name": name,
          "stateId": stateId,
          "districtId": districtId,
          "emailAddress": mail,
          "profileImage": base64string,
        };

        setState(() {
          _isLoading = true;
        });

        var responces = await HttpClients(
          context,
        ).httpUserProfileUpdate(inputs);

        try {
          setState(() {
            _isLoading = false;
          });

          var datas = json.decode(responces.body.toString());
          if (datas['errorCode'].toString() == "0") {
            var images = "";
            try {
              images = datas!['result']!['profileImage'].toString();
              // print("get image url - " + images);
            } catch (e) {
              print("error is - " + e.toString());
            }

            updateLocalData(images);
          }
          ShowToastdur(context, datas['message'].toString());
        } catch (e) {
          setState(() {
            _isLoading = false;
          });
          print(" loading rtt " + e.toString());
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  updateLocalData(var images) async {
    var loginProfile = await DBHelper().getLoginAllDB();
    print("db  profile is " + loginProfile.toString());
    dynamic local = json.decode(loginProfile);
    local['result']['Name'] = "" + _controllerUserName.text.toString();
    local['result']['Email'] = "" + _controllerEmail.text.toString();
    local['result']['profileImage'] = "" + images;

    var encode = await json.encode(local);
    print("local  profile is " + encode.toString());

    await DBHelper().saveLoginDB(encode.toString());

    // var loginProfile1 = await DBHelper().getLoginAllDB();
    //
    // print("loginProfile1  profile is " + loginProfile1.toString());

    // var datas1 = await json.decode(loginProfile);
    // print("update profile is " + datas1.toString());
  }

  showAlertsImgPick() {
    showBottomSheetCustomeView(
      context,
      "Select Image Source",
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

  final ImagePicker imgpicker = ImagePicker();

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
        Navigator.pop(context);
        setState(() {});
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }

  @override
  void initState() {
    getUserProfile();
    super.initState();
  }

  var _controllerUserName = TextEditingController();
  var _controllerMobile = TextEditingController();
  var _controllerEmail = TextEditingController();
  var _controllerCountry = TextEditingController();
  var _controllerLanguage = TextEditingController();
  var _controllerCity = TextEditingController();
  var _controllerState = TextEditingController();
  var _controllerUserType = TextEditingController();
  var _controllerUserId = TextEditingController();

  var window_width = 0.0;
  var isWindows = false;

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    setState(() {
      window_width = queryData.size.width;

      isWindows = false;
    });

    return actionBarTopBottomView(
      "MyProfile",
      context,
      Scaffold(
        backgroundColor: Colors.transparent,

        body: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              color: Color(0xFFF5F5F5),
              padding: isWindows == false
                  ? EdgeInsets.zero
                  : EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Center(
                  child: Container(
                    padding: isWindows == false
                        ? EdgeInsets.zero
                        : EdgeInsets.all(10.0),
                    // color: Colors.white,
                    width: window_width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 15),
                        Container(
                          child: imagepath != ""
                              ? InkWell(
                                  child: ClipOval(
                                    child: Image.file(
                                      imagefile,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                    // ),
                                  ),
                                  onTap: () {
                                    showAlertsImgPick();
                                  },
                                )
                              : InkWell(
                                  child: urlImages == ""
                                      ? Icon(
                                          Icons.account_circle,
                                          size: 100,
                                          color: Colors.grey,
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(100.0),
                                            ),
                                            border: Border.all(
                                              color: app_theam,
                                              width: 1.0,
                                            ),
                                          ),
                                          child: ClipOval(
                                            child: Image.network(
                                              urlImages,
                                              width: 110,
                                              height: 110,
                                              fit: BoxFit.cover,
                                            ),
                                            // ),
                                          ),
                                        ),
                                  onTap: () {
                                    showAlertsImgPick();
                                  },
                                ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          margin: EdgeInsets.all(15),
                          child: TextField(
                            controller: _controllerUserName,
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Enter your name',
                              labelText: "Name",
                              suffixIcon: IconButton(
                                onPressed: _controllerUserName.clear,
                                icon: Icon(Icons.clear),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 15,
                            right: 15,
                            bottom: 15,
                          ),
                          child: TextField(
                            enabled: false,
                            controller: _controllerMobile,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Enter Mobile Number',
                              labelText: "Mobile",
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.clear),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 15,
                            right: 15,
                            bottom: 15,
                          ),
                          child: TextField(
                            controller: _controllerEmail,
                            decoration: InputDecoration(
                              hintText: 'Enter email Id',
                              labelText: "Email Id",
                              suffixIcon: IconButton(
                                onPressed: _controllerEmail.clear,
                                icon: Icon(Icons.clear),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 15,
                            right: 15,
                            bottom: 15,
                          ),
                          child: TextField(
                            enabled: false,
                            controller: _controllerState,
                            decoration: InputDecoration(
                              hintText: 'Tamil Nadu',
                              labelText: "State",
                              suffixIcon: IconButton(
                                onPressed: () {},
                                // onPressed: _controllerUserName.clear,
                                icon: Icon(Icons.arrow_drop_down_sharp),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 15,
                            right: 15,
                            bottom: 15,
                          ),
                          child: TextField(
                            enabled: false,
                            controller: _controllerCity,
                            decoration: InputDecoration(
                              hintText: 'District / Zone',
                              labelText: "City",
                              suffixIcon: IconButton(
                                onPressed: () {},
                                // onPressed: _controllerUserName.clear,
                                icon: Icon(Icons.arrow_drop_down_sharp),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 15,
                            right: 15,
                            bottom: 15,
                          ),
                          child: TextField(
                            enabled: false,
                            controller: _controllerCountry,
                            decoration: InputDecoration(
                              hintText: 'Country',
                              labelText: "Country",
                              suffixIcon: IconButton(
                                onPressed: () {},
                                // onPressed: _controllerUserName.clear,
                                icon: Icon(Icons.arrow_drop_down_sharp),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 15,
                            right: 15,
                            bottom: 15,
                          ),
                          child: TextField(
                            enabled: false,
                            controller: _controllerLanguage,
                            decoration: InputDecoration(
                              hintText: 'Language',
                              labelText: "Language",
                              suffixIcon: IconButton(
                                onPressed: () {},
                                // onPressed: _controllerUserName.clear,
                                icon: Icon(Icons.arrow_drop_down_sharp),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 15,
                            right: 15,
                            bottom: 15,
                          ),
                          child: TextField(
                            enabled: false,
                            controller: _controllerUserType,
                            decoration: InputDecoration(
                              labelText: "User Type",
                              suffixIcon: IconButton(
                                onPressed: () {},
                                // onPressed: _controllerUserName.clear,
                                icon: Icon(Icons.arrow_drop_down_sharp),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 15,
                            right: 15,
                            bottom: 15,
                          ),
                          child: TextField(
                            enabled: false,
                            controller: _controllerUserId,
                            decoration: InputDecoration(labelText: "User Id"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _isLoading != false
                ? Container(child: fullViewLoadingUi(_isLoading))
                : Container(),
          ],
        ),
        bottomNavigationBar: Container(
          child: InkWell(
            onTap: () {
              updateProfileDetails();
              // Navigator.pop(context);
              //
              // Navigator.pop(context);
              // ShowToastdur(context, "Profile Details Updated.");
            },
            child: submitButton("Update", true),
          ),
        ),
      ),
    );
  }
}
