class ServiceDetailsMoreModel {
  int? errorCode;
  String? message;
  Results? result;

  ServiceDetailsMoreModel({this.errorCode, this.message, this.result});

  ServiceDetailsMoreModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    message = json['message'];
    result = json['result'] != null
        ? new Results.fromJson(json['result'])
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

class Results {
  String? shopName;
  String? shopLogo;
  String? shopDesc;
  String? shopPhone;
  String? shopMobile;
  String? shopWhatsapp;
  String? shopEmail;
  String? shopWebsite;
  String? distance;
  String? shopLatitude;
  String? shopLongitude;
  String? shopDoorNo;
  String? shopArea;
  String? shopLocality;
  String? shopLandmark;
  String? shopPost;
  String? shopState;
  String? shopDistrict;
  String? shopPincode;
  List<ShopServiceList>? shopServiceList;
  List<ShopImageList>? shopImageList;
  List<AccessOptions>? accessOptions;
  String? shareUrl;
  String? viewCount;
  String? averageRating;

  Results({
    this.shopName,
    this.shopLogo,
    this.shopDesc,
    this.shopPhone,
    this.shopMobile,
    this.shopWhatsapp,
    this.shopEmail,
    this.shopWebsite,
    this.distance,
    this.shopLatitude,
    this.shopLongitude,
    this.shopDoorNo,
    this.shopArea,
    this.shopLocality,
    this.shopLandmark,
    this.shopPost,
    this.shopState,
    this.shopDistrict,
    this.shopPincode,
    this.shopServiceList,
    this.shopImageList,
    this.accessOptions,
    this.shareUrl,
    this.viewCount,
    this.averageRating,
  });

  Results.fromJson(Map<String, dynamic> json) {
    shopName = json['shopName'];
    shopLogo = json['shopLogo'];
    shopDesc = json['shopDesc'];
    shopPhone = json['shopPhone'];
    shopMobile = json['shopMobile'];
    shopWhatsapp = json['shopWhatsapp'];
    shopEmail = json['shopEmail'];
    shopWebsite = json['shopWebsite'];
    distance = json['distance'];
    shopLatitude = json['shopLatitude'];
    shopLongitude = json['shopLongitude'];
    shopDoorNo = json['shopDoorNo'];
    shopArea = json['shopArea'];
    shopLocality = json['shopLocality'];
    shopLandmark = json['shopLandmark'];
    shopPost = json['shopPost'];
    shopState = json['shopState'];
    shopDistrict = json['shopDistrict'];
    shopPincode = json['shopPincode'];
    viewCount = json['viewCount'];
    averageRating = json['averageRating'];
    if (json['shopServiceList'] != null) {
      shopServiceList = <ShopServiceList>[];
      json['shopServiceList'].forEach((v) {
        shopServiceList!.add(new ShopServiceList.fromJson(v));
      });
    }
    if (json['shopImageList'] != null) {
      shopImageList = <ShopImageList>[];
      json['shopImageList'].forEach((v) {
        shopImageList!.add(new ShopImageList.fromJson(v));
      });
    }
    if (json['accessOptions'] != null) {
      accessOptions = <AccessOptions>[];
      json['accessOptions'].forEach((v) {
        accessOptions!.add(new AccessOptions.fromJson(v));
      });
    }
    shareUrl = json['shareUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shopName'] = this.shopName;
    data['shopLogo'] = this.shopLogo;
    data['shopDesc'] = this.shopDesc;
    data['shopPhone'] = this.shopPhone;
    data['shopMobile'] = this.shopMobile;
    data['shopWhatsapp'] = this.shopWhatsapp;
    data['shopEmail'] = this.shopEmail;
    data['shopWebsite'] = this.shopWebsite;
    data['distance'] = this.distance;
    data['shopLatitude'] = this.shopLatitude;
    data['shopLongitude'] = this.shopLongitude;
    data['shopDoorNo'] = this.shopDoorNo;
    data['shopArea'] = this.shopArea;
    data['shopLocality'] = this.shopLocality;
    data['shopLandmark'] = this.shopLandmark;
    data['shopPost'] = this.shopPost;
    data['shopState'] = this.shopState;
    data['shopDistrict'] = this.shopDistrict;
    data['shopPincode'] = this.shopPincode;
    data['viewCount'] = this.viewCount;
    data['averageRating'] = this.averageRating;

    if (this.shopServiceList != null) {
      data['shopServiceList'] = this.shopServiceList!
          .map((v) => v.toJson())
          .toList();
    }
    if (this.shopImageList != null) {
      data['shopImageList'] = this.shopImageList!
          .map((v) => v.toJson())
          .toList();
    }
    if (this.accessOptions != null) {
      data['accessOptions'] = this.accessOptions!
          .map((v) => v.toJson())
          .toList();
    }
    data['shareUrl'] = this.shareUrl;
    return data;
  }
}

class ShopServiceList {
  String? serviceName;

  ShopServiceList({this.serviceName});

  ShopServiceList.fromJson(Map<String, dynamic> json) {
    serviceName = json['serviceName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serviceName'] = this.serviceName;
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

class AccessOptions {
  String? keyName;
  String? value;

  AccessOptions({this.keyName, this.value});

  AccessOptions.fromJson(Map<String, dynamic> json) {
    keyName = json['keyName'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['keyName'] = this.keyName;
    data['value'] = this.value;
    return data;
  }
}
