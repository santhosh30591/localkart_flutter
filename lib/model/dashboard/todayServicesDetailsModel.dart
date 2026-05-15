class TodayServiceMoreModel {
  int? errorCode;
  String? message;
  Result? result;

  TodayServiceMoreModel({this.errorCode, this.message, this.result});

  TodayServiceMoreModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    message = json['message'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
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

class Result {
  String? shopName;
  List<ShopImageList>? shopImageList;
  String? fromDate;
  String? toDate;
  String? distance;
  List<ShopOfferList>? shopOfferList;
  AccessOptions? accessOptions;

  Result(
      {this.shopName,
      this.shopImageList,
      this.fromDate,
      this.toDate,
      this.distance,
      this.shopOfferList,
      this.accessOptions});

  Result.fromJson(Map<String, dynamic> json) {
    shopName = json['shopName'];
    if (json['shopImageList'] != null) {
      shopImageList = <ShopImageList>[];
      json['shopImageList'].forEach((v) {
        shopImageList!.add(new ShopImageList.fromJson(v));
      });
    }
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    distance = json['distance'];
    if (json['shopOfferList'] != null) {
      shopOfferList = <ShopOfferList>[];
      json['shopOfferList'].forEach((v) {
        shopOfferList!.add(new ShopOfferList.fromJson(v));
      });
    }
    accessOptions = json['accessOptions'] != null
        ? new AccessOptions.fromJson(json['accessOptions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shopName'] = this.shopName;
    if (this.shopImageList != null) {
      data['shopImageList'] =
          this.shopImageList!.map((v) => v.toJson()).toList();
    }
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['distance'] = this.distance;
    if (this.shopOfferList != null) {
      data['shopOfferList'] =
          this.shopOfferList!.map((v) => v.toJson()).toList();
    }
    if (this.accessOptions != null) {
      data['accessOptions'] = this.accessOptions!.toJson();
    }
    return data;
  }
}

class ShopImageList {
  String? imageUrl;

  ShopImageList({this.imageUrl});

  ShopImageList.fromJson(Map<String, dynamic> json) {
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}

class ShopOfferList {
  String? heading;
  String? description;
  String? offerImage;

  ShopOfferList({this.heading, this.description, this.offerImage});

  ShopOfferList.fromJson(Map<String, dynamic> json) {
    heading = json['heading'];
    description = json['description'];
    offerImage = json['offerImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['heading'] = this.heading;
    data['description'] = this.description;
    data['offerImage'] = this.offerImage;
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
