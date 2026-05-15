class TodayServiceListModel {
  int? errorCode;
  String? message;
  List<Result>? result;

  TodayServiceListModel({this.errorCode, this.message, this.result});

  TodayServiceListModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    message = json['message'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
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
  String? name;
  String? logo;
  String? distance;
  int? distanceInt;
  AccessOptions? accessOptions;
  String? description;
  int? postIndexId;
  String? fromDate;
  String? toDate;
  String? count;
  String? shopIndexId;
  String? type;
  String? latitude;
  String? longitude;
  int? isSubscribed;
  String? offerHeading;
  String? offerDescription;
  String? viewCount;

  Result(
      {this.name,
      this.logo,
      this.distance,
      this.distanceInt,
      this.accessOptions,
      this.description,
      this.postIndexId,
      this.fromDate,
      this.toDate,
      this.count,
      this.shopIndexId,
      this.type,
      this.latitude,
      this.longitude,
      this.isSubscribed,
      this.offerHeading,
      this.offerDescription,
      this.viewCount});

  Result.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    logo = json['logo'];
    distance = json['distance'];
    distanceInt = json['distanceInt'];
    accessOptions = json['accessOptions'] != null
        ? new AccessOptions.fromJson(json['accessOptions'])
        : null;
    description = json['description'];
    postIndexId = json['postIndexId'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    count = json['count'];
    shopIndexId = json['shopIndexId'];
    type = json['type'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isSubscribed = json['isSubscribed'];
    offerHeading = json['offerHeading'];
    offerDescription = json['offerDescription'];
    viewCount = json['viewCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['logo'] = this.logo;
    data['distance'] = this.distance;
    data['distanceInt'] = this.distanceInt;
    if (this.accessOptions != null) {
      data['accessOptions'] = this.accessOptions!.toJson();
    }
    data['description'] = this.description;
    data['postIndexId'] = this.postIndexId;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['count'] = this.count;
    data['shopIndexId'] = this.shopIndexId;
    data['type'] = this.type;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['isSubscribed'] = this.isSubscribed;
    data['offerHeading'] = this.offerHeading;
    data['offerDescription'] = this.offerDescription;
    data['viewCount'] = this.viewCount;
    return data;
  }
}

class AccessOptions {
  String? key;
  String? value;

  AccessOptions({this.key, this.value});

  AccessOptions.fromJson(Map<String, dynamic> json) {
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
