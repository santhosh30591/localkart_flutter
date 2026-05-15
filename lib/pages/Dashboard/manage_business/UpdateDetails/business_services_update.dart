import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/Api/service.dart';
import 'package:localkart/RoutingSetup/router-constants.dart';
import 'package:localkart/model/businessModel/get_business_details.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/showing.dart';
import 'package:localkart/unit/showingAddServicesAletrs.dart';
import 'package:localkart/unit/showingBusinessSuccessAlerts.dart';

class BusinessServicesUpdate extends StatefulWidget {
  late Map<String, Object> register;
  GetBusinessDetailsModel getBusiness;
  List<String> listImages;

  BusinessServicesUpdate({
    Key? key,
    required this.listImages,
    required this.getBusiness,
    required this.register,
  }) : super(key: key);

  @override
  _BusinessServicesUpdateFormState createState() =>
      _BusinessServicesUpdateFormState();
}

class _BusinessServicesUpdateFormState extends State<BusinessServicesUpdate> {
  late Map<String, Object> register;

  late List<String> listImages;

  @override
  void initState() {
    listImages = widget.listImages;
    getBusiness = widget.getBusiness;
    register = widget.register;
    super.initState();

    try {
      // show services list

      print(
        "my service length " +
            getBusiness.result!.serviceDetails!.length.toString(),
      );

      for (int i = 0; i < getBusiness.result!.serviceDetails!.length; i++) {
        listServises.add(
          getBusiness.result!.serviceDetails![i].serviceName.toString(),
        );
      }
    } catch (e) {
      print(" empty datas - serviceDetails" + e.toString());
    }
  }

  late BuildContext contextMain;

  bool _isLoading = false;

  late List<String> listServises = [];

  showAlertAddServices() async {
    try {
      var result =
          await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AddServicesAlerts();
                },
              )
              as String;

      if (result == null) {
      } else {
        listServises.add(result.toString());
      }
    } catch (e) {
      print("My res alerts error - " + e.toString());
    }
    setState(() {});
  }

  late GetBusinessDetailsModel getBusiness;

  updateBusinessProfile() async {
    try {
      setState(() {
        _isLoading = true;
      });

      String listString = listServises.join(',');

      Map<String, Object> tags = {
        // "serviceList": listServises,
        "serviceList": listString,
      };
      register['indexId'] =
          "" + getBusiness.result!.basicDetails!.indexId.toString();

      register.addAll(tags);

      var responces = await HttpClients(context).httpBusinessupdate(register);
      //
      try {
        setState(() {
          _isLoading = false;
        });

        var datas = json.decode(responces.body.toString());

        // print("save Businee details res - " + datas.toString());

        if (datas['errorCode'].toString() == "0") {
          try {
            if (listImages.length == 0) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return BusinessSuccessAlerts(
                    contextMain: contextMain,
                    message: "Successfully Updated your Shop Details",
                    isRegister: false,
                  );
                },
              );

              // Navigator.of(context).pushNamedAndRemoveUntil(
              //     '/home', (Route<dynamic> route) => false);
            } else {
              for (int i = 0; i < listImages.length; i++) {
                var type = "" + register['type'].toString();
                var image = "" + listImages[i].toString();
                var indexId = "" + datas['indexId'].toString();
                var isloop = true;
                if (i == listImages.length - 1) {
                  isloop = false;
                }
                await UploadingImages(type, image, indexId, isloop);
              }
            }
          } catch (e) {
            print("error is - " + e.toString());
          }
        }
        // ShowToastdur(context, datas['message'].toString());
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print(" loading rtt " + e.toString());
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(" loading rtt 2 " + e.toString());
    }
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
          body: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
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
                        ],
                      ),
                      SizedBox(height: 15),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "7.Services",
                            style: TextStyle(color: app_theam, fontSize: 18),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(
                          left: 15,
                          right: 15,
                          bottom: 15,
                          top: 15,
                        ),
                        child: listServises.length != 0
                            ? Container(height: 1, width: 1)
                            : Container(
                                height: 40,
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.all(2),
                                child: Center(
                                  child: InkWell(
                                    child: Container(
                                      width: 180,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            app_theam,
                                            Color(0xFFf4a4c8),
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            offset: Offset(5, 5),
                                            blurRadius: 10,
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Add New Services',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      showAlertAddServices();
                                    },
                                  ),
                                ),
                              ),
                      ),
                      Container(
                        height: 350,
                        margin: EdgeInsets.all(15),
                        child: ListView.builder(
                          itemCount: listServises.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _itemList(context, index);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // child: Text("Santhosh Kumar "),
              ),
              _isLoading != false ? fullViewLoadingUi(_isLoading) : Container(),
            ],
          ),
          bottomNavigationBar: Container(
            color: Colors.white,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            activeColor: app_theam,
                            value: this.value,
                            onChanged: (bool? value) {
                              setState(() {
                                this.value = true;
                              });
                            },
                          ), //Checkbox/Che
                          Text("I agree all "),
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
                                "url": urlBusinessTerms,
                              };
                              Navigator.of(
                                context,
                              ).pushNamed(root_web_view_nav, arguments: roots);

                              // launchInBrowser(
                              //     "https://www.localkart.app/terms-and-conditions-customers.php");
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
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
                            decoration: BoxDecoration(
                              gradient: gradient_btn_lift,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Previous",
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
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (value) {
                              updateBusinessProfile();
                            } else {
                              ShowToast(
                                context,
                                "Please accept Terms and Conditions",
                              );
                            }
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: gradient_btn_rigth,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Update",
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  UploadingImages(
    String type,
    String images,
    String indexId,
    bool isloops,
  ) async {
    setState(() {
      _isLoading = true;
    });

    var base64string = "";
    try {
      File imagefile = File(images);
      Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
      base64string = base64.encode(imagebytes); //con

      Map<String, Object> tags = {
        "indexId": indexId,
        "type": type,
        "Image": base64string.toString(),
      };

      var responces = await HttpClients(context).httpUploadimage(tags);
      try {
        setState(() {
          _isLoading = false;
        });

        var datas = json.decode(responces.body.toString());
        print("uploading images details res $isloops " + datas.toString());

        if (datas['errorCode'].toString() == "0") {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return BusinessSuccessAlerts(
                contextMain: contextMain,
                message: "Successfully Updated your Shop Details",
                isRegister: false,
              );
            },
          );
        } else {
          ShowToastdur(context, datas['message'].toString());
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print(" loading rtt " + e.toString());
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(" loading rtt 2 " + e.toString());
    }
  }

  Widget _itemList(BuildContext context, int index) {
    return Container(
      child: ListTile(
        minLeadingWidth: 15,
        leading: Icon(Icons.miscellaneous_services, color: app_theam),
        title: Text(
          listServises[index].toString(),
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        // trailing: InkWell(
        //     child: Icon(Icons.delete_forever_sharp, color: app_theam[200]),
        //     onTap: () {
        //       setState(() {});
        //       listServises.remove(listServises[index]);
        //     })
      ),
    );
  }

  bool value = true;
}
