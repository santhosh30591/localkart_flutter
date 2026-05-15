import 'package:flutter/material.dart';
import 'package:localkart/model/businessModel/get_business_details.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';

import 'business_location_update.dart';

class BusinessContactsUpdates extends StatefulWidget {
  Map<String, Object> register;
  GetBusinessDetailsModel getBusiness;

  BusinessContactsUpdates({
    Key? key,
    required this.getBusiness,
    required this.register,
  }) : super(key: key);

  @override
  _BusinessContactsUpdatesFormState createState() =>
      _BusinessContactsUpdatesFormState();
}

class _BusinessContactsUpdatesFormState extends State<BusinessContactsUpdates> {
  late GetBusinessDetailsModel getBusiness;

  @override
  void initState() {
    getBusiness = widget.getBusiness;
    register = widget.register;
    super.initState();

    loadingmobile();
  }

  checkingNull(String val) {
    var returnVals = "";
    if (val.isEmpty || val == null || val == "null") {
      returnVals = "";
    } else {
      returnVals = val;
    }

    return returnVals;
  }

  loadingmobile() async {
    setState(() {
      _controller_bus_cont_phone_number.text =
          "" + getBusiness.result!.contactDetails!.phoneNumber.toString();
      _controller_bus_cont_mobilr_number.text =
          "" + getBusiness.result!.contactDetails!.mobileNumber.toString();
      _controller_bus_cont_alter_number.text = checkingNull(
        "" + getBusiness.result!.contactDetails!.alternateNumber.toString(),
      );
      _controller_bus_cont_caseOnDelivary.text = checkingNull(
        "" + getBusiness.result!.contactDetails!.cod.toString(),
      );
      _controller_bus_cont_whatSapp_number.text = checkingNull(
        "" + getBusiness.result!.contactDetails!.watsappNumber.toString(),
      );
      _controller_bus_cont_email.text = checkingNull(
        "" + getBusiness.result!.contactDetails!.emailAddress.toString(),
      );
      _controller_bus_cont_vcard.text = checkingNull(
        "" + getBusiness.result!.contactDetails!.digitalVcard.toString(),
      );
      _controller_bus_cont_webSite.text = checkingNull(
        "" + getBusiness.result!.contactDetails!.website.toString(),
      );
      _controller_bus_cont_facebook.text = checkingNull(
        "" + getBusiness.result!.contactDetails!.facebook.toString(),
      );
    });
  }

  Map<String, Object> register = {"": ""};

  var _controller_bus_cont_phone_number = TextEditingController();
  var _controller_bus_cont_mobilr_number = TextEditingController();
  var _controller_bus_cont_alter_number = TextEditingController();
  var _controller_bus_cont_caseOnDelivary = TextEditingController();
  var _controller_bus_cont_whatSapp_number = TextEditingController();
  var _controller_bus_cont_email = TextEditingController();
  var _controller_bus_cont_webSite = TextEditingController();
  var _controller_bus_cont_facebook = TextEditingController();
  var _controller_bus_cont_vcard = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                    ],
                  ),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "3.Contact Details",
                        style: TextStyle(color: app_theam, fontSize: 18),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                      child: TextField(
                        controller: _controller_bus_cont_phone_number,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        decoration: InputDecoration(
                          // hintText: 'Phone Number(Fixed Line)',
                          labelText: "Phone Number(Fixed Line)",
                          hintStyle: TextStyle(
                            color: Colors
                                .grey, // Change this to your desired color
                          ),
                          labelStyle: TextStyle(color: Colors.grey),
                          counterText: '',
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                      child: TextField(
                        enabled: false,
                        controller: _controller_bus_cont_mobilr_number,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        decoration: InputDecoration(
                          // hintText: 'Phone Number(Fixed Line)',
                          labelText: "Mobile Number",
                          hintStyle: TextStyle(
                            color: Colors
                                .grey, // Change this to your desired color
                          ),
                          labelStyle: TextStyle(color: Colors.grey),
                          counterText: '',
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                      child: TextField(
                        controller: _controller_bus_cont_alter_number,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        decoration: InputDecoration(
                          // hintText: 'Phone Number(Fixed Line)',
                          labelText: "Alternate / Appointment Number",
                          hintStyle: TextStyle(
                            color: Colors
                                .grey, // Change this to your desired color
                          ),
                          labelStyle: TextStyle(color: Colors.grey),
                          counterText: '',
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                      child: TextField(
                        controller: _controller_bus_cont_caseOnDelivary,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        decoration: InputDecoration(
                          labelText: "Cash on Delivery (COD) Number",
                          hintStyle: TextStyle(
                            color: Colors
                                .grey, // Change this to your desired color
                          ),
                          labelStyle: TextStyle(color: Colors.grey),
                          counterText: '',
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                      child: TextField(
                        controller: _controller_bus_cont_whatSapp_number,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        decoration: InputDecoration(
                          labelText: "WhatsApp Number",
                          counterText: '',
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
                        controller: _controller_bus_cont_email,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Email Id",
                          hintStyle: TextStyle(
                            color: Colors
                                .grey, // Change this to your desired color
                          ),
                          labelStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  // InkWell(
                  //   child: Container(
                  //     margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  //     child: TextField(
                  //       controller: _controller_bus_cont_vcard,
                  //       keyboardType: TextInputType.text,
                  //       decoration: InputDecoration(
                  //         labelText: "Digital Vcard",
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                      child: TextField(
                        controller: _controller_bus_cont_webSite,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                            color: Colors
                                .grey, // Change this to your desired color
                          ),
                          labelStyle: TextStyle(color: Colors.grey),
                          labelText: "WebSite",
                          hintText: "www.localkart.app",
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                      child: TextField(
                        controller: _controller_bus_cont_facebook,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Facebook",
                          hintStyle: TextStyle(
                            color: Colors
                                .grey, // Change this to your desired color
                          ),
                          labelStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
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
                      ShowToastdur(
                        context,
                        "Please wait your location details is loading",
                      );
                      if (checkValidaction()) {
                        Future.delayed(Duration(milliseconds: 500), () async {
                          redirect();
                        });
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

  redirect() async {
    Map<String, Object> contact = {
      "phoneNo": "" + _controller_bus_cont_phone_number.text.toString(),
      "mobileNo": "" + _controller_bus_cont_mobilr_number.text.toString(),
      "alternateNo": "" + _controller_bus_cont_alter_number.text.toString(),
      "cod": "" + _controller_bus_cont_caseOnDelivary.text.toString(),
      "watsappNo": "" + _controller_bus_cont_whatSapp_number.text.toString(),
      "emailAddress": "" + _controller_bus_cont_email.text.toString(),
      "website": "" + _controller_bus_cont_webSite.text.toString(),
      "facebook": "" + _controller_bus_cont_facebook.text.toString(),
      // "digitalVcard": "" + _controller_bus_cont_vcard.text.toString(),
    };
    register.addAll(contact);
    print("register " + register.toString());
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LocationMapsDetailsUpdate(
          getBusiness: getBusiness,
          register: register,
        ),
      ),
    );
  }

  bool checkValidaction() {
    if (_controller_bus_cont_mobilr_number.text.toString().length < 10) {
      ShowToastdur(context, "please enter valid 10 digit mobile number");
      return false;
    }
    return true;
  }
}
