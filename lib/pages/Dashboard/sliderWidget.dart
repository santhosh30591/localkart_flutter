import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/sliderModel.dart';
import 'package:localkart/theams_colors.dart';

class SliderWidget extends StatefulWidget {
  SliderWidget({Key? key, required this.pageId}) : super(key: key);

  String pageId;

  @override
  State<SliderWidget> createState() => _MySliderWidget();
}

class _MySliderWidget extends State<SliderWidget> {
  var stateId = '1';
  var districtId = '752';

  _getId() async {
    var _stateId = await DBHelper().getLoginSubDB("stateId") ?? '';
    var _districtId = await DBHelper().getLoginSubDB("districtId") ?? '';
    setState(() {
      stateId = _stateId;
      districtId = _districtId;
    });
  }

  @override
  void initState() {
    _getId();
    _getSlider(widget.pageId);
    super.initState();
  }

  List<SliderModel> sliders = [];

  Future<void> _getSlider(String type) async {
    var _stateId = stateId == '' ? '1' : stateId;
    var _districtId = districtId == '' ? '753' : districtId;

    print("tytpe $type");

    if (type == 'dashboard') {
      Map<String, Object> inputs = {
        "stateId": _stateId,
        "districtId": _districtId,
      };
      var response = await ApiClientLocalKart().httpPost(inputs, urlDashSlide);
      var responseBody = json.decode(response.body);
      List<SliderModel> _sliders = [];
      var sliderResponse = responseBody['result'];
      for (var slider in sliderResponse) {
        _sliders.add(SliderModel.fromJson(slider));
      }

      setState(() {
        sliders = _sliders;
      });
    } else {
      Map<String, Object> inputs = {
        "stateId": _stateId,
        "districtId": _districtId,
        "type": "business",
      };
      var response = await ApiClientLocalKart().httpPost(inputs, urlDashSlide);
      var responseBody = json.decode(response.body);
      List<SliderModel> _sliders = [];
      sliders = [];
      var sliderResponse = responseBody['result'];
      for (var slider in sliderResponse) {
        _sliders.add(SliderModel.fromJson(slider));
      }

      setState(() {
        sliders = _sliders;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return sliders.isEmpty
        ? Container(
            alignment: Alignment.center,
            height: 200,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(0.0),
                bottomLeft: Radius.circular(0.0),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/loading.gif"),
                  ),
                ),
              ),
            ),
          )
        : Column(
            children: [
              InkWell(
                child: ImageSlideshow(
                  width: double.infinity,
                  height: 200,
                  initialPage: 0,
                  indicatorColor: app_theam,
                  indicatorBackgroundColor: Colors.grey,

                  children: [
                    for (var items in sliders)
                      Image.network(
                        items.image.toString(),
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/loading.gif"),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset("assets/logo_with_name1.png");
                        },
                      ),
                  ],
                  onPageChanged: (value) {
                    try {
                      setState(() {
                        // currentSlider =
                        //     listDashboard[value];
                      });
                    } catch (e) {}
                  },

                  autoPlayInterval: 3000,
                  isLoop: true,
                ),
                onTap: () {
                  // slideOnclick(1);
                },
              ),
            ],
          );
  }
}
