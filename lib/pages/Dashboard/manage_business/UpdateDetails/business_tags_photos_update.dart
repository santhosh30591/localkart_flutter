import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localkart/Api/service.dart';
import 'package:localkart/model/businessModel/get_business_details.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/image_zooming.dart';
import 'package:localkart/unit/showing.dart';

import 'business_services_update.dart';

class TagsPhotosUpdate extends StatefulWidget {
  Map<String, Object> register;
  GetBusinessDetailsModel getBusiness;

  TagsPhotosUpdate({
    Key? key,
    required this.getBusiness,
    required this.register,
  }) : super(key: key);

  @override
  _TagsPhotosUpdateFormState createState() => _TagsPhotosUpdateFormState();
}

class _TagsPhotosUpdateFormState extends State<TagsPhotosUpdate> {
  late Map<String, Object> register;

  late GetBusinessDetailsModel getBusiness;

  @override
  void initState() {
    register = widget.register;
    getBusiness = widget.getBusiness;

    for (int i = 0; i < getBusiness.result!.tags!.length; i++) {
      listTags.add(getBusiness.result!.tags![i].tagName.toString());
    }

    super.initState();
  }

  final ImagePicker imgpicker = ImagePicker();
  String imagepath = "";
  late File imagefile;

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

        setState(() {});

        if (pickedFile.path != null) {
          imagepath = pickedFile.path.toString();
          print(" image file 123" + imagepath.toString());
          // imagefile = pickedFile;

          Navigator.pop(context, "" + pickedFile.path.toString());

          ImageDetails imgdetails = ImageDetails();

          imgdetails.imageIndexId =
              (getBusiness.result!.imageDetails!.length + 1);
          imgdetails.imageUrl = imagepath;
          getBusiness.result!.imageDetails!.add(imgdetails);

          setState(() {});
        } else {
          print("Image is not cropped.");
        }
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file. e $e");
    }
  }

  deleteBanners(int id) async {
    ShowTost("Please wait....");
    late Map<String, Object> inputs;
    inputs = {
      "imageIndexId":
          "" + getBusiness.result!.imageDetails![id].imageIndexId.toString(),
    };
    var responces = await HttpClients(context).httpDeletebusinessbanner(inputs);
    try {
      var responce = "" + responces.body.toString();
      var datas = json.decode(responce);
      print("get Business details  " + responce.toString());
      if (datas['errorCode'].toString() == "0") {
        setState(() {
          getBusiness.result!.imageDetails!.remove(
            getBusiness.result!.imageDetails![id],
          );
        });
      }
      Navigator.pop(contextAlerts);
      ShowTost(datas['message'].toString());
    } catch (e) {
      print("delete this banner details errors is " + e.toString());
    }
  }

  late BuildContext contextTest;

  notAllowing() {
    Widget noButton = TextButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.pop(contextTest);
        try {
          FocusScope.of(context).requestFocus(FocusNode());
        } catch (e) {}
      },
    );

    AlertDialog alert = AlertDialog(
      content: Text(
        "Maximum Photo Limit (2) Reached. You can upload more photos In your Profile section after successful registration  ",
      ),
      actions: [noButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        contextTest = context;
        return alert;
      },
    );
  }

  showAlertDialog(BuildContext context, int index) {
    // set up the button
    Widget yesButton = TextButton(
      child: Text("YES"),
      onPressed: () async {
        deleteBanners(index);
      },
    );
    Widget noButton = TextButton(
      child: Text("NO"),
      onPressed: () {
        Navigator.pop(contextAlerts);
        // Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Confirmation!"),
      content: Text("Are you sure you want to delete?"),
      actions: [noButton, yesButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        contextAlerts = context;
        return alert;
      },
    );
  }

  late BuildContext contextAlerts;
  late BuildContext contextMain;

  var _controlTags = TextEditingController();

  List<String> listTags = [];

  Widget _listItem(int i) {
    return Container(
      margin: EdgeInsets.only(left: 6, right: 6, top: 3, bottom: 3),
      child: Chip(
        label: Text(listTags[i]),
        // label: const Text('Chip'),
        deleteButtonTooltipMessage: 'Delete',
        deleteIconColor: app_theam,
        deleteIcon: Icon(Icons.close),
        // The icon displayed when onDeleted is set.
        onDeleted: () {
          setState(() {
            listTags.remove(listTags[i]);
          });
        },
        // useDeleteButtonTooltip: true,
      ),
    );
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
                    ],
                  ),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "5.Tags",
                        style: TextStyle(color: app_theam, fontSize: 18),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFE0E0E0), width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: EdgeInsets.only(
                      left: 15,
                      right: 15,
                      bottom: 15,
                      top: 15,
                    ),
                    child: Container(
                      height: 45,
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.all(2),
                      child: Center(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 8, bottom: 2),
                                child: TextField(
                                  controller: _controlTags,
                                  textAlignVertical: TextAlignVertical.center,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    hintText:
                                        "Enter keyword(used for searching)",
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  onSubmitted: (str) {},
                                ),
                              ),
                            ),
                            InkWell(
                              child: Container(
                                width: 80,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: app_gradient,
                                  borderRadius: BorderRadius.circular(8),
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
                                    'Add',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                setState(() {});
                                String tags = _controlTags.text.toString();
                                if (tags.length > 1) {
                                  listTags.add(tags);
                                  _controlTags.text = "";
                                }
                                print("Tagss - " + listTags.toString());
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 15, left: 15),
                    child: listTags.length != 0
                        ? Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFFE0E0E0),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Wrap(
                              children: [
                                for (int i = 0; i < listTags.length; i++)
                                  _listItem(i),
                              ],
                            ),
                          )
                        :
                          // padding: EdgeInsets.only(right: 1, left: 1),
                          const Text(""),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "6.Photos",
                        style: TextStyle(color: app_theam, fontSize: 18),
                      ),
                    ),
                  ),
                  Container(
                    child: Container(
                      child: getBusiness.result!.imageDetails!.length != 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  getBusiness.result!.imageDetails!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _itemList(context, index);
                              },
                            )
                          : Container(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  InkWell(
                    child: Container(
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: app_gradient,
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
                          'Select Photos',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                    onTap: () {
                      if (getBusiness.result!.imageDetails!.length <= 1) {
                        showBottomSheetCustomeView(
                          context,
                          "Select",
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: const Icon(Icons.photo_outlined),
                                title: const Text('Gallery'),
                                onTap: () {
                                  setState(() {
                                    openFilePath(1);
                                  });
                                  // Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.camera_alt),
                                title: const Text('Camera'),
                                onTap: () {
                                  setState(() {
                                    openFilePath(2);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      } else {
                        notAllowing();
                      }
                    },
                  ),
                  const SizedBox(height: 15),
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

                      if (listTags.length == 0) {
                        ShowToastdur(context, "Please add some tags ");
                      } else if (getBusiness.result!.imageDetails!.length ==
                          0) {
                        ShowToastdur(context, "Please select photos");
                      } else {
                        goToNext();
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

  Widget _itemList(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(top: 5, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Banner " + (index + 1).toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF616161),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Flexible(
                    child: Container(
                      width: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            child: Icon(
                              Icons.cancel_outlined,
                              color: app_theam,
                            ),
                            onTap: () {
                              if (getBusiness
                                  .result!
                                  .imageDetails![index]
                                  .imageUrl!
                                  .toString()
                                  .contains("http")) {
                                showAlertDialog(context, index);
                              } else {
                                getBusiness.result!.imageDetails!.remove(
                                  getBusiness.result!.imageDetails![index],
                                );

                                setState(() {});
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            getBusiness.result!.imageDetails![index].imageUrl!
                    .toString()
                    .contains("http")
                ? Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      bottom: 10,
                    ),
                    child: InkWell(
                      child: Container(
                        height: 200,
                        width: (MediaQuery.of(context).size.width - 30),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                          child: Image.network(
                            getBusiness.result!.imageDetails![index].imageUrl
                                .toString(),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ZoomingImages(
                              title: "Banners " + (index + 1).toString(),
                              image: getBusiness
                                  .result!
                                  .imageDetails![index]
                                  .imageUrl
                                  .toString(),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      bottom: 10,
                    ),
                    child: Container(
                      height: 200,
                      width: (MediaQuery.of(context).size.width - 30),
                      child: Image.file(
                        File(
                          getBusiness.result!.imageDetails![index].imageUrl
                              .toString(),
                        ),
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  goToNext() async {
    List<String> listImages = [];

    for (int i = 0; i < getBusiness.result!.imageDetails!.length; i++) {
      if (getBusiness.result!.imageDetails![i].imageUrl!.toString().contains(
        "http",
      )) {
      } else {
        listImages.add(
          getBusiness.result!.imageDetails![i].imageUrl!.toString(),
        );
      }
    }

    String listString = listTags.join(',');
    Map<String, Object> tags = {"tags": listString};
    register.addAll(tags);
    print("tags " + register.toString());
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BusinessServicesUpdate(
          listImages: listImages,
          getBusiness: getBusiness,
          register: register,
        ),
      ),
    );
  }
}
