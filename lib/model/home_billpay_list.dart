class HomeBillPayModel {
  int? errorCode;
  String? message;
  List<BillPayResults>? results;

  HomeBillPayModel({this.errorCode, this.message, this.results});

  HomeBillPayModel.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    message = json['message'];
    if (json['results'] != null) {
      results = <BillPayResults>[];
      json['results'].forEach((v) {
        results!.add(new BillPayResults.fromJson(v));
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

class BillPayResults {
  String? title;
  List<BillPayData>? data;

  BillPayResults({this.title, this.data});

  BillPayResults.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['data'] != null) {
      data = <BillPayData>[];
      json['data'].forEach((v) {
        data!.add(new BillPayData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BillPayData {
  int? id;
  String? name;
  String? icon;

  BillPayData({this.id, this.name, this.icon});

  BillPayData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['icon'] = this.icon;
    return data;
  }
}
