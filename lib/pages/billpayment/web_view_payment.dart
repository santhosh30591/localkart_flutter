import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:localkart/Api/provider/billpay_provider.dart';
import 'package:localkart/model/bill_pay_model/blanace_confirm_model.dart';
import 'package:localkart/theams_colors.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPaymentGateway extends StatefulWidget {
  final dynamic datas;

  const WebViewPaymentGateway({Key? key, required this.datas})
    : super(key: key);

  @override
  State<WebViewPaymentGateway> createState() => _WebViewPaymentGateway();
}

class _WebViewPaymentGateway extends State<WebViewPaymentGateway> {
  bool isLoading = true;

  late final WebViewController controller;
  late var url = "";

  BlanaceConfirmResponseModel get blanaceConfirmResponseModel => widget.datas;

  @override
  void initState() {
    super.initState();

    try {
      url = blanaceConfirmResponseModel.sdk_url!;
      print("skk path " + blanaceConfirmResponseModel.message! + " url $url");
    } catch (e) {
      print("web view loading e " + e.toString());
    }

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) async {
            final String jsonString =
                await controller.runJavaScriptReturningResult(
                      "document.documentElement.innerText",
                    )
                    as String;

            print(" jsonString $jsonString");
            // 3. Clean and parse the JSON
            // Note: runJavaScriptReturningResult often returns a double-quoted string
            // like "\"{\"key\": \"value\"}\"". You may need to decode it first.
            try {
              final decodedJsonString = jsonDecode(jsonString);
              print(" decodedJsonString $decodedJsonString");

              final Map<String, dynamic> data = jsonDecode(decodedJsonString);
              Navigator.of(context).pop(data);
            } catch (e) {
              print("Error parsing JSON: $e");
            }

            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            print("Web view error: ${error.description}");
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/login-reg-bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,

        body: SafeArea(
          child: Container(
            height: double.infinity,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Stack(
              children: [
                WebViewWidget(controller: controller),
                if (isLoading) const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
