class RewardsRedemtionsModel {
  int? errorCode;
  String? message;
  List<Result>? result;

  RewardsRedemtionsModel({this.errorCode, this.message, this.result});

  RewardsRedemtionsModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    message = json['Message'];
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
    data['Message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? name;
  String? offerCode;
  String? mobile;
  String? city;
  String? redemptionDate;
  String? distributedDate;

  Result(
      {this.name,
        this.offerCode,
        this.mobile,
        this.city,
        this.redemptionDate,
        this.distributedDate});

  Result.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    offerCode = json['offer_code'];
    mobile = json['mobile'];
    city = json['city'];
    redemptionDate = json['redemption_date'];
    distributedDate = json['distributed_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['offer_code'] = this.offerCode;
    data['mobile'] = this.mobile;
    data['city'] = this.city;
    data['redemption_date'] = this.redemptionDate;
    data['distributed_date'] = this.distributedDate;
    return data;
  }
}