import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/data_base/db_config.dart';

import 'config.dart';
import 'dart:convert';
import 'dart:convert' as convert;

class HttpClients {
  late BuildContext context;

  HttpClients(BuildContext contexts) {
    context = contexts;
    HttpOverrides.global = MyHttpOverrides();
    try {
      FocusScope.of(context).requestFocus(FocusNode());
    } catch (e) {}
  }

  Future<Response> httpLogin(Map<String, Object> input) async {
    print("my url - " + urlLogin + " data " + input.toString());

    Response res = await post(
      Uri.parse(urlLogin),
      body: input,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: convert.Encoding.getByName("utf-8"),
    );

    print("my res - " + res.body.toString());

    if (res.statusCode == 200) {
      return res;
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  Future<Response> httpShopping() async {
    Response res = await post(
      Uri.parse(urlShoppingCategories),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: convert.Encoding.getByName("utf-8"),
    );
    if (res.statusCode == 200) {
      return res;
    } else {
      showNetWorkError(context);
      print("network connection " + res.toString());
      return res;
    }
  }

  Future<Response> httpServicesRatingsUpdate(body) async {
    var response = await post(
      Uri.parse(servicerating),
      headers: {
        "Content-Type": "application/json; charset=utf-8",
        // 'Authorization': basicAuth,
      },
      body: convert.json.encode(body),
    );
    // var response;
    print("httpServicesRatingsUpdate code " + response.statusCode.toString());
    if (response.statusCode == 200) {
      print("httpServicesRatingsUpdate " + response.body.toString());
      return response;
    } else {
      showNetWorkError(context);
      return response;
    }
  }

  Future<Response> httpServices() async {
    Response res = await post(
      Uri.parse(urlServiceCategories),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: convert.Encoding.getByName("utf-8"),
    );
    if (res.statusCode == 200) {
      return res;
    } else {
      showNetWorkError(context);
      print("network connection " + res.toString());
      return res;
    }
  }

  Future<Response> httpServicesTyepe(url, input) async {
    print("my url - " + urlServiceTypes + url + " data " + input.toString());
    Response res = await post(
      Uri.parse(urlServiceTypes + url),
      body: input,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: convert.Encoding.getByName("utf-8"),
    );

    // print("res  " + res.body.toString());
    if (res.statusCode == 200) {
      return res;
    } else {
      showNetWorkError(context);
      print("network connection " + res.toString());
      return res;
    }
  }

  Future<Response> httpShopViewCountUpdate(body) async {
    // String basicAuth = await getOauthDetails();

    var response = await post(
      Uri.parse(shopviewcount),
      headers: {
        "Content-Type": "application/json; charset=utf-8",
        // 'Authorization': basicAuth,
      },
      body: json.encode(body),
    );
    print("httpShopViewCountUpdate code " + response.statusCode.toString());
    if (response.statusCode == 200) {
      print("httpServiceViewCountUpdate " + response.body.toString());
      return response;
    } else {
      showNetWorkError(context);
      return response;
    }
  }

  Future<Response> httpShopRatingListing(body) async {
    // String basicAuth = await getOauthDetails();
    // var body = {"user_id": 2, "shop_id": 1,};
    var response = await post(
      Uri.parse(usershoprating),
      headers: {
        "Content-Type": "application/json; charset=utf-8",
        // 'Authorization': basicAuth,
      },
      body: json.encode(body),
    );
    // var response;
    print("httpShopRatingListing code " + response.statusCode.toString());
    print("httpShopRatingListing sendbody " + json.encode(body));
    print("httpShopRatingListing url " + Uri.parse(usershoprating).toString());

    if (response.statusCode == 200) {
      print("httpShopRatingListing " + response.body.toString());
      return response;
    } else {
      showNetWorkError(context);
      return response;
    }
  }

  Future<Response> httpServicesRatingListing(body) async {
    // String basicAuth = await getOauthDetails();
    var response = await post(
      Uri.parse(userservicerating),
      headers: {
        "Content-Type": "application/json; charset=utf-8",
        // 'Authorization': basicAuth,
      },
      body: json.encode(body),
    );
    // var response;
    print("httpServicesRatingListing code " + response.statusCode.toString());
    print("httpServicesRatingListing sendbody " + json.encode(body));
    print(
      "httpServicesRatingListing url " +
          Uri.parse(userservicerating).toString(),
    );

    if (response.statusCode == 200) {
      print("httpServicesRatingListing " + response.body.toString());
      return response;
    } else {
      showNetWorkError(context);
      return response;
    }
  }

  Future<Response> httpShopRatingsUpdate(body) async {
    // String basicAuth = await getOauthDetails();
    // var body = {"user_id": 2, "shop_id": 1, "rating":4};
    var response = await post(
      Uri.parse(shoprating),
      headers: {
        "Content-Type": "application/json; charset=utf-8",
        // 'Authorization': basicAuth,
      },
      body: json.encode(body),
    );
    // var response;
    print("httpShopRatingsUpdate code " + response.statusCode.toString());
    if (response.statusCode == 200) {
      print("httpShopRatingsUpdate " + response.body.toString());
      return response;
    } else {
      showNetWorkError(context);
      return response;
    }
  }

  Future<Response> httpposthistoryviewcount(input) async {
    // String basicAuth = await getOauthDetails();
    Response res = await post(
      Uri.parse(posthistoryviewcount),
      body: json.encode(input),
      headers: {
        "Content-Type": "application/json; charset=utf-8",
        // 'Authorization': basicAuth,
      },
      encoding: convert.Encoding.getByName("utf-8"),
    );

    // print("httpposthistoryviewcount url  "+Uri.parse(posthistoryviewcount).toString());
    print("httpposthistoryviewcount input " + jsonEncode(input));
    // print("httpposthistoryviewcount statusCode  "+res.statusCode.toString());
    if (res.statusCode == 200) {
      print("httpposthistoryviewcount res  " + res.body.toString());

      return res;
    } else {
      showNetWorkError(context);
      return res;
    }
  }

  Future<Response> httpServiceViewCountUpdate(body) async {
    // String basicAuth = await getOauthDetails();

    var response = await post(
      Uri.parse(serviceviewcount),
      headers: {
        "Content-Type": "application/json; charset=utf-8",
        // 'Authorization': basicAuth,
      },
      body: json.encode(body),
    );

    // Response res = await post(Uri.parse(serviceviewcount),
    //     body: body,
    //     headers: {"Content-Type": "application/x-www-form-urlencoded"},
    //     encoding: convert.Encoding.getByName("utf-8"));
    print("httpServiceViewCountUpdate code " + response.statusCode.toString());
    if (response.statusCode == 200) {
      print("httpServiceViewCountUpdate " + response.body.toString());
      return response;
    } else {
      showNetWorkError(context);
      return response;
    }
  }

  Future<Response> httpSubServices(String id, String url) async {
    Map<String, Object> inputs = {"Id": id.toString()};
    print("url " + urlSubCategorys + url + " data " + inputs.toString());
    Response res = await post(
      Uri.parse(urlSubCategorys + url),
      body: inputs,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: convert.Encoding.getByName("utf-8"),
    );

    print("my res " + res.body.toString());
    if (res.statusCode == 200) {
      return res;
    } else {
      showNetWorkError(context);
      print("network connection " + res.toString());
      return res;
    }
  }

  Future<Response> httpState() async {
    Response res = await post(
      Uri.parse(urlState),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: convert.Encoding.getByName("utf-8"),
    );

    if (res.statusCode == 200) {
      return res;
    } else {
      showNetWorkError(context);
      print("network connection " + res.toString());
      return res;
    }
  }

  Future<Response> httpDistrict(String stateId) async {
    Map<String, Object> inputs = {"stateId": stateId};

    print("url $urlDistrict data $inputs");
    Response res = await post(
      Uri.parse(urlDistrict),
      body: inputs,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: convert.Encoding.getByName("utf-8"),
    );

    if (res.statusCode == 200) {
      return res;
    } else {
      showNetWorkError(context);
      print("network connection " + res.toString());
      return res;
    }
  }

  Future<Response> httpSendOtp(String mobile) async {
    Map<String, Object> inputs = {"Phone": mobile};
    var response = await ApiClientLocalKart().httpPost(inputs, urlSendotpnew);
    return response;
  }

  Future<Response> httpReferralCode(String code) async {
    Map<String, Object> inputs = {"staffCode": code};
    var response = await ApiClientLocalKart().httpPost(
      inputs,
      urlEventReferralVerify,
    );

    return response;
  }

  Future<Response> httpRegister(inputs) async {
    print("url " + urlRegister + " data " + inputs.toString());
    Response res = await post(
      Uri.parse(urlRegister),
      body: inputs,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: convert.Encoding.getByName("utf-8"),
    );

    if (res.statusCode == 200) {
      return res;
    } else {
      showNetWorkError(context);
      print("network connection " + res.toString());
      return res;
    }
  }

  Future<Response> httpDashSlide(String stateId, String distId) async {
    Map<String, Object> inputs = {"stateId": stateId, "districtId": distId};

    print("url $urlDistrict data $inputs");
    Response res = await post(
      Uri.parse(urlDashSlide),
      body: inputs,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: convert.Encoding.getByName("utf-8"),
    );

    print("my res " + res.body.toString());
    if (res.statusCode == 200) {
      return res;
    } else {
      showNetWorkError(context);
      print("network connection " + res.toString());
      return res;
    }
  }

  Future<Response> httpDashSubSlider(
    String stateId,
    String distId,
    String type,
    String cid,
  ) async {
    Map<String, Object> inputs = {
      "stateId": stateId,
      "districtId": distId,
      "type": stateId,
      "categoryId": cid,
    };

    print("url sub $urlSubSlide data $inputs");
    Response res = await post(
      Uri.parse(urlSubSlide),
      body: inputs,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: convert.Encoding.getByName("utf-8"),
    );

    print("my res " + res.body.toString());
    if (res.statusCode == 200) {
      return res;
    } else {
      showNetWorkError(context);
      print("network connection " + res.toString());
      return res;
    }
  }

  Future<Response> httpUserProfile(String userid) async {
    Map<String, Object> inputs = {"userIndexId": userid};

    print("url $urlProfile data $inputs");
    Response res = await post(
      Uri.parse(urlProfile),
      body: inputs,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: convert.Encoding.getByName("utf-8"),
    );

    if (res.statusCode == 200) {
      return res;
    } else {
      showNetWorkError(context);
      print("network connection " + res.toString());
      return res;
    }
  }

  Future<Response> httpReferalDetails(String userid) async {
    Map<String, Object> inputs = {"userIndexId": userid};

    print("url $urlViewReferral data $inputs");
    Response res = await post(
      Uri.parse(urlViewReferral),
      body: inputs,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: convert.Encoding.getByName("utf-8"),
    );

    if (res.statusCode == 200) {
      return res;
    } else {
      showNetWorkError(context);
      print("network connection " + res.toString());
      return res;
    }
  }

  Future<Response> httpUserProfileUpdate(profile) async {
    print("url $urlProfileUpdate data $profile");
    Response res = await post(
      Uri.parse(urlProfileUpdate),
      body: profile,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: convert.Encoding.getByName("utf-8"),
    );

    if (res.statusCode == 200) {
      return res;
    } else {
      showNetWorkError(context);
      print("network connection " + res.toString());
      return res;
    }
  }

  Future<Response> httpurlBuynow(inputs) async {
    print("url $urlBuynow data $inputs");
    Response res = await post(
      Uri.parse(urlBuynow),
      body: inputs,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: convert.Encoding.getByName("utf-8"),
    );
    if (res.statusCode == 200) {
      return res;
    } else {
      showNetWorkError(context);
      print("network connection " + res.toString());
      return res;
    }
  }

  Future<Response> httpurlPaymentSuccess(inputs) async {
    print("url $urlPaymentsuccess data $inputs");
    Response res = await post(
      Uri.parse(urlPaymentsuccess),
      body: inputs,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: convert.Encoding.getByName("utf-8"),
    );
    if (res.statusCode == 200) {
      return res;
    } else {
      showNetWorkError(context);
      print("network connection " + res.toString());
      return res;
    }
  }

  Future<Response> httpDevicesUpdate(input) async {
    print("url $urlDevicesDetails data $input");
    Response res = await post(
      Uri.parse(urlDevicesDetails),
      body: input,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: convert.Encoding.getByName("utf-8"),
    );

    if (res.statusCode == 200) {
      return res;
    } else {
      showNetWorkError(context);
      print("network connection " + res.toString());
      return res;
    }
  }

  Future<Response> httpAppUpdates(input) async {
    print("url $urlAppversion data $input");
    Response res = await post(
      Uri.parse(urlAppversion),
      body: input,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: convert.Encoding.getByName("utf-8"),
    );
    if (res.statusCode == 200) {
      return res;
    } else {
      showNetWorkError(context);
      print("network connection " + res.toString());
      return res;
    }
  }

  Future<Response> httpSubscription(url, input) async {
    print("my url - " + urlServiceTypes + url + " data " + input.toString());
    Response res = await post(
      Uri.parse(urlServiceTypes + url),
      body: input,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: convert.Encoding.getByName("utf-8"),
    );
    if (res.statusCode == 200) {
      return res;
    } else {
      showNetWorkError(context);
      print("network connection " + res.toString());
      return res;
    }
  }

  Future<Response> httpReports(input) async {
    print("my url - " + urlReportsShop + " data " + input.toString());
    Response res = await post(
      Uri.parse(urlReportsShop),
      body: input,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: convert.Encoding.getByName("utf-8"),
    );
    if (res.statusCode == 200) {
      return res;
    } else {
      showNetWorkError(context);
      print("network connection " + res.toString());
      return res;
    }
  }

  showNetWorkError(BuildContext context) {
    Widget yesButton = TextButton(
      child: const Text("Continue"),
      onPressed: () async {
        try {
          Navigator.pop(context);
        } catch (e) {
          print("loading error is " + e.toString());
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Sorry!"),
      content: const Text(
        "The Network connection was lost please try again later.",
      ),
      actions: [yesButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<Response> httpBusinessSave(input) async {
    print("my url - " + urlBusinesssave + " data " + input.toString());
    Response res = await post(
      Uri.parse(urlBusinesssave),
      body: input,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: convert.Encoding.getByName("utf-8"),
    );

    print("my add business - " + res.body.toString());
    if (res.statusCode == 200) {
      return res;
    } else {
      showNetWorkError(context);
      print("network connection " + res.toString());
      return res;
    }
  }

  Future<Response> httpBusinessupdate(input) async {
    print("my url - " + urlBusinessupdate + " data " + input.toString());
    Response res = await post(
      Uri.parse(urlBusinessupdate),
      body: input,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: convert.Encoding.getByName("utf-8"),
    );

    print("profile  updates " + res.body.toString());

    if (res.statusCode == 200) {
      return res;
    } else {
      showNetWorkError(context);
      print("network connection " + res.toString());
      return res;
    }
  }

  Future<Response> httpUploadimage(input) async {
    print("my url - " + urlUploadimage + " data " + input.toString());
    Response res = await post(
      Uri.parse(urlUploadimage),
      body: input,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: convert.Encoding.getByName("utf-8"),
    );
    if (res.statusCode == 200) {
      return res;
    } else {
      showNetWorkError(context);
      print("network connection " + res.toString());
      return res;
    }
  }

  Future<Response> httpViewoffer(input) async {
    print("my url - " + urlViewoffer + " data " + input.toString());
    Response res = await post(
      Uri.parse(urlViewoffer),
      body: input,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: convert.Encoding.getByName("utf-8"),
    );
    if (res.statusCode == 200) {
      return res;
    } else {
      showNetWorkError(context);
      print("network connection " + res.toString());
      return res;
    }
  }



  Future<Response> httpPaysuccess(input) async {
    print("my url - " + urlPaysuccess + " data " + input.toString());
    Response res = await post(
      Uri.parse(urlPaysuccess),
      body: input,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: convert.Encoding.getByName("utf-8"),
    );
    if (res.statusCode == 200) {
      return res;
    } else {
      showNetWorkError(context);
      print("network connection " + res.toString());
      return res;
    }
  }

  Future<Response> httpViewdeals(input) async {
    print("my url - " + urlViewdeals + " data " + input.toString());
    Response res = await post(
      Uri.parse(urlViewdeals),
      body: input,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: convert.Encoding.getByName("utf-8"),
    );
    if (res.statusCode == 200) {
      return res;
    } else {
      showNetWorkError(context);
      print("network connection " + res.toString());
      return res;
    }
  }

  Future<Response> httpAmountcalculation(input) async {
    print("my url - " + urlAmountcalculation + " data " + input.toString());
    Response res = await post(
      Uri.parse(urlAmountcalculation),
      body: input,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: convert.Encoding.getByName("utf-8"),
    );
    if (res.statusCode == 200) {
      return res;
    } else {
      showNetWorkError(context);
      print("network connection " + res.toString());
      return res;
    }
  }

  Future<Response> httpDeletebusinessbanner(input) async {
    print("my url - " + urlDeletebusinessbanner + " data " + input.toString());
    Response res = await post(
      Uri.parse(urlDeletebusinessbanner),
      body: input,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: convert.Encoding.getByName("utf-8"),
    );
    if (res.statusCode == 200) {
      return res;
    } else {
      showNetWorkError(context);
      print("network connection " + res.toString());
      return res;
    }
  }

  Future<Response> getViewmegasalesdeals(input) async {
    print("my url - " + urlViewmegasalesdeals + " data " + input.toString());
    Response res = await post(
      Uri.parse(urlViewmegasalesdeals),
      body: input,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      encoding: convert.Encoding.getByName("utf-8"),
    );
    if (res.statusCode == 200) {
      return res;
    } else {
      showNetWorkError(context);
      print("network connection " + res.toString());
      return res;
    }
  }

  Future<dynamic> getCounts() async {
    String type = await DBHelper().getLoginDB("type");
    var shop_id = await DBHelper().getLoginDB("shopId");
    var response = await post(
      Uri.parse(shopservicedetailcount),
      headers: {
        "Content-Type": "application/json; charset=utf-8",
        // 'Authorization': '$basicAuth',
      },
      body: jsonEncode(<String, dynamic>{
        "shop_service_id": shop_id,
        "shopType": type,
      }),
    );
    return json.decode(response.body);
  }
}
