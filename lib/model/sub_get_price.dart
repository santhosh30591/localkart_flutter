class GetPriceListModel {
  int? errorCode;
  String? message;
  List<Result>? result;
  List<Description>? description;
  String? isSubscribed;

  GetPriceListModel(
      {this.errorCode,
      this.message,
      this.result,
      this.description,
      this.isSubscribed});

  GetPriceListModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    message = json['message'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
    if (json['description'] != null) {
      description = <Description>[];
      json['description'].forEach((v) {
        description!.add(new Description.fromJson(v));
      });
    }
    isSubscribed = json['isSubscribed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    if (this.description != null) {
      data['description'] = this.description!.map((v) => v.toJson()).toList();
    }
    data['isSubscribed'] = this.isSubscribed;
    return data;
  }
}

class Result {
  String? planId;
  String? planName;
  String? planValidity;
  String? planPrice;
  String? isCurrentPlan;

  Result(
      {this.planId,
      this.planName,
      this.planValidity,
      this.planPrice,
      this.isCurrentPlan});

  Result.fromJson(Map<String, dynamic> json) {
    planId = json['planId'];
    planName = json['planName'];
    planValidity = json['planValidity'];
    planPrice = json['planPrice'];
    isCurrentPlan = json['isCurrentPlan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['planId'] = this.planId;
    data['planName'] = this.planName;
    data['planValidity'] = this.planValidity;
    data['planPrice'] = this.planPrice;
    data['isCurrentPlan'] = this.isCurrentPlan;
    return data;
  }
}

class Description {
  String? key;
  String? value;

  Description({this.key, this.value});

  Description.fromJson(Map<String, dynamic> json) {
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
