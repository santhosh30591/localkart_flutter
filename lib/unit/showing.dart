import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/buttons.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

void ShowTost(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: app_theam,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

void ShowToast(BuildContext context, String msg) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(content: Text(msg), duration: const Duration(milliseconds: 2000)),
  );
}

Widget fullViewLoadingUi(bool isLoading) {
  return isLoading == true
      ? Container(
          color: Colors.white.withOpacity(0.7),
          child: Center(child: CircularProgressIndicator(color: app_theam)),
        )
      : Container();
}

void ShowToastdur(BuildContext context, String msg) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(content: Text(msg), duration: const Duration(milliseconds: 3000)),
  );
}

void ShowAlertsToast(BuildContext context, String title, String msg) {
  Widget yesButton = TextButton(
    child: const Text("YES"),
    onPressed: () async {
      Navigator.pop(context, true);
    },
  );
  Widget noButton = TextButton(
    child: const Text("NO"),
    onPressed: () {
      Navigator.pop(context, false);
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(
      "You'll receive notifications when $msg posts new Deals and Offer.Are you sure want to Subscribe?",
    ),
    actions: [noButton, yesButton],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void showCommonToast(BuildContext context, String title, String msg) {
  Widget yesButton = TextButton(
    child: const Text("Close"),
    onPressed: () async {
      Navigator.pop(context, true);
    },
  );

  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    title: title.length == 0 ? Text("Alert") : Text(title),
    content: Text(msg),
    actions: [yesButton],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void showBottomSheetCustomeView(
  BuildContext context,
  String title,
  Widget child,
) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,

    builder: (context) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewPaddingOf(context).bottom,
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: new BoxDecoration(
                  gradient: app_gradient,
                  borderRadius: const BorderRadius.only(
                    // ignore: prefer_const_constructors
                    topRight: Radius.circular(15.0),
                    topLeft: Radius.circular(15.0),
                  ),
                ),
                // padding: EdgeInsets.only(
                //   bottom: MediaQuery.viewPaddingOf(context).bottom,
                // ),
                child: ListTile(
                  title: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      title,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),

              Container(
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[child],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future businessAlerts(
  BuildContext context,
  String msg,
  GestureTapCallback onTap,
) async {
  AlertDialog alert = AlertDialog(
    contentPadding: EdgeInsets.all(15),
    scrollable: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    content: Column(
      mainAxisSize: MainAxisSize.min, // 2. Keep column size to minimum
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        Container(
          child: Icon(
            Icons.check_circle_outline,
            size: 100,
            color: Colors.green,
          ),
        ),
        SizedBox(height: 10),
        Text(
          " $msg ",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontSize: 15),
        ),

        SizedBox(height: 10),
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 50,
            child: submitButton("Continue", true),
          ),
        ),
      ],
    ),
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future ShowSubscribe(BuildContext context, String msg) async {
  Widget yesButton = TextButton(
    child: const Text("YES"),
    onPressed: () {
      Navigator.pop(context, "test");
    },
  );
  Widget noButton = TextButton(
    child: const Text("NO"),
    onPressed: () {
      Navigator.pop(context, "true");
    },
  );

  AlertDialog alert = AlertDialog(
    title: const Text("Subscribe!"),
    content: msg.isEmpty
        ? const Text("")
        : RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                const TextSpan(
                  text: "You'll receive notifications when ",
                  style: TextStyle(fontSize: 15),
                ),
                TextSpan(
                  text: msg,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const TextSpan(
                  text:
                      ' posts new Deals and Offer.Are you sure want to Subscribe?',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
    actions: [noButton, yesButton],
  );

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void launchInBrowser(String url) async {
  print("web direction url is - " + url);
  var uri = Uri.parse(url);

  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}

void launchInCall(String phoneNumber) async {
  final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
  await launchUrl(launchUri);
}

void launchInMail(String email) async {
  var uri = Uri.parse("mailto:$email?");
  await launchUrl(uri);
}

launchInWhatsapp(String phone, String message) async {
  print("whatsapp msg " + phone);
  var urls = "";
  if (Platform.isAndroid) {
    urls = "https://wa.me/$phone/?text=${Uri.encodeComponent(message)}";
  } else {
    urls =
        "https://api.whatsapp.com/send?phone=$phone&text=${Uri.encodeComponent(message)}";
  }

  var uri = Uri.parse(urls);

  print("my urls " + uri.toString());

  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $urls';
  }
}

Future<void> shareLocalKart() async {
  await FlutterShare.share(
    title: 'LocalKart ',
    text:
        'LocalKart\nWhy Shop Online? Shop Nearby !\n\nGet More Deals and Benefits !'
        '\n\nDownload LocalKart App Now',
    linkUrl:
        'https://play.google.com/store/apps/details?id=com.localkartmarketing.localkart',
    chooserTitle: 'Choose One',
  );
}

Future<void> shareServicesDetails(String msg, String urls) async {
  await FlutterShare.share(
    title: 'LocalKart ',
    text: msg,
    linkUrl: urls,
    chooserTitle: 'Choose One',
  );
}

Future<void> takePicture(dri, image) async {
  File imgFile = File('$dri/photo.png');
  await imgFile.writeAsBytes(image);
  print("Share Image Path is -  " + imgFile.path.toString());
  await Share.shareFiles([imgFile.path]);
}
