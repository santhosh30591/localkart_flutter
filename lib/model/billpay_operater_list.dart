import 'package:localkart/model/common_response.dart';

class OperaterListModel implements CommonResponse {
  List<OperaterListResults>? results;
  List<String>? images;

  OperaterListModel({errorCode, message, this.results});

  OperaterListModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    message = json['message'];
    images = json['images'].cast<String>();
    if (json['results'] != null) {
      results = <OperaterListResults>[];
      json['results'].forEach((v) {
        results!.add(new OperaterListResults.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['message'] = this.message;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    data['images'] = this.images;
    return data;
  }

  @override
  int? errorCode;

  @override
  String? message;
}

class OperaterListResults {
  String? billerid;
  String? name;
  String? icon;

  OperaterListResults({this.billerid, this.name, this.icon});

  OperaterListResults.fromJson(Map<String, dynamic> json) {
    billerid = json['billerid'];
    name = json['name'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['billerid'] = this.billerid;
    data['name'] = this.name;
    data['icon'] = this.icon;
    return data;
  }
}
