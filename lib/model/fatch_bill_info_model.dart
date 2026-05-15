import 'package:localkart/model/common_response.dart';

class FatchBillInfoModel {
  int? errorCode;
  String? message;
  FatchBillResult? result;

  FatchBillInfoModel({this.errorCode, this.message, this.result});

  FatchBillInfoModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    message = json['message'];
    result = json['result'] != null
        ? new FatchBillResult.fromJson(json['result'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class FatchBillResult {
  String? billername;
  String? adhoc;
  String? fetchrequiment;
  List<ParamData>? paramData;

  FatchBillResult({
    this.billername,
    this.adhoc,
    this.fetchrequiment,
    this.paramData,
  });

  FatchBillResult.fromJson(Map<String, dynamic> json) {
    billername = json['billername'];
    adhoc = json['adhoc'];
    fetchrequiment = json['fetchrequiment'];
    if (json['param_data'] != null) {
      paramData = <ParamData>[];
      json['param_data'].forEach((v) {
        paramData!.add(new ParamData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['billername'] = this.billername;
    data['adhoc'] = this.adhoc;
    data['fetchrequiment'] = this.fetchrequiment;
    if (this.paramData != null) {
      data['param_data'] = this.paramData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ParamData {
  String? labelName;
  String? inputName;
  String? inputType;
  String? minLength;
  String? maxLength;
  String? minAmount;
  String? maxAmount;
  int? partPayment;
  bool isValidate = false;
  String enterValues = "";

  ParamData({
    this.labelName,
    this.inputName,
    this.inputType,
    this.minLength,
    this.maxLength,
    this.minAmount,
    this.maxAmount,
    this.partPayment,
  });

  ParamData.fromJson(Map<String, dynamic> json) {
    labelName = json['labelName'];
    inputName = json['inputName'];
    inputType = json['inputType'];
    minLength = json['minLength'];
    maxLength = json['maxLength'];
    minAmount = json['minAmount'];
    maxAmount = json['maxAmount'];
    partPayment = json['partPayment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['labelName'] = this.labelName;
    data['inputName'] = this.inputName;
    data['inputType'] = this.inputType;
    data['minLength'] = this.minLength;
    data['maxLength'] = this.maxLength;
    data['minAmount'] = this.minAmount;
    data['maxAmount'] = this.maxAmount;
    data['partPayment'] = this.partPayment;
    return data;
  }
}
