class AiDirectoryModel {
  int? errorCode;
  String? message;
  List<Result>? result;

  AiDirectoryModel({this.errorCode, this.message, this.result});

  AiDirectoryModel.fromJson(Map<String, dynamic> json) {
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
  String? call;
  String? address;

  String? description;
  dynamic shopIndexId;
  String? type;
  String? latitude;
  String? longitude;
  int? isSubscribed;
  String? isVerify;

  Result({
    this.name,
    this.call,
    this.address,
    this.description,
    this.shopIndexId,
    this.type,
    this.latitude,
    this.longitude,
    this.isSubscribed,
    this.isVerify,
  });

  Result.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    call = json['Call'];
    address = json['address'];
    description = json['description'];
    shopIndexId = json['shopIndexId'];
    type = json['type'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isSubscribed = json['isSubscribed'];
    isVerify = json['isVerify'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['Call'] = this.call;
    data['description'] = this.description;
    data['shopIndexId'] = this.shopIndexId;
    data['type'] = this.type;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['isSubscribed'] = this.isSubscribed;
    return data;
  }
}
