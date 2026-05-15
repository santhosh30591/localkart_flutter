import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localkart/theams_colors.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

Widget submitButton(String name, bool isSubmitBtn) {
  return Container(
    alignment: Alignment.center,
    width: double.infinity,
    height: 50,
    padding: EdgeInsets.all(4),
    margin: EdgeInsets.all(4),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        // Define the colors for the gradient. At least two are required.
        colors: isSubmitBtn == false ?[Colors.grey, Colors.grey] :[gradint_start_color, gradient_end_color],
        // Define where the gradient starts and ends (Alignment values range from -1.0 to 1.0).
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.45, 1.0],
      ),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    child: Text(
      name,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      maxLines: 2,
    ),
  );
}

Widget submitBottomButton(String name, bool isSubmitBtn) {
  return Container(
    alignment: Alignment.center,
    width: double.infinity,
    height: 50,
    padding: EdgeInsets.all(4),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        // Define the colors for the gradient. At least two are required.
        colors: [gradint_start_color, gradient_end_color],
        // Define where the gradient starts and ends (Alignment values range from -1.0 to 1.0).
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.45, 1.0],
      ),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(8),
        bottomRight: Radius.circular(8),
      ),
      color: isSubmitBtn == false ? Colors.grey : app_theam,
    ),
    child: Text(
      name,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      maxLines: 2,
    ),
  );
}
