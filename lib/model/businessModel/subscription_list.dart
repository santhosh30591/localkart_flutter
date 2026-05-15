class SubscriptionListModel {
  int? errorCode;
  String? message;
  Result? result;

  SubscriptionListModel({this.errorCode, this.message, this.result});

  SubscriptionListModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    message = json['message'];
    result = json['result'] != null
        ? new Result.fromJson(json['result'])
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

class Result {
  List<Free>? free;
  List<Free>? dhamaka;
  List<Free>? doubleDhamaka;
  List<Free>? dhoolDhamaka;

  Result({this.free, this.dhamaka, this.doubleDhamaka, this.dhoolDhamaka});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['Free'] != null) {
      free = <Free>[];
      json['Free'].forEach((v) {
        free!.add(new Free.fromJson(v));
      });
    }
    if (json['Dhamaka'] != null) {
      dhamaka = <Free>[];
      json['Dhamaka'].forEach((v) {
        dhamaka!.add(new Free.fromJson(v));
      });
    }
    if (json['Double Dhamaka'] != null) {
      doubleDhamaka = <Free>[];
      json['Double Dhamaka'].forEach((v) {
        doubleDhamaka!.add(new Free.fromJson(v));
      });
    }
    if (json['Dhool Dhamaka'] != null) {
      dhoolDhamaka = <Free>[];
      json['Dhool Dhamaka'].forEach((v) {
        dhoolDhamaka!.add(new Free.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.free != null) {
      data['Free'] = this.free!.map((v) => v.toJson()).toList();
    }
    if (this.dhamaka != null) {
      data['Dhamaka'] = this.dhamaka!.map((v) => v.toJson()).toList();
    }
    if (this.doubleDhamaka != null) {
      data['Double Dhamaka'] = this.doubleDhamaka!
          .map((v) => v.toJson())
          .toList();
    }
    if (this.dhoolDhamaka != null) {
      data['Dhool Dhamaka'] = this.dhoolDhamaka!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class Free {
  String? price;
  String? validity;
  Benifits? benifits;

  Free({this.price, this.validity, this.benifits});

  Free.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    validity = json['validity'];
    benifits = json['benifits'] != null
        ? new Benifits.fromJson(json['benifits'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['validity'] = this.validity;
    if (this.benifits != null) {
      data['benifits'] = this.benifits!.toJson();
    }
    return data;
  }
}

class Benifits {
  String? directoryListing;
  String? weeklyPost;
  String? dailyPost;
  String? festivalPost;
  String? offerList;
  String? appNotification;
  String? googleMap;
  String? accessOptions;
  String? profileImage;
  String? boostAd;
  String? digitalVCard;
  String? validity;
  String? price;

  Benifits({
    this.directoryListing,
    this.weeklyPost,
    this.dailyPost,
    this.festivalPost,
    this.offerList,
    this.appNotification,
    this.googleMap,
    this.accessOptions,
    this.profileImage,
    this.boostAd,
    this.digitalVCard,
    this.validity,
    this.price,
  });

  Benifits.fromJson(Map<String, dynamic> json) {
    directoryListing = json['Directory Listing'];
    weeklyPost = json['Weekly Post'];
    dailyPost = json['Daily Post'];
    festivalPost = json['Festival Post'];
    offerList = json['Offer List'];
    appNotification = json['App Notification'];
    googleMap = json['Google Map'];
    accessOptions = json['Access Options'];
    profileImage = json['Profile Image'];
    boostAd = json['Boost Ad'];
    digitalVCard = json['Digital vCard'];
    validity = json['Validity'];
    price = json['Price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Directory Listing'] = this.directoryListing;
    data['Weekly Post'] = this.weeklyPost;
    data['Daily Post'] = this.dailyPost;
    data['Festival Post'] = this.festivalPost;
    data['Offer List'] = this.offerList;
    data['App Notification'] = this.appNotification;
    data['Google Map'] = this.googleMap;
    data['Access Options'] = this.accessOptions;
    data['Profile Image'] = this.profileImage;
    data['Boost Ad'] = this.boostAd;
    data['Digital vCard'] = this.digitalVCard;
    data['Validity'] = this.validity;
    data['Price'] = this.price;
    return data;
  }
}

class PlanModebottomModel {
  int? errorCode;
  String? message;
  ResultMore? result;

  PlanModebottomModel({this.errorCode, this.message, this.result});

  PlanModebottomModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    message = json['message'];
    result = json['result'] != null
        ? new ResultMore.fromJson(json['result'])
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

class ResultMore {
  String? dailyTotalCount;
  String? weeklyTotalCount;
  String? festivalTotalCount;
  String? dealsTotalCount;
  List<OthersList>? othersList;
  String? packageName;

  ResultMore({
    this.dailyTotalCount,
    this.weeklyTotalCount,
    this.festivalTotalCount,
    this.dealsTotalCount,
    this.othersList,
    this.packageName,
  });

  ResultMore.fromJson(Map<String, dynamic> json) {
    dailyTotalCount = json['dailyTotalCount'];
    weeklyTotalCount = json['weeklyTotalCount'];
    festivalTotalCount = json['festivalTotalCount'];
    dealsTotalCount = json['dealsTotalCount'];
    if (json['othersList'] != null) {
      othersList = <OthersList>[];
      json['othersList'].forEach((v) {
        othersList!.add(new OthersList.fromJson(v));
      });
    }
    packageName = json['packageName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dailyTotalCount'] = this.dailyTotalCount;
    data['weeklyTotalCount'] = this.weeklyTotalCount;
    data['festivalTotalCount'] = this.festivalTotalCount;
    data['dealsTotalCount'] = this.dealsTotalCount;
    if (this.othersList != null) {
      data['othersList'] = this.othersList!.map((v) => v.toJson()).toList();
    }
    data['packageName'] = this.packageName;
    return data;
  }
}

class OthersList {
  String? keyName;
  String? value;

  OthersList({this.keyName, this.value});

  OthersList.fromJson(Map<String, dynamic> json) {
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
