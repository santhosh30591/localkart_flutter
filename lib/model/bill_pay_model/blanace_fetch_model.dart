import 'package:localkart/model/common_response.dart';

class BalanceFetchModel {
  int? errorCode;
  String? message;
  BalanceResult? result;

  BalanceFetchModel({this.errorCode, this.message, this.result});

  BalanceFetchModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    message = json['message'];
    result = json['result'] != null
        ? new BalanceResult.fromJson(json['result'])
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

class BalanceResult {
  String? number;
  String? billerid;
  String? billerAdhoc;
  String? requestId;
  List<Info>? info;
  List<int>? quickPay;

  BalanceResult({
    this.number,
    this.billerid,
    this.billerAdhoc,
    this.requestId,
    this.info,
    this.quickPay,
  });

  BalanceResult.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    billerid = json['billerid'];
    billerAdhoc = json['billerAdhoc'];
    requestId = json['request_id'];
    if (json['info'] != null) {
      info = <Info>[];
      json['info'].forEach((v) {
        info!.add(new Info.fromJson(v));
      });
    }
    quickPay = json['quickPay'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['billerid'] = this.billerid;
    data['billerAdhoc'] = this.billerAdhoc;
    data['request_id'] = this.requestId;
    if (this.info != null) {
      data['info'] = this.info!.map((v) => v.toJson()).toList();
    }
    data['quickPay'] = this.quickPay;
    return data;
  }
}

class Info {
  String? key;
  String? value;

  Info({this.key, this.value});

  Info.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    return data;
  }
}
