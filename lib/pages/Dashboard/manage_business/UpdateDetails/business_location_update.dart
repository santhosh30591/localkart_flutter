import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localkart/model/businessModel/get_business_details.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';

import 'business_tags_photos_update.dart';
import 'dart:convert' as convert;

class LocationMapsDetailsUpdate extends StatefulWidget {
  Map<String, Object> register;
  GetBusinessDetailsModel getBusiness;

  LocationMapsDetailsUpdate({
    Key? key,
    required this.getBusiness,
    required this.register,
  }) : super(key: key);

  @override
  _LocationMapsDetailsUpdate createState() => _LocationMapsDetailsUpdate();
}

class _LocationMapsDetailsUpdate extends State<LocationMapsDetailsUpdate> {
  // late Location _location;
  late Map<String, Object> register;
  late GetBusinessDetailsModel getBusiness;
  var api_key = "AIzaSyC6e1oG9ODcguxJcHKl0OYeR-D4K-MIrs8";

  @override
  void dispose() {
    _txtControlSearch.dispose();
    super.dispose();
  }

  List<PlaceDetails> placeDetails = [];

  getLocation(String values) async {
    print("location is " + values.toString());
    var url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$values&types=establishment&radius=500&key=$api_key";
    Response responces = await get(
      Uri.parse(url),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
    );

    var datas = convert.json.decode(responces.body.toString());

    try {
      print("data " + datas.toString());

      List listData = datas['predictions'];
      placeDetails = [];
      for (int i = 0; i < listData.length; i++) {
        var title = "";
        PlaceDetails place = PlaceDetails();
        try {
          title = "" + listData[i]['description'];
          place.name = listData[i]['description'];
          place.placeId = listData[i]['place_id'];
          place.reference = listData[i]['reference'];
          placeDetails.add(place);
          print("count $i and address " + title);
        } catch (e) {
          print("name err - " + e.toString());
        }
      }

      setState(() {});
    } catch (e) {
      print("Error json is - " + e.toString());
    }
  }

  getLatLong(String place_id, String address) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=' +
        place_id +
        '&key=$api_key';

    print("my location lat and longs " + url);
    Response responces = await get(
      Uri.parse(url),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
    );

    var datas = convert.json.decode(responces.body.toString());

    try {
      // print("my location lat and longs " + datas.toString());

      print(
        "place lat " +
            datas['result']['geometry']['location']['lat'].toString(),
      );
      double lat = double.parse(
        datas['result']['geometry']['location']['lat'].toString(),
      );
      double lng = double.parse(
        datas['result']['geometry']['location']['lng'].toString(),
      );
      _center = LatLng(lat, lng);
      _kGooglePlex = CameraPosition(target: _center, zoom: 15.4746);

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));

      _txtControlSearch.text = "";
      setState(() {});
      placeDetails = [];
    } catch (e) {
      print("Error json is - " + e.toString());
    }
  }

  @override
  void initState() {
    getBusiness = widget.getBusiness;
    register = widget.register;
    _kGooglePlex = CameraPosition(target: _center, zoom: 15.4746);

    mapTypes = MapType.normal;
    // _location = new Location();
    super.initState();

    current_select_address = getBusiness.result!.locationDetails!.address
        .toString();

    var lat = double.parse(
      getBusiness.result!.locationDetails!.latitude.toString(),
    );

    var longs = double.parse(
      getBusiness.result!.locationDetails!.longitude.toString(),
    );

    _center = LatLng(lat, longs);

    getUserLocation();
  }

  Future<Position> locateUser() async {
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  getUserLocation() async {
    try {
      currentLocation = await locateUser();
      setState(() {
        _center = LatLng(currentLocation.latitude, currentLocation.longitude);
      });
      print('center $_center');

      setState(() {
        _kGooglePlex = CameraPosition(target: _center, zoom: 15.4746);

        GetAddressFromLatLong(
          currentLocation.latitude,
          currentLocation.longitude,
        );
      });
    } catch (e) {
      print("location is not avable - " + e.toString());
    }
  }

  String current_select_address = "";

  Future<void> GetAddressFromLatLong(latitude, longitude) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      latitude,
      longitude,
    );
    print(placemarks);
    Placemark place = placemarks[0];

    setState(() {
      current_select_address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
      print("select current_select_address - " + current_select_address);
    });
  }

  late MapType mapTypes;

  late LatLng _center = LatLng(12.745436, 77.8102259);
  late Position currentLocation;

  Completer<GoogleMapController> _controller = Completer();

  late CameraPosition _kGooglePlex;

  var _txtControlSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child:

          actionBarTopBottomView("My Business", context,
      Scaffold(

        body: Container(
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
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "4.Location & Map Details.",
                    style: TextStyle(color: app_theam, fontSize: 18),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  bottom: 10,
                  top: 5,
                ),
                child: TextField(
                  autocorrect: true,
                  controller: _txtControlSearch,
                  maxLines: 1,
                  decoration: InputDecoration(
                    focusColor: Colors.grey,
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.location_pin, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white70,
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    suffixIcon: SizedBox(
                      width: 60,
                      height: 45,
                      child: Row(
                        children: [
                          InkWell(
                            child: const Icon(
                              Icons.close,
                              color: Colors.black45,
                            ),
                            onTap: () {
                              setState(() {});
                              placeDetails = [];
                              _txtControlSearch.text = "";
                            },
                          ),
                          const SizedBox(width: 5),
                          InkWell(
                            child: Icon(
                              mapTypes != MapType.normal
                                  ? Icons.map_sharp
                                  : Icons.satellite,
                              color: Colors.black45,
                            ),
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              setState(() {
                                if (mapTypes == MapType.hybrid) {
                                  mapTypes = MapType.normal;
                                  print("ste");
                                } else {
                                  mapTypes = MapType.hybrid;
                                  print("hybrid");
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    hintText: "Click to search address",
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                  onSubmitted: (value) {
                    if (value.length >= 1) {
                      getLocation(value);
                    } else {
                      placeDetails = [];
                    }

                    FocusScope.of(context).requestFocus();
                    // To do
                  },
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 40),
                      child: GoogleMap(
                        mapType: mapTypes,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        initialCameraPosition: _kGooglePlex,
                        onTap: (latLng) {
                          setState(() {
                            _center = LatLng(latLng.latitude, latLng.longitude);
                            GetAddressFromLatLong(
                              latLng.latitude,
                              latLng.longitude,
                            );
                          });
                        },
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        markers: <Marker>{
                          Marker(
                            draggable: true,
                            markerId: const MarkerId("1"),
                            position: _center,
                            icon: BitmapDescriptor.defaultMarker,
                            // infoWindow: const InfoWindow(
                            //   title: 'Usted está aquí',
                            // ),
                          ),
                        },
                      ),
                    ),
                    Positioned(
                      child: placeDetails == 0
                          ? Container(height: 1, width: 1)
                          : Container(
                              color: Colors.white,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: placeDetails.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return _itemItems(context, index);
                                },
                              ),
                            ),
                    ),
                    Positioned(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.infinity,
                          color: app_theam[200],
                          padding: EdgeInsets.all(10),
                          child: Text(
                            current_select_address,
                            maxLines: 2,
                            style: TextStyle(color: Colors.white),
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
                    Map<String, Object> location = {
                      "address": "" + current_select_address.toString(),
                      "latitude": "" + _center.latitude.toString(),
                      "longitude": "" + _center.longitude.toString(),
                    };
                    register.addAll(location);
                    print("location " + register.toString());

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TagsPhotosUpdate(
                          getBusiness: getBusiness,
                          register: register,
                        ),
                      ),
                    );

                    // Navigator.of(context).pushNamed(root_business_tags);
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
    ));
  }

  Widget _itemItems(BuildContext context, int index) {
    return Container(
      child: InkWell(
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    placeDetails[index].name.toString(),
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Container(height: 1, color: Color(0xFFEEEEEE)),
            ],
          ),
        ),
        onTap: () {
          _txtControlSearch.text = placeDetails[index].name.toString();

          getLatLong(
            placeDetails[index].placeId.toString(),
            placeDetails[index].name.toString(),
          );

          current_select_address = placeDetails[index].name.toString();

          setState(() {});
        },
      ),
    );
  }
}

class PlaceDetails {
  String name = "";
  String placeId = "";
  String reference = "";
}
