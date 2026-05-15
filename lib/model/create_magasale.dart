class MagaSaleCreateModel {
  int? errorCode;
  String? message;
  List<Result>? result;

  MagaSaleCreateModel({this.errorCode, this.message, this.result});

  MagaSaleCreateModel.fromJson(Map<String, dynamic> json) {
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
  int? megaSalesIndexId;
  String? offerTitle;
  String? totalDeals;
  String? fromDate;
  String? toDate;
  String? allowFrom;
  String? icon;
  int? showMenu;
  int? isAllow;
  String? errorMessage;
  int? isAlready;
  String? alreadyMessage;
  String? fDate;
  String? tDate;

  Result(
      {this.megaSalesIndexId,
      this.offerTitle,
      this.totalDeals,
      this.fromDate,
      this.toDate,
      this.allowFrom,
      this.icon,
      this.showMenu,
      this.isAllow,
      this.errorMessage,
      this.isAlready,
      this.alreadyMessage,
      this.fDate,
      this.tDate});

  Result.fromJson(Map<String, dynamic> json) {
    megaSalesIndexId = json['megaSalesIndexId'];
    offerTitle = json['offerTitle'];
    totalDeals = json['totalDeals'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    allowFrom = json['allowFrom'];
    icon = json['icon'];
    showMenu = json['showMenu'];
    isAllow = json['isAllow'];
    errorMessage = json['errorMessage'];
    isAlready = json['isAlready'];
    alreadyMessage = json['alreadyMessage'];
    fDate = json['fDate'];
    tDate = json['tDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['megaSalesIndexId'] = this.megaSalesIndexId;
    data['offerTitle'] = this.offerTitle;
    data['totalDeals'] = this.totalDeals;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['allowFrom'] = this.allowFrom;
    data['icon'] = this.icon;
    data['showMenu'] = this.showMenu;
    data['isAllow'] = this.isAllow;
    data['errorMessage'] = this.errorMessage;
    data['isAlready'] = this.isAlready;
    data['alreadyMessage'] = this.alreadyMessage;
    data['fDate'] = this.fDate;
    data['tDate'] = this.tDate;
    return data;
  }
}
