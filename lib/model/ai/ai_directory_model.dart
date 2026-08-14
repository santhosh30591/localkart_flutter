class AiDirectoryModel {
  int? errorCode;
  String? message;
  List<ResultMore>? result;
  List<ResultMore>? resut_array;

  AiDirectoryModel({
    this.errorCode,
    this.message,
    this.result,
    this.resut_array,
  });

  AiDirectoryModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    message = json['message'];
    if (json['result'] != null) {
      result = <ResultMore>[];
      json['result'].forEach((v) {
        result!.add(new ResultMore.fromJson(v));
      });
    }
    if (json['resut_array'] != null) {
      result = <ResultMore>[];
      json['resut_array'].forEach((v) {
        result!.add(new ResultMore.fromJson(v));
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

class ResultMore {
  String? name;
  String? call;
  String? address;
  String? logo;

  String? description;
  dynamic shopIndexId;
  dynamic phone;
  dynamic offerHeading;
  dynamic postIndexId;
  String? type;
  String? latitude;
  String? longitude;
  int? isSubscribed;
  String? isVerify;

  ResultMore({
    this.name,
    this.call,
    this.logo,
    this.address,
    this.description,
    this.phone,
    this.offerHeading,
    this.shopIndexId,
    this.postIndexId,
    this.type,
    this.latitude,
    this.longitude,
    this.isSubscribed,
    this.isVerify,
  });

  ResultMore.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    call = json['Call'];
    logo = json['logo'];
    address = json['address'];
    description = json['description'];
    shopIndexId = json['shopIndexId'];
    offerHeading = json['offerHeading'];
    postIndexId = json['postIndexId'];
    phone = json['phone'];
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
