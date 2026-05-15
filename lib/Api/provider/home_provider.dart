import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/dashboard/shop_services_model.dart';
import 'package:localkart/model/dashboard_model.dart';
import 'package:localkart/model/home_billpay_list.dart';
import 'package:localkart/unit/showing.dart';

class HomePageProvider with ChangeNotifier, DiagnosticableTreeMixin {
  late BuildContext context;

  bool isLoading = false;

  updateContext({required BuildContext contexts}) {
    context = contexts;
  }

  List<BillPayData> _billPayDataList = [];

  List<BillPayData> get billPayDataList => _billPayDataList;

  void getBillPay() async {
    var url = urlBillpayList;
    isLoading = true;
    notifyListeners();

    try {
      var responces = await ApiClient(context).httpGet(url);
      var datas = json.decode(responces.body.toString());

      if (datas['errorCode'] != 0) {
        ShowToastdur(context, "Not Data Found");
      } else {
        var model = HomeBillPayModel.fromJson(datas);
        _billPayDataList.clear();
        for (int i = 0; i < model.results!.length; i++) {
          try {
            var data = model.results![i].data!;
            for (int j = 0; j < data.length; j++) {
              _billPayDataList.add(data[j]);
            }
          } catch (e) {
            print("for loop error encode err  - $e");
          }
        }
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print("getBillPay encode err  - $e");
    }
  }

  List<ShopServicesCategoryModel> shoppingList = [];

  List<ShopServicesCategoryModel> servicesList = [];

  void getShopServices(bool isServices) async {
    var url = urlShoppingCategories;
    if (isServices) {
      url = urlServiceCategories;
    }
    isLoading = true;
    notifyListeners();

    try {
      var responces = await ApiClient(context).httpGet(url);
      var datas = json.decode(responces.body.toString());

      if (datas['errorCode'] != 0) {
        ShowToastdur(context, "Not Data Found");
      } else {
        var model = ShopServicesModel.fromJson(datas);
        if (isServices) {
          servicesList.clear();
          servicesList.addAll(model.result!);
        } else {
          shoppingList.clear();
          shoppingList.addAll(model.result!);
        }
      }
    } catch (e) {
      print("getShopServices encode err  - $e");
    }
    isLoading = false;
    notifyListeners();
  }

  DashboardModel dashboardModel = DashboardModel();

  void getDashboard(userIndexId, stateId, districtId) async {
    var url = url_dashboard;
    isLoading = true;
    notifyListeners();

    Map<String, Object> input = {
      "userIndexId": userIndexId,
      "stateId": stateId,
      "districtId": districtId,
    };

    try {
      var responces = await ApiClient(context).httpPost(input, url);
      var datas = json.decode(responces.body.toString());

      if (datas['errorCode'] != 0) {
        ShowToastdur(context, "Not Data Found");
      } else {
        dashboardModel = DashboardModel.fromJson(datas);

        if (dashboardModel.services!.length < 2) {
        } else {
          dashboardModel.services!.add(Shopping(name: "More"));
        }
        if (dashboardModel.shopping!.length < 2) {
        } else {
          dashboardModel.shopping!.add(Shopping(name: "More"));
        }
        if (dashboardModel.billpayment!.length < 2) {
        } else {
          dashboardModel.billpayment!.add(Billpayment(name: "More"));
        }
        if (dashboardModel.events!.length < 2) {
        } else {
          dashboardModel.events!.add(Events(eventname: "More"));
        }
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print("ApiClient encode err  - $e");
      isLoading = false;
      notifyListeners();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> printIps() async {}

  void getUpdateDetvices(onesignalId) async {
    var url = url_Updatedeviceid;
    var ipaddress = "0.0.0.0";
    var details = "testing";

    var userIndexId = await DBHelper().getLoginSubDB('Id');
    var osType = "OS";
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      osType = "android";

      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      details = "Manufacturer Name-${androidInfo.manufacturer}";
      details = details + ", ${androidInfo.model}";
      details = details + ", ${androidInfo.id}";
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      details = "Manufacturer Name- ${iosInfo.utsname.machine}";
      details = details + ", ${iosInfo.systemName}";
      details = details + ",${iosInfo.identifierForVendor}";
      osType = "Ios";
    }

    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        print("${interface.name} : ${addr.address}");

        details =
            "$details, Network Interface : ${interface.name} : ${addr.address}";

        ipaddress = addr.address;
      }
    }

    Map<String, Object> input = {
      "userIndexId": userIndexId,
      "deviceId": onesignalId,
      "OSType": osType,
      "deviceDetails": details,
      "ipAddress": ipaddress,
    };

    try {
      await ApiClient(context).httpPost(input, url);
    } catch (e) {
      print("ApiClient encode err  - $e");
    }
    isLoading = false;
    notifyListeners();
  }

  List<Events> events = [];

  void getDashboardEvent(
    userIndexId,
    stateId,
    districtId,
    lat,
    long,
    int selectEventFilter,
  ) async {
    Map<String, Object> input = {
      // "userIndexId": userIndexId,
      "state": stateId,
      "city": districtId,
      "latitude": lat,
      "longitude": long,
    };

    if (selectEventFilter == 2) {
      input = {
        // "userIndexId": userIndexId,
        "state": stateId,
        "city": districtId,
        "latitude": lat,
        "longitude": long,
        "filter": "future",
      };
    } else if (selectEventFilter == 3) {
      input = {
        // "userIndexId": userIndexId,
        "state": stateId,
        "city": districtId,
        "latitude": lat,
        "longitude": long,
        "filter": "past",
      };
    }

    final uri = Uri.https(BaseURL, customereventlist, input);

    isLoading = true;
    notifyListeners();

    try {
      var responces = await ApiClient(context).httpGet(uri.toString());
      var datas = json.decode(responces.body.toString());

      if (datas['errorCode'] != 0) {
        ShowToastdur(context, "Not Data Found");
      } else {
        EventListModel dashboardModel = EventListModel.fromJson(datas);
        isLoading = false;
        events.clear();
        events.addAll(dashboardModel.events!);
        notifyListeners();
        print(
          "ApiClient encode event list  - " +
              dashboardModel.events!.length.toString(),
        );
      }
    } catch (e) {
      print("ApiClient encode errs  - $e");
      isLoading = false;
      notifyListeners();
    }
    isLoading = false;
    notifyListeners();
  }
}
