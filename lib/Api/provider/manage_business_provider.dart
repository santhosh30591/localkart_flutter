import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/model/dashboard/manage_business_model.dart';
import 'package:localkart/model/dashboard/shop_services_model.dart';
import 'package:localkart/model/dashboard_model.dart';
import 'package:localkart/model/home_billpay_list.dart';
import 'package:localkart/unit/showing.dart';

class ManageBusinessProvider with ChangeNotifier, DiagnosticableTreeMixin {
  late BuildContext context;

  bool isLoading = false;

  updateContext({required BuildContext contexts}) {
    context = contexts;
  }

  ManageBusinessModel manageBusinessModel1 = ManageBusinessModel();
  BusinessLeadsModel businessLeadsModel = BusinessLeadsModel();

  void getScrber(params) async {
    var url = subscriber_info;
    isLoading = true;
    notifyListeners();
    try {
      var responces = await ApiClient(context).httpPost(params, url);
      var datas = json.decode(responces.body.toString());
      manageBusinessModel1 = ManageBusinessModel.fromJson(datas);

      print("message  " + manageBusinessModel1.message!!);
      if (datas['errorCode'] != 0) {
        ShowToastdur(context, manageBusinessModel1.message!!);
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      print("ApiClient encode err  - $e");
      isLoading = false;
      notifyListeners();
    }
    isLoading = false;
    notifyListeners();
  }

  void getLead(params) async {
    var url = customer_leads;
    isLoading = true;
    notifyListeners();
    try {
      var responces = await ApiClient(context).httpPost(params, url);
      var datas = json.decode(responces.body.toString());
      businessLeadsModel = BusinessLeadsModel.fromJson(datas);

      if (datas['errorCode'] != 0) {
        ShowToastdur(context, businessLeadsModel.message!!);
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      print("ApiClient encode err  - $e");
      isLoading = false;
      notifyListeners();
    }
    isLoading = false;
    notifyListeners();
  }
}
