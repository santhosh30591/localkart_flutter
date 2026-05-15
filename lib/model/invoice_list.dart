import 'dart:ffi';

class InvoiceListModel {
  int? errorCode;
  String? message;
  List<InvoiceResult>? result;

  InvoiceListModel({this.errorCode, this.message, this.result});

  InvoiceListModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    message = json['message'];
    if (json['results'] != null) {
      result = <InvoiceResult>[];
      json['results'].forEach((v) {
        result!.add(new InvoiceResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorCode'] = this.errorCode;
    data['message'] = this.message;
    // if (this.result != null) {
    //   data['result'] = this.result!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class InvoiceResult {
  int? id;
  String? type;
  String? invoice_no;
  String? amount;
  String? date;

  InvoiceResult({this.id, this.type, this.invoice_no, this.amount, this.date});

  InvoiceResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    invoice_no = json['invoice_no'];
    amount = json['amount'];
    date = json['date'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['shopType'] = this.shopType;
  //   data['shopIndexId'] = this.shopIndexId;
  //   data['postIndexId'] = this.postIndexId;
  //   data['postType'] = this.postType;
  //   data['postHeading'] = this.postHeading;
  //   data['fromDate'] = this.fromDate;
  //   data['toDate'] = this.toDate;
  //   return data;
  // }
}

class InvoiceDetailsModel {
  int? errorCode;
  String? message;
  Result? result;

  InvoiceDetailsModel({this.errorCode, this.message, this.result});

  InvoiceDetailsModel.fromJson(Map<String, dynamic> json) {
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
  String? logo;
  String? company;
  String? companyAddress;
  String? invoiceNo;
  String? date;
  String? billText;
  String? billTo;
  List<Description>? description;
  String? subtotalText;
  String? subtotalValue;
  String? cgstText;
  String? cgstValue;
  String? sgstText;
  String? sgstValue;
  bool? isIgst;
  dynamic subTotal;
  dynamic discount;
  String? total;
  String? roundoffText;
  String? queries;
  String? signature;

  Result({
    this.logo,
    this.company,
    this.companyAddress,
    this.invoiceNo,
    this.date,
    this.billText,
    this.billTo,
    this.description,
    this.subtotalText,
    this.subtotalValue,
    this.cgstText,
    this.cgstValue,
    this.sgstText,
    this.sgstValue,
    this.isIgst,
    this.subTotal,
    this.discount,
    this.total,
    this.roundoffText,
    this.queries,
    this.signature,
  });

  Result.fromJson(Map<String, dynamic> json) {
    logo = json['logo'];
    company = json['company'];
    companyAddress = json['company_address'];
    invoiceNo = json['invoice_no'];
    date = json['date'];
    billText = json['bill_text'];
    billTo = json['bill_to'];
    if (json['description'] != null) {
      description = <Description>[];
      json['description'].forEach((v) {
        description!.add(new Description.fromJson(v));
      });
    }
    subtotalText = json['subtotal_text'];
    subtotalValue = json['subtotal_value'];
    cgstText = json['cgst_text'];
    cgstValue = json['cgst_value'];
    sgstText = json['sgst_text'];
    sgstValue = json['sgst_value'];
    isIgst = json['is_igst'];
    subTotal = json['sub_total'];
    discount = json['discount'];
    total = json['total'];
    roundoffText = json['roundoff_text'];
    queries = json['queries'];
    signature = json['signature'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['logo'] = this.logo;
    data['company'] = this.company;
    data['company_address'] = this.companyAddress;
    data['invoice_no'] = this.invoiceNo;
    data['date'] = this.date;
    data['bill_text'] = this.billText;
    data['bill_to'] = this.billTo;
    if (this.description != null) {
      data['description'] = this.description!.map((v) => v.toJson()).toList();
    }
    data['subtotal_text'] = this.subtotalText;
    data['subtotal_value'] = this.subtotalValue;
    data['cgst_text'] = this.cgstText;
    data['cgst_value'] = this.cgstValue;
    data['sgst_text'] = this.sgstText;
    data['sgst_value'] = this.sgstValue;
    data['is_igst'] = this.isIgst;
    data['sub_total'] = this.subTotal;
    data['discount'] = this.discount;
    data['total'] = this.total;
    data['roundoff_text'] = this.roundoffText;
    data['queries'] = this.queries;
    data['signature'] = this.signature;
    return data;
  }
}

class Description {
  dynamic? name;
  String? rate;
  dynamic? qty;
  String? amount;

  Description({this.name, this.rate, this.qty, this.amount});

  Description.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    rate = json['rate'];
    qty = json['qty'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['rate'] = this.rate;
    data['qty'] = this.qty;
    data['amount'] = this.amount;
    return data;
  }
}
