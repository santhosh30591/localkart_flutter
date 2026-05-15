import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/data_base/db_config.dart';

import 'package:localkart/model/businessModel/choiceModel.dart';
import 'package:localkart/model/businessModel/get_business_details.dart';
import 'package:localkart/pages/Dashboard/manage_business/UpdateDetails/business_address_update.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:localkart/unit/image_zooming.dart';
import 'package:localkart/unit/showing.dart';

import 'dart:typed_data';

class UpdateBusiness extends StatefulWidget {
  UpdateBusiness({Key? key}) : super(key: key);

  @override
  _UpdateBusinessFormState createState() => _UpdateBusinessFormState();
}

class _UpdateBusinessFormState extends State<UpdateBusiness> {
  @override
  void initState() {
    getBusiness.errorCode = 1;
    _controller_bus_type.text = "Business Type";
    _controller_bus_name.text = "";
    _controller_bus_category.text = "Category";
    _controller_bus_subCate.text = "Sub Category";
    _controller_bus_about.text = "";

    getBusineedetails();
    super.initState();
  }

  var userIndexId = "";
  bool _isLoading = false;
  var type = "";

  getBusineedetails() async {
    userIndexId = await DBHelper().getLoginSubDB("Id");
    type = await DBHelper().getLoginDB("type");
    setState(() {
      _isLoading = true;
    });

    late Map<String, Object> inputs;
    inputs = {"type": "" + type, "userIndexId": "" + userIndexId};

    var responces = await ApiClientLocalKart().httpPost(
      inputs,
      urlEditbusiness,
    );
    try {
      setState(() {
        _isLoading = false;
      });

      var responce = "" + responces.body.toString();
      var datas = json.decode(responce);
      if (datas['errorCode'].toString() == "0") {
        setState(() {
          getBusiness = GetBusinessDetailsModel.fromJson(datas);

          _controller_bus_type.text = getBusiness
              .result!
              .basicDetails!
              .businessType!
              .toString();
          _controller_bus_name.text = getBusiness
              .result!
              .basicDetails!
              .businessName!
              .toString();
          _controller_bus_category.text = getBusiness
              .result!
              .basicDetails!
              .category!
              .toString();
          _controller_bus_subCate.text = getBusiness
              .result!
              .basicDetails!
              .subCategory!
              .toString();
          _controller_bus_about.text = getBusiness
              .result!
              .basicDetails!
              .description!
              .toString();
          category_id = getBusiness.result!.basicDetails!.categoryId.toString();
          subcate_id = getBusiness.result!.basicDetails!.subCategoryId
              .toString();
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("encode err - " + e.toString());
    }
  }

  List<Choice> Category = [];
  List<Choice> subCategory = [];
  var _controller_bus_type = TextEditingController();
  var _controller_bus_name = TextEditingController();
  var _controller_bus_category = TextEditingController();
  var _controller_bus_subCate = TextEditingController();
  var _controller_bus_about = TextEditingController();

  final ImagePicker imgpicker = ImagePicker();
  String imagepath = "";
  File? imagefile;

  var subcate_id = "";
  var category_id = "";

  showAlertsImgPick() {
    showBottomSheetCustomeView(
      context,
      "Select Image Source",
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.photo_outlined, color: app_theam),
            title: const Text('Gallery'),
            onTap: () {
              Navigator.pop(context);
              openFilePath(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt, color: app_theam),
            title: const Text('Camera'),
            onTap: () {
              Navigator.pop(context);
              openFilePath(2);
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  openFilePath(int type) async {
    try {
      XFile? pickedFile;
      if (type == 1) {
        pickedFile = await imgpicker.pickImage(source: ImageSource.gallery);
      } else {
        pickedFile = await imgpicker.pickImage(source: ImageSource.camera);
      }
      if (pickedFile != null) {
        imagepath = await cropImage(pickedFile.path);
        imagefile = File(imagepath);
        setState(() {});
      }
    } catch (e) {
      print("error while picking file.");
    }
  }

  late GetBusinessDetailsModel getBusiness = GetBusinessDetailsModel();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: actionBarTopBottomView(
        "My Business",
        context,
        Scaffold(
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  children: [
                    Row(
                      children: List.generate(
                        6,
                        (index) => Expanded(
                          child: Container(
                            height: 4,
                            color: index == 0
                                ? bussiness_select_tab_colors
                                : Colors.grey[200],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "1. Basic Details",
                            style: TextStyle(
                              color: app_theam,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildUnderlineField(
                            _controller_bus_type,
                            "Business Type",
                            suffix: Icons.arrow_drop_down_sharp,
                          ),
                          _buildUnderlineField(
                            _controller_bus_name,
                            "Business Name",
                            enabled: false,
                          ),
                          _buildUnderlineField(
                            _controller_bus_category,
                            "Category",
                            suffix: Icons.arrow_drop_down_sharp,
                          ),
                          _buildUnderlineField(
                            _controller_bus_subCate,
                            "Sub Category",
                            suffix: Icons.arrow_drop_down_sharp,
                          ),

                          const SizedBox(height: 10),
                          TextField(
                            maxLines: 5,
                            controller: _controller_bus_about,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              labelText: "About (Max 30 words)",
                              alignLabelWithHint: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),

                          Center(
                            child: Column(
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: imagepath != ""
                                        ? Image.file(
                                            imagefile!,
                                            fit: BoxFit.cover,
                                          )
                                        : (getBusiness
                                                      .result
                                                      ?.basicDetails
                                                      ?.shopLogo !=
                                                  null
                                              ? Image.network(
                                                  getBusiness
                                                      .result!
                                                      .basicDetails!
                                                      .shopLogo!,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (c, e, s) =>
                                                      const Icon(
                                                        Icons.image,
                                                        size: 60,
                                                        color: Colors.grey,
                                                      ),
                                                )
                                              : const Icon(
                                                  Icons.image,
                                                  size: 60,
                                                  color: Colors.grey,
                                                )),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton.icon(
                                  onPressed: showAlertsImgPick,
                                  icon: const Icon(
                                    Icons.photo_library,
                                    size: 18,
                                  ),
                                  label: const Text("Select Logo"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: app_theam,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (_isLoading) fullViewLoadingUi(_isLoading),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: InkWell(
              child: Container(
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(gradient: app_gradient),
                child: Text(
                  "Next",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              onTap: () {
                submitBasicDetails();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUnderlineField(
    TextEditingController controller,
    String label, {
    bool enabled = false,
    IconData? suffix,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: suffix != null ? Icon(suffix) : null,
          disabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          border: const UnderlineInputBorder(),
        ),
      ),
    );
  }

  bool checking() {
    if (_controller_bus_type.text == "Business Type") {
      ShowToastdur(context, "Select business type");
      return false;
    }
    if (_controller_bus_name.text.isEmpty) {
      ShowToastdur(context, "Enter business name");
      return false;
    }
    if (_controller_bus_about.text.isEmpty) {
      ShowToastdur(context, "Enter about content");
      return false;
    }
    return true;
  }

  submitBasicDetails() async {
    late Map<String, Object> register;

    var base64string = "";

    try {
      if (imagepath != "") {
        Uint8List imagebytes = await imagefile!
            .readAsBytes(); //convert to bytes
        base64string = base64.encode(imagebytes); //con
      } else {}
    } catch (e) {}
    register = {
      "type": _controller_bus_type.text.toString(),
      "name": "" + _controller_bus_name.text,
      "catId": "" + category_id.toString(),
      "subCatId": "" + subcate_id.toString(),
      "description": "" + _controller_bus_about.text,
      "userIndexId": userIndexId,
      "Image": "" + base64string,
    };

    print("My Json is " + register.toString());
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            BusinessAddressUpdate(getBusiness: getBusiness, register: register),
      ),
    );
  }
}
