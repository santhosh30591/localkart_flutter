import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:localkart/Api/api_client.dart';
import 'package:localkart/Api/config.dart';
import 'package:localkart/RoutingSetup/router-constants.dart';
import 'package:localkart/data_base/db_config.dart';
import 'package:localkart/model/bill_pay_model/blanace_confirm_model.dart';
import 'package:localkart/model/bill_pay_model/blanace_fetch_model.dart';
import 'package:localkart/model/bill_pay_model/trans_history_model.dart';
import 'package:localkart/model/bill_pay_model/view_status_details_model.dart';
import 'package:localkart/model/billpay_operater_list.dart';
import 'package:localkart/model/fatch_bill_info_model.dart';
import 'package:localkart/model/home_billpay_list.dart';
import 'package:localkart/unit/showing.dart';

class BillPaymentProvider with ChangeNotifier, DiagnosticableTreeMixin {
  late BuildContext context;

  bool isLoading = false;

  upateContext({required BuildContext contexts}) {
    context = contexts;
  }

  void isUiLoading(isload) {
    isLoading = isload;
    notifyListeners();
  }

  List<OperaterListResults> _operaterLists = [];
  List<OperaterListResults> operaterListFilter = [];

  void clearOperator() {
    _operaterLists = [];
    operaterListFilter = [];
    _operatorImageList = [];
    isLoading = true;
    notifyListeners();
  }

  List<String> _operatorImageList = [];

  List<String> get operatorImageLists => _operatorImageList;

  void getBillPayOpeatorList(
    String category,
    String stateId,
    String cityId,
  ) async {
    var url =
        "$url_fetch_operators?category=$category&stateId=$stateId&districtId=$cityId";
    clearOperator();
    isLoading = true;
    quickPay = [];
    notifyListeners();
    try {
      var responce = await ApiClient(context).httpGet(url);
      var datas = json.decode(responce.body.toString());
      if (datas['errorCode'] != 0) {
        ShowToastdur(context, datas['message']);
      } else {
        var model = OperaterListModel.fromJson(datas);
        _operaterLists.addAll(model.results!);
        _operatorImageList.addAll(model.images!);
      }
      operaterListFilter.addAll(_operaterLists);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print(" operators List encode err - $e");
    }
  }

  void searchStringCatory(String searchText) {
    operaterListFilter.clear();
    if (searchText.length != 0) {
      for (int i = 0; i < _operaterLists.length; i++) {
        if (_operaterLists[i].name.toString().toLowerCase().contains(
          searchText.toLowerCase(),
        )) {
          operaterListFilter.add(_operaterLists[i]);
        }
      }
    } else {
      operaterListFilter.addAll(_operaterLists);
    }
    notifyListeners();
  }

  List<ParamData> paramData = [];

  bool get isAllValid {
    if (paramData.isEmpty) return false;
    return paramData.every((element) => element.isValidate);
  }

  void enterNumbers(String searchText, int index) {
    var item = paramData[index];
    int min = int.tryParse(item.minLength ?? "1") ?? 1;
    int max = int.tryParse(item.maxLength ?? "100") ?? 100;

    if (searchText.length >= min && searchText.length <= max) {
      item.isValidate = true;
    } else {
      item.isValidate = false;
    }

    item.enterValues = searchText;
    notifyListeners();
  }

  void fetchInfo(OperaterListResults result, category) async {
    isLoading = true;
    notifyListeners();

    var userId = await DBHelper().getUserId();

    var url = url_fetch_billinfo;
    Map<String, Object> input = {
      "billerid": result.billerid.toString(),
      "userid": userId,
    };
    try {
      var responce = await ApiClient(context).httpPost(input, url);
      var datas = json.decode(responce.body.toString());
      if (datas['errorCode'] != 0) {
        ShowToastdur(context, datas['message']);
      } else {
        var model = FatchBillInfoModel.fromJson(datas);
        Map<String, Object> inputData = {
          "billerinfo": result,
          "response": model,
          "app_title": category,
        };
        paramData = model.result!.paramData ?? [];
        for (var param in paramData) {
          param.isValidate = false;
          param.enterValues = "";
        }
        Navigator.of(
          context,
        ).pushNamed(root_enter_card_details, arguments: inputData);
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print(" fetchInfo err - $e");
    }
  }

  // featch biller balance details

  List<Info> info = [];
  List<int> quickPay = [];

  void fetchBalanceInfo(
    Map<String, Object> input,
    url,
    FatchBillResult biller_result,
    OperaterListResults operatorDetails,
    String title,
  ) async {
    isLoading = true;
    quickPay = [];
    info = [];
    paymentStatus = 0;
    notifyListeners(); // Critical for UI update
    url = BillPaymentBaseURL + url;
    try {
      var responce = await ApiClient(context).httpPost(input, url);
      var datas = json.decode(responce.body.toString());
      if (datas['errorCode'] != 0) {
        showCommonToast(context, "", datas['message']);
      } else {
        // Handle success

        var model = BalanceFetchModel.fromJson(datas);

        info = model.result!.info!;
        quickPay = model.result!.quickPay!;

        notifyListeners();

        Navigator.pushNamed(
          context,
          root_fetch_balance,
          arguments: {
            'fetch_bill_result': biller_result,
            'operator': operatorDetails,
            'app_title': title,
          },
        );
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print(" fetch balance err - $e");
    }
  }

  var paymentStatus = 0;

  void updatePaymentStatus(int status) {
    paymentStatus = status;
    notifyListeners();
  }

  // billpay history
  List<Results>? results = [];

  void getBillPayHistory(userid) async {
    var url = url_transaction_details + "?userId=" + userid;
    isLoading = true;
    results = [];
    notifyListeners();
    try {
      Map<String, String> data = {"userid": userid};
      var responces = await ApiClient(context).httpGet(url);

      var datas = json.decode(responces.body.toString());
      if (datas['errorCode'] != 0) {
        ShowToastdur(context, "Not Data Found");
      } else {
        var data = TeansHistoryModel.fromJson(datas);
        results = data.results;
        notifyListeners();
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print("getBillPay encode err  - $e");
    }
  }

  // Biller status
  ViewStatusdetailsModel viewStatusdetailsModel = ViewStatusdetailsModel();

  void getBillPayStatus(referrenceid) async {
    var url = url_bill_status;

    viewStatusdetailsModel = ViewStatusdetailsModel();
    isLoading = true;
    notifyListeners();
    try {
      Map<String, String> data = {"referrenceid": referrenceid};
      var responces = await ApiClient(context).httpPost(data, url);

      var datas = json.decode(responces.body.toString());
      if (datas['errorCode'] != 0) {
        ShowToastdur(context, "Not Data Found");
      } else {
        viewStatusdetailsModel = ViewStatusdetailsModel.fromJson(datas);
        notifyListeners();
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print("getBillPay encode err  - $e");
    }
  }
}
