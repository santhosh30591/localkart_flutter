import 'package:localkart/model/common_response.dart';

class BlanaceConfirmResponseModel {
  int? errorCode=10;
  String? message;
  String? referrenceid;
  int? allow_pg;
  String? sdk_url;

  BlanaceConfirmResponseModel({
    this.errorCode,
    this.message,
    this.referrenceid,
    this.allow_pg,
    this.sdk_url,
  });

  BlanaceConfirmResponseModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    message = json['message'];
    referrenceid = json['referrenceid'];
    allow_pg = json['allow_pg'];
    sdk_url = json['sdk_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['message'] = this.message;
    data['referrenceid'] = this.referrenceid;
    data['allow_pg'] = this.allow_pg;
    data['sdk_url'] = this.sdk_url;
    return data;
  }
}
