import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localkart/theams_colors.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

PreferredSizeWidget billpayActionBar(String title, BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () => Navigator.of(context).pop(),
    ),
    // backgroundColor: app_theam,
    // Here we take the value from the MyHomePage object that was created by
    // the App.build method, and use it to set our appbar title.
    title: Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ), // Set title color here
    ),
    actions: [
      Image.asset('assets/bharat_connect.png', height: 25),
      SizedBox(width: 16), // Add padding from the edge
    ],
  );
}

Widget actionBarTopBottomViewBharathConnect(
  String title,
  BuildContext context,
  Widget child,
) {
  return AnnotatedRegion<SystemUiOverlayStyle>(
    value: const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
    child: Stack(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/login-reg-bg.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),

        SafeArea(
          top: true,
          bottom: true,

          child: Scaffold(
            // extendBody: true,
            // extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              // backgroundColor: app_theam,
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ), // Set title color here
              ),
              actions: [
                Image.asset('assets/bharat_connect.png', height: 25),
                SizedBox(width: 16), // Add padding from the edge
              ],
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: child,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget actionBarTopBottomView(
  String title,
  BuildContext context,
  Widget child,
) {
  return AnnotatedRegion<SystemUiOverlayStyle>(
    value: const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
    child: Stack(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/login-reg-bg.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),

        SafeArea(
          top: true,
          bottom: true,

          child: Scaffold(
            // extendBody: true,
            // extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              // backgroundColor: app_theam,
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ), // Set title color here
              ),
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: child,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget actionBarAiBGChange(String title, BuildContext context, Widget child) {
  return AnnotatedRegion<SystemUiOverlayStyle>(
    value: const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
    child: Stack(
      children: <Widget>[
        // Container(
        //   decoration: const BoxDecoration(
        //     image: DecorationImage(
        //       image: AssetImage("assets/login-reg-bg.png"),
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        // ),
        Container(decoration: BoxDecoration(gradient: app_gradient)),

        SafeArea(
          top: true,
          bottom: true,

          child: Scaffold(
            // extendBody: true,
            // extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              // backgroundColor: app_theam,
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ), // Set title color here
              ),
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              child: child,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget commonViewActionBar(
  String title,
  BuildContext context, {
  required Widget child,
}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () => Navigator.of(context).pop(),
    ),
    title: Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ), // Set title color here
    ),
  );
}
