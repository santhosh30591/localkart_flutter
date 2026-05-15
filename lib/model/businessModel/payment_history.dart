class PaymentHistoryModel {
  int? errorCode;
  String? message;
  List<Result>? result;

  PaymentHistoryModel({this.errorCode, this.message, this.result});

  PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
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
  String? package;
  String? paymentDate;
  String? validity;
  int? indexId;
  int? planType;
  String? amount;
  String? status;

  Result(
      {this.package,
      this.paymentDate,
      this.validity,
      this.indexId,
      this.planType,
      this.amount,
      this.status});

  Result.fromJson(Map<String, dynamic> json) {
    package = json['package'];
    paymentDate = json['paymentDate'];
    validity = json['validity'];
    indexId = json['indexId'];
    planType = json['planType'];
    amount = json['amount'].toString();
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['package'] = this.package;
    data['paymentDate'] = this.paymentDate;
    data['validity'] = this.validity;
    data['indexId'] = this.indexId;
    data['planType'] = this.planType;
    data['amount'] = this.amount.toString();
    data['Status'] = this.status;
    return data;
  }
}
