class AdsHistoryModel {
  int? errorCode;
  String? message;
  List<Result>? result;

  AdsHistoryModel({this.errorCode, this.message, this.result});

  AdsHistoryModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    message = json['message'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        // result!.add(new Result.fromJson(v));
        result!.insert(0, Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  int? postIndexId;
  String? postDate;
  String? postCode;
  String? type;
  String? heading;
  String? count;
  String? shopType;
  dynamic? shopIndexId;
  String? shopLatitude;
  String? shopLongitude;
  String? status;
  dynamic? viewCount;

  Result(
      {this.postIndexId,
      this.postDate,
      this.postCode,
      this.type,
      this.heading,
      this.count,
      this.shopType,
      this.shopIndexId,
      this.shopLatitude,
      this.shopLongitude,
      this.status,
      this.viewCount});

  Result.fromJson(Map<String, dynamic> json) {
    postIndexId = json['postIndexId'];
    postDate = json['postDate'];
    postCode = json['postCode'];
    type = json['type'];
    heading = json['heading'];
    count = json['count'];
    shopType = json['shopType'];
    shopIndexId = json['shopIndexId'];
    shopLatitude = json['shopLatitude'];
    shopLongitude = json['shopLongitude'];
    status = json['Status'];
    viewCount = json['viewCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postIndexId'] = this.postIndexId;
    data['postDate'] = this.postDate;
    data['postCode'] = this.postCode;
    data['type'] = this.type;
    data['heading'] = this.heading;
    data['count'] = this.count;
    data['shopType'] = this.shopType;
    data['shopIndexId'] = this.shopIndexId;
    data['shopLatitude'] = this.shopLatitude;
    data['shopLongitude'] = this.shopLongitude;
    data['Status'] = this.status;
    data['viewCount'] = this.viewCount;
    return data;
  }
}
