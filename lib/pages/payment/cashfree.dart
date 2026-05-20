import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:localkart/theams_colors.dart';
import 'package:localkart/unit/action_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CashFreePaymentPage extends StatefulWidget {
  String? setOrderId;

  String? setPaymentSessionId;
  String? environment;

  CashFreePaymentPage({
    Key? key,
    @required this.setOrderId,
    @required this.setPaymentSessionId,
    @required this.environment,
  }) : super(key: key);

  @override
  _WebViewLoad createState() => _WebViewLoad();
}

class _WebViewLoad extends State<CashFreePaymentPage> {
  bool isLoading = true;
  String? setOrderId;

  String? setPaymentSessionId;
  String? environment;

  late final WebViewController controller;
  String title = "";

  var cfPaymentGatewayService = CFPaymentGatewayService();

  void initPaymentProcess() {
    // 1. Always set the callbacks first
    cfPaymentGatewayService.setCallback(
      (orderId) {
        var response = {
          "status": "success",
          "orderId": "$orderId",
          "message": "success",
        };
        Navigator.pop(context, response);

        // Verify with your backend here
      },
      (errorResponse, orderId) {
        var response = {
          "status": "failed",
          "orderId": "$orderId",
          "message": "${errorResponse.getMessage()}",
        };
        Navigator.pop(context, response);
      },
    );

    try {
      // 2. Build the session
      var session = CFSessionBuilder()
          .setEnvironment(
            environment == "PRO"
                ? CFEnvironment.PRODUCTION
                : CFEnvironment.SANDBOX,
          )
          .setOrderId(setOrderId.toString())
          .setPaymentSessionId(setPaymentSessionId.toString())
          .build();

      // 3. Build the checkout configuration
      var checkoutPayment = CFDropCheckoutPaymentBuilder()
          .setSession(session)
          .build();

      // 4. Finally, initiate the payment
      cfPaymentGatewayService.doPayment(checkoutPayment);
    } on CFException catch (e) {
      print("Configuration Error: ${e.message}");
    }
  }

  gettingDetails() async {
    try {
      setOrderId = await widget.setOrderId;
      setPaymentSessionId = await widget.setPaymentSessionId;
      environment = await widget.environment;
    } catch (e) {
      print("web view loading e " + e.toString());
    }
    setState(() {});
    initPaymentProcess();
  }

  @override
  void initState() {
    super.initState();
    gettingDetails();
  }

  @override
  Widget build(BuildContext context) {
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

            child: WillPopScope(
              onWillPop: () async {
                var response = {
                  "status": "cancel",
                  "orderId": "",
                  "message": "Back Button Pressed",
                };
                Navigator.pop(context, response);
                return false;
              },
              child: Scaffold(
                // extendBody: true,
                // extendBodyBehindAppBar: true,
                backgroundColor: Colors.transparent,

                body: Container(
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      "₹",
                      style: TextStyle(
                        color: app_theam,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
