import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localkart/RoutingSetup/router-constants.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/unit/showing.dart';

class LocationService {
  checkingGpsSearch(
    BuildContext context,
    bool isSearch,
    String roots,
    dynamic arg,
  ) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!serviceEnabled || permission == LocationPermission.denied) {
      showAlertDialog(context, isSearch, roots, arg, context);
      return;
    }

    String latitude = await DBHelper().getLocationDetailsDB(true);

    if (latitude.isEmpty || latitude == "0.0" || latitude == "null") {
      ShowToastdur(context, "Location not getting, please wait some time");
      Position position = await _getGeoLocationPosition();
      await DBHelper().saveLocationDetailsDB(
        position.latitude,
        position.longitude,
      );
    }

    if (isSearch) {
      checkAuthDetails(roots, context);
    } else {
      Navigator.of(context).pushNamed(roots, arguments: arg);
      Position position = await _getGeoLocationPosition();
      await DBHelper().saveLocationDetailsDB(
        position.latitude,
        position.longitude,
      );
    }
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  checkAuthDetails(roots, BuildContext context) async {
    try {
      var getLogin = await DBHelper().getLoginDB("errorCode");
      if (getLogin.toString() == "0") {
        // isLogin = true;
        Navigator.of(context).pushReplacement(roots);
      } else {
        var result = await Navigator.of(context).pushNamed(root_login) as bool;
        // print("isLogin is - " + result.toString());
        try {
          if (result) {
            Position position = await _getGeoLocationPosition();
            await DBHelper().saveLocationDetailsDB(
              position.latitude,
              position.longitude,
            );
            Navigator.of(context).pushReplacement(roots);
          }
        } catch (e) {}
      }
    } catch (e) {}
    // setState(() {});
  }

  Future<void> showAlertDialog(context, isSerach, roots, arg, context1) async {
    Widget yesButton = TextButton(
      child: Text('Continue'),
      onPressed: () async {
        Navigator.pop(context1);
        // confirmBtn_details = "Continue ";
        Position position = await _getGeoLocationPosition();

        if (await DBHelper().saveLocationDetailsDB(
          position.latitude,
          position.longitude,
        )) {
          Navigator.of(context).pushNamed(roots, arguments: arg);
        } else {
          ShowToastdur(
            context,
            "Location not getting so please wait some time",
          );
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      // title: Text("Confirmation!"),
      content: const Text(
        "Allow location to get the current location to identify the nearest services .",
      ),
      actions: [
        // opction,
        yesButton,
      ],
    );

    // show the dialog
    await showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (BuildContext context) {
        context1 = context;
        return alert;
      },
    );
  }
}
