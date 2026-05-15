class TeansHistoryModel {
  int? errorCode;
  String? message;
  List<Results>? results;

  TeansHistoryModel({this.errorCode, this.message, this.results});

  TeansHistoryModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    message = json['message'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['message'] = this.message;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  String? userId;
  String? type;
  String? operator;
  String? number;
  String? invoiceNo;
  String? amount;
  String? paymentDate;
  String? name;
  String? referrenceid;
  int? status;

  Results({
    this.userId,
    this.type,
    this.operator,
    this.number,
    this.invoiceNo,
    this.amount,
    this.paymentDate,
    this.name,
    this.referrenceid,
    this.status,
  });

  Results.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    type = json['type'];
    operator = json['operator'];
    number = json['number'];
    invoiceNo = json['invoice_no'];
    amount = json['amount'];
    paymentDate = json['paymentDate'];
    name = json['name'];
    referrenceid = json['referrenceid'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['type'] = this.type;
    data['operator'] = this.operator;
    data['number'] = this.number;
    data['invoice_no'] = this.invoiceNo;
    data['amount'] = this.amount;
    data['paymentDate'] = this.paymentDate;
    data['name'] = this.name;
    data['referrenceid'] = this.referrenceid;
    data['status'] = this.status;
    return data;
  }
}
